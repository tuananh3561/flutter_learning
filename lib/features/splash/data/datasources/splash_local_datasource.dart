import 'package:injectable/injectable.dart';
import '../../../../core/storage/database/entities/device_info_entity.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/database/app_database.dart';
import '../models/device_info_model.dart';

abstract class SplashLocalDataSource {
  Future<DeviceInfoModel?> getDeviceInfo();
  Future<void> saveDeviceInfo(DeviceInfoModel deviceInfo);
  Future<bool> isFirstTime();
  Future<String?> getAuthToken();
}

@Injectable(as: SplashLocalDataSource)
class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SecureStorage _secureStorage;
  final AppDatabase _database;

  SplashLocalDataSourceImpl(this._secureStorage, this._database);

  @override
  Future<DeviceInfoModel?> getDeviceInfo() async {
    final deviceId = await _secureStorage.getDeviceId();
    if (deviceId == null) return null;

    final deviceInfo = await _database.deviceInfoDao.findDeviceById(deviceId);
    if (deviceInfo == null) return null;

    return DeviceInfoModel(
      deviceId: deviceInfo.deviceId,
      isFirstTime: deviceInfo.isFirstTime,
      lastLoginDate: deviceInfo.lastLoginDate,
    );
  }

  @override
  Future<void> saveDeviceInfo(DeviceInfoModel deviceInfo) async {
    await _secureStorage.saveDeviceId(deviceInfo.deviceId);
    await _database.deviceInfoDao.insertDevice(
      DeviceInfoEntity(
        deviceId: deviceInfo.deviceId,
        isFirstTime: deviceInfo.isFirstTime,
        lastLoginDate: deviceInfo.lastLoginDate,
      ),
    );
  }

  @override
  Future<bool> isFirstTime() async {
    final deviceInfo = await getDeviceInfo();
    return deviceInfo?.isFirstTime ?? true;
  }

  @override
  Future<String?> getAuthToken() async {
    return _secureStorage.getAuthToken();
  }
}
