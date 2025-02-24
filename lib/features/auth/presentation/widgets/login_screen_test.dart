// test/features/auth/presentation/widgets/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../screens/login_screen.dart';
import 'login_button.dart';
import 'password_input_field.dart';
import 'phone_input_field.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  testWidgets('should show error when phone number is invalid',
      (WidgetTester tester) async {
    // arrange
    when(mockLoginBloc.state).thenReturn(LoginState(
      phoneError: 'Invalid phone number',
    ));

    // act
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: LoginScreen(),
      ),
    ));

    // assert
    expect(find.text('Invalid phone number'), findsOneWidget);
  });

  testWidgets(
      'should call login when form is valid and submit button is pressed',
      (WidgetTester tester) async {
    // arrange
    when(mockLoginBloc.state).thenReturn(LoginState());

    // act
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: LoginScreen(),
      ),
    ));

    await tester.enterText(find.byType(PhoneInputField), '0123456789');
    await tester.enterText(find.byType(PasswordInputField), 'password123');
    await tester.tap(find.byType(LoginButton));
    await tester.pump();

    // assert
    verify(mockLoginBloc.add(const LoginEvent.loginSubmitted())).called(1);
  });
}
