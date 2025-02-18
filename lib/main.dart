import 'package:flappy_dash/features/games/commons/service_locator.dart';
import 'package:flappy_dash/features/games/flip_card_2/presentation/screens/flip_card_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (BuildContext context) => GameCubit(
    //     getIt.get<AudioHelper>(),
    //   ),
    //   child: MaterialApp(
    //     title: 'Flappy Dash',
    //     theme: ThemeData(fontFamily: 'Chewy'),
    //     home: const FlipCardScreen(),
    //   ),
    // );

    return MaterialApp(
      title: 'Flip Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlipCardScreen(),
    );
  }
}
