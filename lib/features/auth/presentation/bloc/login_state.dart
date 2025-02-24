import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    @Default('') String phone,
    @Default('') String password,
    @Default('') String phoneError,
    @Default('') String passwordError,
    User? user,
    String? error,
  }) = _LoginState;
}
