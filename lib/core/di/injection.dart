import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/database/app_database.dart';
import './injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  if (!kIsWeb) {
    // Third party dependencies
    getIt.registerLazySingleton(() => InternetConnectionChecker());
  }

  // Register FlutterSecureStorage
  getIt.registerLazySingleton(() => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ));

  // Register SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(prefs);

  // Database
  final database = await AppDatabase.init();
  getIt.registerSingleton(database);
  getIt.registerSingleton(database.deviceInfoDao);

  getIt.init();
}
