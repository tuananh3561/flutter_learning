import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/device_info_dao.dart';
import 'entities/device_info_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [DeviceInfoEntity])
abstract class AppDatabase extends FloorDatabase {
  DeviceInfoDao get deviceInfoDao;

  static Future<AppDatabase> init() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
