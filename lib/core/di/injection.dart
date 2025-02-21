import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../storage/database/app_database.dart';
import './injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  // Third party dependencies
  getIt.registerLazySingleton(() => InternetConnectionChecker());

  // Database
  final database = await AppDatabase.init();
  getIt.registerSingleton(database);
  getIt.registerSingleton(database.deviceInfoDao);

  getIt.init();
}
