import 'package:floor/floor.dart';
import '../entities/device_info_entity.dart';

@dao
abstract class DeviceInfoDao {
  @Query('SELECT * FROM device_info WHERE deviceId = :deviceId')
  Future<DeviceInfoEntity?> findDeviceById(String deviceId);

  @insert
  Future<void> insertDevice(DeviceInfoEntity device);

  @update
  Future<void> updateDevice(DeviceInfoEntity device);

  @delete
  Future<void> deleteDevice(DeviceInfoEntity device);
}
