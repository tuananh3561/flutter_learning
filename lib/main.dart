// import 'package:flame/game.dart';
// import 'package:flame_spine/flame_spine.dart';
// import 'package:flappy_dash/features/games/commons/audio/audio_helper.dart';
// import 'package:flappy_dash/features/games/commons/service_locator.dart';
// import 'package:flappy_dash/features/games/commons/widget/background.dart';
// import 'package:flappy_dash/features/games/flappy_dash/bloc/game/game_cubit.dart';
// import 'package:flappy_dash/features/games/flappy_dash/flame_spine_example.dart';
// import 'package:flappy_dash/features/games/flappy_dash/pages/main_page.dart';
// import 'package:flappy_dash/features/games/flip_card_2/presentation/screens/flip_card_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'core/di/injection.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Dependencies
//   await configureDependencies();
//   // Spine
//   await initSpineFlutter();
//   // Service locator
//   // await setupServiceLocator();
//   // runApp(const GameWidget.controlled(gameFactory: FlameSpineExample.new));
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return BlocProvider(
//     //   create: (BuildContext context) => GameCubit(
//     //     getIt.get<AudioHelper>(),
//     //   ),
//     //   child: MaterialApp(
//     //     title: 'Flappy Dash',
//     //     theme: ThemeData(fontFamily: 'Chewy'),
//     //     home: const Stack(
//     //       children: [
//     //         Background(),
//     //         FlipCardScreen(),
//     //       ],
//     //     ),
//     //   ),
//     // );

//     return MaterialApp(
//       title: 'Flip Card Game',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const Background(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'core/di/injection.dart';
// import 'routes/app_router.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await configureDependencies();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   final _appRouter = AppRouter();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Your App',
//       routerConfig: _appRouter.config(),
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//     );
//   }
// }

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'features/games/octopy_splash/octopy_splash_game.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: OctopySplashGame(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
