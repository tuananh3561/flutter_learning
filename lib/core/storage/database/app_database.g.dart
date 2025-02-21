// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DeviceInfoDao? _deviceInfoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `device_info` (`deviceId` TEXT NOT NULL, `isFirstTime` INTEGER NOT NULL, `lastLoginDate` TEXT, PRIMARY KEY (`deviceId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DeviceInfoDao get deviceInfoDao {
    return _deviceInfoDaoInstance ??= _$DeviceInfoDao(database, changeListener);
  }
}

class _$DeviceInfoDao extends DeviceInfoDao {
  _$DeviceInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _deviceInfoEntityInsertionAdapter = InsertionAdapter(
            database,
            'device_info',
            (DeviceInfoEntity item) => <String, Object?>{
                  'deviceId': item.deviceId,
                  'isFirstTime': item.isFirstTime ? 1 : 0,
                  'lastLoginDate': item.lastLoginDate
                }),
        _deviceInfoEntityUpdateAdapter = UpdateAdapter(
            database,
            'device_info',
            ['deviceId'],
            (DeviceInfoEntity item) => <String, Object?>{
                  'deviceId': item.deviceId,
                  'isFirstTime': item.isFirstTime ? 1 : 0,
                  'lastLoginDate': item.lastLoginDate
                }),
        _deviceInfoEntityDeletionAdapter = DeletionAdapter(
            database,
            'device_info',
            ['deviceId'],
            (DeviceInfoEntity item) => <String, Object?>{
                  'deviceId': item.deviceId,
                  'isFirstTime': item.isFirstTime ? 1 : 0,
                  'lastLoginDate': item.lastLoginDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DeviceInfoEntity> _deviceInfoEntityInsertionAdapter;

  final UpdateAdapter<DeviceInfoEntity> _deviceInfoEntityUpdateAdapter;

  final DeletionAdapter<DeviceInfoEntity> _deviceInfoEntityDeletionAdapter;

  @override
  Future<DeviceInfoEntity?> findDeviceById(String deviceId) async {
    return _queryAdapter.query('SELECT * FROM device_info WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => DeviceInfoEntity(
            deviceId: row['deviceId'] as String,
            isFirstTime: (row['isFirstTime'] as int) != 0,
            lastLoginDate: row['lastLoginDate'] as String?),
        arguments: [deviceId]);
  }

  @override
  Future<void> insertDevice(DeviceInfoEntity device) async {
    await _deviceInfoEntityInsertionAdapter.insert(
        device, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDevice(DeviceInfoEntity device) async {
    await _deviceInfoEntityUpdateAdapter.update(
        device, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDevice(DeviceInfoEntity device) async {
    await _deviceInfoEntityDeletionAdapter.delete(device);
  }
}
