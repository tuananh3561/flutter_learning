// // lib/core/di/injection_module.dart
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// @module
// abstract class InjectionModule {
//   // You can use this approach instead of registering directly in configureDependencies
//   // This is more in line with injectable package patterns

//   @lazySingleton
//   InternetConnectionChecker get internetConnectionChecker =>
//       InternetConnectionChecker();

//   @lazySingleton
//   FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
//         aOptions: AndroidOptions(
//           encryptedSharedPreferences: true,
//         ),
//         iOptions: IOSOptions(
//           accessibility: KeychainAccessibility.first_unlock,
//         ),
//       );

//   // For dependencies that need to be initialized asynchronously like SharedPreferences,
//   // you should still register them directly in the configureDependencies function.
// }
