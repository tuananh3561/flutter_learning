import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/device_info_model.dart';
import '../models/api_response_model.dart';

abstract class SplashRemoteDataSource {
  Future<DeviceInfoModel> registerDevice(String deviceId);
}

@Injectable(as: SplashRemoteDataSource)
class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final ApiClient _apiClient;

  SplashRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DeviceInfoModel> registerDevice(String deviceId) async {
    return DeviceInfoModel(
      deviceId: "1212124",
      isFirstTime: false,
      lastLoginDate: "1111",
    );
    // try {
    //   final response = await _apiClient.post(
    //     '/device/register',
    //     data: {
    //       'deviceId': deviceId,
    //     },
    //   );

    //   final apiResponse = ApiResponseModel.fromJson(response.data);

    //   if (!apiResponse.success) {
    //     throw Exception(apiResponse.message);
    //   }

    //   return DeviceInfoModel.fromJson(apiResponse.data!);
    // } catch (e) {
    //   throw Exception('Failed to register device: $e');
    // }
  }
}
