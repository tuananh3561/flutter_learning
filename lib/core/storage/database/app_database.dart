import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'daos/device_info_dao.dart';
import 'entities/device_info_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [DeviceInfoEntity])
abstract class AppDatabase extends FloorDatabase {
  DeviceInfoDao get deviceInfoDao;

  static Future<AppDatabase> init() async {
    // Khởi tạo database factory cho web
    if (kIsWeb) {
      sqflite.databaseFactory = databaseFactoryFfiWeb;
    }

    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
