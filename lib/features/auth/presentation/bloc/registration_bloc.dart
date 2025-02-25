// lib/features/auth/presentation/bloc/registration_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_registration_status_usecase.dart';
import '../../domain/usecases/clear_registration_data_usecase.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/validate_field_usecase.dart';
import '../../domain/usecases/verify_phone_usecase.dart';
import '../../domain/validation/form_validation_helper.dart';
import 'registration_event.dart';
import 'registration_state.dart';

@injectable
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUserUseCase _registerUserUseCase;
  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final CheckRegistrationStatusUseCase _checkRegistrationStatusUseCase;
  final ClearRegistrationDataUseCase _clearRegistrationDataUseCase;
  final ValidateFieldUseCase _validateFieldUseCase;
  final FormValidationHelper _formValidationHelper;

  // Form data
  String _phone = '';
  String _password = '';
  String _name = '';
  String _deviceId = '';
  String? _deviceModel;
  String? _deviceType;
  String _otp = '';
  String? _token;
  Map<String, String> _formErrors = {};

  RegistrationBloc({
    required RegisterUserUseCase registerUserUseCase,
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyPhoneUseCase verifyPhoneUseCase,
    required CheckRegistrationStatusUseCase checkRegistrationStatusUseCase,
    required ClearRegistrationDataUseCase clearRegistrationDataUseCase,
    required ValidateFieldUseCase validateFieldUseCase,
    required FormValidationHelper formValidationHelper,
  })  : _registerUserUseCase = registerUserUseCase,
        _requestOtpUseCase = requestOtpUseCase,
        _verifyPhoneUseCase = verifyPhoneUseCase,
        _checkRegistrationStatusUseCase = checkRegistrationStatusUseCase,
        _clearRegistrationDataUseCase = clearRegistrationDataUseCase,
        _validateFieldUseCase = validateFieldUseCase,
        _formValidationHelper = formValidationHelper,
        super(const RegistrationState.initial()) {
    on<RegistrationEvent>((event, emit) async {
      await event.map(
        initialize: (e) => _onInitializeRegistration(e, emit),
        updatePhone: (e) => _onUpdatePhone(e, emit),
        updatePassword: (e) => _onUpdatePassword(e, emit),
        updateName: (e) => _onUpdateName(e, emit),
        updateDeviceInfo: (e) => _onUpdateDeviceInfo(e, emit),
        validateForm: (e) => _onValidateForm(e, emit),
        submitRegistration: (e) => _onSubmitRegistration(e, emit),
        requestOtp: (e) => _onRequestOtp(e, emit),
        updateOtp: (e) => _onUpdateOtp(e, emit),
        verifyOtp: (e) => _onVerifyOtp(e, emit),
        clearRegistration: (e) => _onClearRegistration(e, emit),
      );
    });
  }

  Future<void> _onInitializeRegistration(
    InitializeRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationState.loading());

    final result = await _checkRegistrationStatusUseCase(const NoParams());

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
            RegistrationState.error(message: _mapFailureToMessage(failure))),
        (status) {
          if (status.isInProgress) {
            if (status.isPhoneVerified) {
              emit(const RegistrationState.phoneVerified());
            } else {
              emit(const RegistrationState.formFilled());
            }
          } else {
            emit(const RegistrationState.form(errors: {}));
          }
        },
      );
    }
  }

  Future<void> _onUpdatePhone(
    UpdatePhoneEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    _phone = event.phone;

    // Validate phone number
    final error = await _formValidationHelper.validateField('phone', _phone);

    if (!emit.isDone) {
      // Update errors map
      final currentErrors = Map<String, String>.from(_formErrors);
      if (error != null) {
        currentErrors['phone'] = error;
      } else {
        currentErrors.remove('phone');
      }

      _formErrors = currentErrors;
      emit(RegistrationState.form(errors: _formErrors));
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    _password = event.password;

    // Validate password
    final error =
        await _formValidationHelper.validateField('password', _password);

    if (!emit.isDone) {
      // Update errors map
      final currentErrors = Map<String, String>.from(_formErrors);
      if (error != null) {
        currentErrors['password'] = error;
      } else {
        currentErrors.remove('password');
      }

      _formErrors = currentErrors;
      emit(RegistrationState.form(errors: _formErrors));
    }
  }

  Future<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    _name = event.name;

    // Validate name
    final error = await _formValidationHelper.validateField('name', _name);

    if (!emit.isDone) {
      // Update errors map
      final currentErrors = Map<String, String>.from(_formErrors);
      if (error != null) {
        currentErrors['name'] = error;
      } else {
        currentErrors.remove('name');
      }

      _formErrors = currentErrors;
      emit(RegistrationState.form(errors: _formErrors));
    }
  }

  Future<void> _onUpdateDeviceInfo(
    UpdateDeviceInfoEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    _deviceId = event.deviceId;
    _deviceModel = event.deviceModel;
    _deviceType = event.deviceType;
  }

  Future<void> _onValidateForm(
    ValidateFormEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationState.loading());

    final formData = {
      'phone': _phone,
      'password': _password,
      'name': _name,
    };

    final errors = await _formValidationHelper.validateForm(formData);

    if (!emit.isDone) {
      _formErrors = errors;

      if (errors.isEmpty) {
        emit(const RegistrationState.formFilled());
      } else {
        emit(RegistrationState.form(errors: errors));
      }
    }
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    // Validate form first
    await _onValidateForm(const ValidateFormEvent(), emit);

    // Continue only if no errors
    if (_formErrors.isEmpty && !emit.isDone) {
      emit(const RegistrationState.loading());

      final params = RegisterParams(
        phone: _phone,
        password: _password,
        name: _name,
        deviceId: _deviceId,
        deviceModel: _deviceModel,
        deviceType: _deviceType,
      );

      final result = await _registerUserUseCase(params);

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(
              RegistrationState.error(message: _mapFailureToMessage(failure))),
          (registrationResult) {
            if (registrationResult.success) {
              _token = registrationResult.token;
              emit(RegistrationState.success(result: registrationResult));
            } else {
              emit(RegistrationState.error(
                  message:
                      registrationResult.message ?? 'Registration failed'));
            }
          },
        );
      }
    }
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationState.otpLoading());

    final result = await _requestOtpUseCase(_phone);

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
            RegistrationState.otpError(message: _mapFailureToMessage(failure))),
        (success) {
          if (success) {
            emit(const RegistrationState.otpSent());
          } else {
            emit(const RegistrationState.otpError(
                message: 'Failed to send OTP'));
          }
        },
      );
    }
  }

  Future<void> _onUpdateOtp(
    UpdateOtpEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    _otp = event.otp;

    // Validate OTP
    final error = await _formValidationHelper.validateField('otp', _otp);

    if (!emit.isDone) {
      state.maybeMap(
        otpSent: (_) => emit(error != null
            ? RegistrationState.otpError(message: error)
            : const RegistrationState.otpSent()),
        otpError: (_) => emit(error != null
            ? RegistrationState.otpError(message: error)
            : const RegistrationState.otpSent()),
        orElse: () {},
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationState.otpLoading());

    final params = VerifyPhoneParams(
      phone: _phone,
      otp: _otp,
    );

    final result = await _verifyPhoneUseCase(params);

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
            RegistrationState.otpError(message: _mapFailureToMessage(failure))),
        (success) {
          if (success) {
            emit(const RegistrationState.phoneVerified());
          } else {
            emit(const RegistrationState.otpError(message: 'Invalid OTP code'));
          }
        },
      );
    }
  }

  Future<void> _onClearRegistration(
    ClearRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationState.loading());

    final result = await _clearRegistrationDataUseCase(const NoParams());

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
            RegistrationState.error(message: _mapFailureToMessage(failure))),
        (_) {
          // Reset form data
          _phone = '';
          _password = '';
          _name = '';
          _otp = '';
          _formErrors = {};

          emit(const RegistrationState.form(errors: {}));
        },
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return 'Please check your internet connection';
      case ValidationFailure:
        return failure.message;
      default:
        return 'An unexpected error occurred';
    }
  }
}
