import 'package:flappy_dash/features/games/commons/audio/audio_helper.dart';
import 'package:flappy_dash/features/games/flappy_dash/bloc/game/game_cubit.dart';
import 'package:flappy_dash/features/games/flappy_dash/pages/main_page.dart';
import 'package:flappy_dash/features/games/commons/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GameCubit(
        getIt.get<AudioHelper>(),
      ),
      child: MaterialApp(
        title: 'Flappy Dash',
        theme: ThemeData(fontFamily: 'Chewy'),
        home: const MainPage(),
      ),
    );
  }
}
