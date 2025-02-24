import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/validate_phone_usecase.dart';
import '../../domain/usecases/validate_password_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// Manages authentication state and business logic.
///
/// Handles events:
/// - [PhoneChanged]: When user types in phone number
/// - [PasswordChanged]: When user types in password
/// - [LoginSubmitted]: When user submits login form
/// - [ValidatePhone]: Validates phone number format
/// - [ValidatePassword]: Validates password requirements
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final ValidatePhoneUseCase _validatePhoneUseCase;
  final ValidatePasswordUseCase _validatePasswordUseCase;

  LoginBloc(
    this._loginUseCase,
    this._validatePhoneUseCase,
    this._validatePasswordUseCase,
  ) : super(const LoginState()) {
    on<PhoneChanged>(_onPhoneChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ValidatePhone>(_onValidatePhone);
    on<ValidatePassword>(_onValidatePassword);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      phone: event.phone,
      phoneError: '',
      error: null,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
      passwordError: '',
      error: null,
    ));
  }

  void _onValidatePhone(ValidatePhone event, Emitter<LoginState> emit) {
    final result = _validatePhoneUseCase(state.phone);
    result.fold(
      (failure) => emit(state.copyWith(phoneError: failure.message)),
      (_) => emit(state.copyWith(phoneError: '')),
    );
  }

  void _onValidatePassword(ValidatePassword event, Emitter<LoginState> emit) {
    final result = _validatePasswordUseCase(state.password);
    result.fold(
      (failure) => emit(state.copyWith(passwordError: failure.message)),
      (_) => emit(state.copyWith(passwordError: '')),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isLoading) return;

    // Validate inputs
    add(const LoginEvent.validatePhone());
    add(const LoginEvent.validatePassword());

    if (state.phoneError.isNotEmpty || state.passwordError.isNotEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _loginUseCase(
      LoginParams(
        phoneNumber: state.phone,
        password: state.password,
        deviceId: 'device_id',
        // deviceId: await _deviceInfoService.getDeviceId(),
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }
}
