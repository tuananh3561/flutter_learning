import 'package:injectable/injectable.dart';
import '../device_info_model.dart';
import '../../../domain/entities/device_info.dart';
import '../../../../../core/storage/database/entities/device_info_entity.dart';

@injectable
class DeviceInfoMapper {
  DeviceInfo modelToEntity(DeviceInfoModel model) {
    return DeviceInfo(
      deviceId: model.deviceId,
      isFirstTime: model.isFirstTime,
    );
  }

  DeviceInfoModel entityToModel(DeviceInfo entity) {
    return DeviceInfoModel(
      deviceId: entity.deviceId,
      isFirstTime: entity.isFirstTime,
    );
  }

  DeviceInfoEntity modelToDbEntity(DeviceInfoModel model) {
    return DeviceInfoEntity(
      deviceId: model.deviceId,
      isFirstTime: model.isFirstTime,
      lastLoginDate: model.lastLoginDate,
    );
  }

  DeviceInfoModel dbEntityToModel(DeviceInfoEntity entity) {
    return DeviceInfoModel(
      deviceId: entity.deviceId,
      isFirstTime: entity.isFirstTime,
      lastLoginDate: entity.lastLoginDate,
    );
  }
}
