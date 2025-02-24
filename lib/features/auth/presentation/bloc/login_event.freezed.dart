// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoginEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginEventCopyWith<$Res> {
  factory $LoginEventCopyWith(
          LoginEvent value, $Res Function(LoginEvent) then) =
      _$LoginEventCopyWithImpl<$Res, LoginEvent>;
}

/// @nodoc
class _$LoginEventCopyWithImpl<$Res, $Val extends LoginEvent>
    implements $LoginEventCopyWith<$Res> {
  _$LoginEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PhoneChangedImplCopyWith<$Res> {
  factory _$$PhoneChangedImplCopyWith(
          _$PhoneChangedImpl value, $Res Function(_$PhoneChangedImpl) then) =
      __$$PhoneChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phone});
}

/// @nodoc
class __$$PhoneChangedImplCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$PhoneChangedImpl>
    implements _$$PhoneChangedImplCopyWith<$Res> {
  __$$PhoneChangedImplCopyWithImpl(
      _$PhoneChangedImpl _value, $Res Function(_$PhoneChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_$PhoneChangedImpl(
      null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PhoneChangedImpl implements PhoneChanged {
  const _$PhoneChangedImpl(this.phone);

  @override
  final String phone;

  @override
  String toString() {
    return 'LoginEvent.phoneChanged(phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneChangedImpl &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phone);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneChangedImplCopyWith<_$PhoneChangedImpl> get copyWith =>
      __$$PhoneChangedImplCopyWithImpl<_$PhoneChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) {
    return phoneChanged(phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) {
    return phoneChanged?.call(phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) {
    if (phoneChanged != null) {
      return phoneChanged(phone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) {
    return phoneChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) {
    return phoneChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) {
    if (phoneChanged != null) {
      return phoneChanged(this);
    }
    return orElse();
  }
}

abstract class PhoneChanged implements LoginEvent {
  const factory PhoneChanged(final String phone) = _$PhoneChangedImpl;

  String get phone;

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneChangedImplCopyWith<_$PhoneChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PasswordChangedImplCopyWith<$Res> {
  factory _$$PasswordChangedImplCopyWith(_$PasswordChangedImpl value,
          $Res Function(_$PasswordChangedImpl) then) =
      __$$PasswordChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$PasswordChangedImplCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$PasswordChangedImpl>
    implements _$$PasswordChangedImplCopyWith<$Res> {
  __$$PasswordChangedImplCopyWithImpl(
      _$PasswordChangedImpl _value, $Res Function(_$PasswordChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_$PasswordChangedImpl(
      null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PasswordChangedImpl implements PasswordChanged {
  const _$PasswordChangedImpl(this.password);

  @override
  final String password;

  @override
  String toString() {
    return 'LoginEvent.passwordChanged(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordChangedImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordChangedImplCopyWith<_$PasswordChangedImpl> get copyWith =>
      __$$PasswordChangedImplCopyWithImpl<_$PasswordChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) {
    return passwordChanged(password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) {
    return passwordChanged?.call(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class PasswordChanged implements LoginEvent {
  const factory PasswordChanged(final String password) = _$PasswordChangedImpl;

  String get password;

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordChangedImplCopyWith<_$PasswordChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginSubmittedImplCopyWith<$Res> {
  factory _$$LoginSubmittedImplCopyWith(_$LoginSubmittedImpl value,
          $Res Function(_$LoginSubmittedImpl) then) =
      __$$LoginSubmittedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginSubmittedImplCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$LoginSubmittedImpl>
    implements _$$LoginSubmittedImplCopyWith<$Res> {
  __$$LoginSubmittedImplCopyWithImpl(
      _$LoginSubmittedImpl _value, $Res Function(_$LoginSubmittedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginSubmittedImpl implements LoginSubmitted {
  const _$LoginSubmittedImpl();

  @override
  String toString() {
    return 'LoginEvent.loginSubmitted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginSubmittedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) {
    return loginSubmitted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) {
    return loginSubmitted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) {
    return loginSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) {
    return loginSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted(this);
    }
    return orElse();
  }
}

abstract class LoginSubmitted implements LoginEvent {
  const factory LoginSubmitted() = _$LoginSubmittedImpl;
}

/// @nodoc
abstract class _$$ValidatePhoneImplCopyWith<$Res> {
  factory _$$ValidatePhoneImplCopyWith(
          _$ValidatePhoneImpl value, $Res Function(_$ValidatePhoneImpl) then) =
      __$$ValidatePhoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ValidatePhoneImplCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$ValidatePhoneImpl>
    implements _$$ValidatePhoneImplCopyWith<$Res> {
  __$$ValidatePhoneImplCopyWithImpl(
      _$ValidatePhoneImpl _value, $Res Function(_$ValidatePhoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ValidatePhoneImpl implements ValidatePhone {
  const _$ValidatePhoneImpl();

  @override
  String toString() {
    return 'LoginEvent.validatePhone()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ValidatePhoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) {
    return validatePhone();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) {
    return validatePhone?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) {
    if (validatePhone != null) {
      return validatePhone();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) {
    return validatePhone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) {
    return validatePhone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) {
    if (validatePhone != null) {
      return validatePhone(this);
    }
    return orElse();
  }
}

abstract class ValidatePhone implements LoginEvent {
  const factory ValidatePhone() = _$ValidatePhoneImpl;
}

/// @nodoc
abstract class _$$ValidatePasswordImplCopyWith<$Res> {
  factory _$$ValidatePasswordImplCopyWith(_$ValidatePasswordImpl value,
          $Res Function(_$ValidatePasswordImpl) then) =
      __$$ValidatePasswordImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ValidatePasswordImplCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$ValidatePasswordImpl>
    implements _$$ValidatePasswordImplCopyWith<$Res> {
  __$$ValidatePasswordImplCopyWithImpl(_$ValidatePasswordImpl _value,
      $Res Function(_$ValidatePasswordImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ValidatePasswordImpl implements ValidatePassword {
  const _$ValidatePasswordImpl();

  @override
  String toString() {
    return 'LoginEvent.validatePassword()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ValidatePasswordImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phoneChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() loginSubmitted,
    required TResult Function() validatePhone,
    required TResult Function() validatePassword,
  }) {
    return validatePassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String phone)? phoneChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? loginSubmitted,
    TResult? Function()? validatePhone,
    TResult? Function()? validatePassword,
  }) {
    return validatePassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phoneChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? loginSubmitted,
    TResult Function()? validatePhone,
    TResult Function()? validatePassword,
    required TResult orElse(),
  }) {
    if (validatePassword != null) {
      return validatePassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PhoneChanged value) phoneChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(ValidatePhone value) validatePhone,
    required TResult Function(ValidatePassword value) validatePassword,
  }) {
    return validatePassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PhoneChanged value)? phoneChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(ValidatePhone value)? validatePhone,
    TResult? Function(ValidatePassword value)? validatePassword,
  }) {
    return validatePassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PhoneChanged value)? phoneChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(ValidatePhone value)? validatePhone,
    TResult Function(ValidatePassword value)? validatePassword,
    required TResult orElse(),
  }) {
    if (validatePassword != null) {
      return validatePassword(this);
    }
    return orElse();
  }
}

abstract class ValidatePassword implements LoginEvent {
  const factory ValidatePassword() = _$ValidatePasswordImpl;
}
