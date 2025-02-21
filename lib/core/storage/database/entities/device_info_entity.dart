import 'package:floor/floor.dart';

@Entity(tableName: 'device_info')
class DeviceInfoEntity {
  @primaryKey
  final String deviceId;
  final bool isFirstTime;
  final String? lastLoginDate;

  DeviceInfoEntity({
    required this.deviceId,
    required this.isFirstTime,
    this.lastLoginDate,
  });
}
