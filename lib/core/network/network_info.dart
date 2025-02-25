// lib/core/network/network_info.dart
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker? connectionChecker;

  // Sửa constructor để xử lý khi không có InternetConnectionChecker
  @factoryMethod
  NetworkInfoImpl.create()
      : connectionChecker =
            kIsWeb ? null : GetIt.instance<InternetConnectionChecker>();

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // For web platform
      // try {
      //   final response = await http
      //       .get(
      //     Uri.parse('https://www.google.com'),
      //   )
      //       .timeout(
      //     const Duration(seconds: 10),
      //     onTimeout: () {
      //       throw TimeoutException('Request timeout');
      //     },
      //   );
      //   return response.statusCode == 200;
      // } catch (e) {
      //   return false;
      // }
      return true;
    } else {
      // For mobile platforms
      return await connectionChecker?.hasConnection ?? false;
    }
  }
}
