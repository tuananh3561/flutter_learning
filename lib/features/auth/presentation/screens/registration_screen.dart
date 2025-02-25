// lib/features/auth/presentation/screens/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection.dart';
import '../../../../routes/app_router.gr.dart';
import '../../../../routes/route_constants.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import '../widgets/registration_form.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationBloc _registrationBloc;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _registrationBloc = getIt<RegistrationBloc>();
    _initDeviceInfo();
    _registrationBloc.add(const RegistrationEvent.initialize());
  }

  Future<void> _initDeviceInfo() async {
    try {
      final deviceId = const Uuid().v4();
      String? deviceModel;
      String? deviceType;

      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        deviceType = 'android';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceModel = '${iosInfo.name} ${iosInfo.systemVersion}';
        deviceType = 'ios';
      }

      _registrationBloc.add(RegistrationEvent.updateDeviceInfo(
        deviceId: deviceId,
        deviceModel: deviceModel,
        deviceType: deviceType,
      ));
    } catch (e) {
      // Handle the error, but still continue with a fallback device ID
      final deviceId = const Uuid().v4();
      _registrationBloc.add(RegistrationEvent.updateDeviceInfo(
        deviceId: deviceId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registrationBloc,
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          state.maybeMap(
            formFilled: (_) {
              // Navigate to OTP verification
              context.router.push(const PhoneVerificationRoute());
            },
            success: (state) {
              // Navigate to home or profile creation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful')),
              );
              context.router.replaceAll([const HomeRoute()]);
            },
            error: (state) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Account'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // context.router.pop();
                },
              ),
            ),
            body: SafeArea(
              child: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(RegistrationState state) {
    return state.maybeMap(
      loading: (_) => const Center(child: CircularProgressIndicator()),
      form: (state) => RegistrationFormWidget(errors: state.errors),
      orElse: () => const RegistrationFormWidget(errors: {}),
    );
  }

  @override
  void dispose() {
    // Don't close the bloc here as it's managed by the dependency injection
    super.dispose();
  }
}
