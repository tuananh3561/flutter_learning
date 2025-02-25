// lib/features/auth/data/datasources/registration_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/registration_request_model.dart';
import '../models/registration_response_model.dart';
import '../models/user_profile_model.dart';

abstract class RegistrationRemoteDataSource {
  /// Calls the [ApiEndpoints.register] endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<RegistrationResponseModel> register(RegistrationRequestModel request);

  /// Calls the [ApiEndpoints.requestOtp] endpoint to request an OTP.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> requestOtp(String phone);

  /// Calls the [ApiEndpoints.verifyOtp] endpoint to verify an OTP.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> verifyOtp(String phone, String otp);

  /// Calls the [ApiEndpoints.createProfile] endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserProfileModel> createProfile(
      UserProfileModel profile, String token);
}

@Injectable(as: RegistrationRemoteDataSource)
class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient apiClient;

  RegistrationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<RegistrationResponseModel> register(
      RegistrationRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      return RegistrationResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusCode ?? 500,
        e.response?.data['message'] ?? 'Registration failed',
      );
    } catch (e) {
      throw ServerException(500, 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> requestOtp(String phone) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.requestOtp,
        data: {'phone': phone},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusCode ?? 500,
        e.response?.data['message'] ?? 'Failed to request OTP',
      );
    } catch (e) {
      throw ServerException(500, 'Failed to request OTP: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      return response.data['success'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusCode ?? 500,
        e.response?.data['message'] ?? 'OTP verification failed',
      );
    } catch (e) {
      throw ServerException(500, 'OTP verification failed: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> createProfile(
      UserProfileModel profile, String token) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createProfile,
        data: profile.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusCode ?? 500,
        e.response?.data['message'] ?? 'Failed to create profile',
      );
    } catch (e) {
      throw ServerException(500, 'Failed to create profile: ${e.toString()}');
    }
  }
}
