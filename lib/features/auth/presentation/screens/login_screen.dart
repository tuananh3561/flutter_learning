import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
//routes
import '../../../../routes/route_constants.dart';
//bloc
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../bloc/login_event.dart';
//widgets
import '../widgets/phone_input_field.dart';
import '../widgets/password_input_field.dart';
import '../widgets/login_button.dart';

/// Handles user authentication and manages the login process.
///
/// This screen manages user input validation, authentication flow, and navigation
/// following a successful login. It uses BLoC pattern for state management and
/// follows clean architecture principles.
@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }

          if (state.user != null) {
            context.router.replaceNamed(RouteConstants.home);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                PhoneInputField(
                  value: state.phone,
                  error: state.phoneError,
                  onChanged: (value) => context.read<LoginBloc>().add(
                        LoginEvent.phoneChanged(value),
                      ),
                  onSubmitted: () => context.read<LoginBloc>().add(
                        const LoginEvent.validatePhone(),
                      ),
                ),
                const SizedBox(height: 16),
                PasswordInputField(
                  value: state.password,
                  error: state.passwordError,
                  onChanged: (value) => context.read<LoginBloc>().add(
                        LoginEvent.passwordChanged(value),
                      ),
                  onSubmitted: () => context.read<LoginBloc>().add(
                        const LoginEvent.validatePassword(),
                      ),
                ),
                const SizedBox(height: 24),
                LoginButton(
                  isLoading: state.isLoading,
                  onPressed: () => context.read<LoginBloc>().add(
                        const LoginEvent.loginSubmitted(),
                      ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // context.router.push(const ForgotPasswordRoute());
                  },
                  child: const Text('Quên mật khẩu?'),
                ),
                TextButton(
                  onPressed: () {
                    // context.router.push(const RegisterRoute());
                  },
                  child: const Text('Đăng ký tài khoản mới'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
