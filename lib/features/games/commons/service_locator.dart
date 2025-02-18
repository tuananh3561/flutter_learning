import 'package:flappy_dash/features/games/flip_card_2/audio_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // getIt.registerLazySingleton<AudioHelper>(() => AudioHelper());

  getIt.registerLazySingleton<AudioService>(() => AudioService());
}
