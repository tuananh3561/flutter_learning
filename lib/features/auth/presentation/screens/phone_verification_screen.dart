// lib/features/auth/presentation/screens/phone_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/di/injection.dart';
import '../../../../routes/route_constants.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';

@RoutePage()
class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  late final RegistrationBloc _registrationBloc;
  final TextEditingController _otpController = TextEditingController();

  // OTP Resend Timer
  Timer? _resendTimer;
  int _resendSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _registrationBloc = getIt<RegistrationBloc>();
    _requestOtp();
    _startResendTimer();
  }

  void _requestOtp() {
    _registrationBloc.add(const RegistrationEvent.requestOtp());
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registrationBloc,
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          state.maybeMap(
            phoneVerified: (_) {
              // Navigate to next step after phone verification
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Phone verification successful')),
              );
              _registrationBloc
                  .add(const RegistrationEvent.submitRegistration());
            },
            otpError: (state) {
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
              title: const Text('Phone Verification'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // context.router.pop();
                },
              ),
            ),
            body: SafeArea(
              child: state.maybeMap(
                otpLoading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                orElse: () => _buildVerificationForm(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationForm(RegistrationState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.phone_android,
              size: 72,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Verify Your Phone Number',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'We have sent a verification code to your phone number. Please enter the code below.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // OTP Input Field
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey[300],
                selectedColor: Colors.blue,
              ),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _registrationBloc.add(RegistrationEvent.updateOtp(value));
              },
              onCompleted: (value) {
                // Auto-submit when OTP is complete
                _registrationBloc.add(const RegistrationEvent.verifyOtp());
              },
            ),
            const SizedBox(height: 24),

            // Error message
            state.maybeMap(
              otpError: (state) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            // Resend Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code? ",
                  style: TextStyle(fontSize: 14),
                ),
                _canResend
                    ? TextButton(
                        onPressed: () {
                          _requestOtp();
                          _startResendTimer();
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text(
                        'Resend in $_resendSeconds seconds',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 32),

            // Verify Button
            ElevatedButton(
              onPressed: () {
                if (_otpController.text.length == 6) {
                  _registrationBloc.add(const RegistrationEvent.verifyOtp());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter the complete OTP code')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
