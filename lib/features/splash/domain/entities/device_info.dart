import 'package:equatable/equatable.dart';

class DeviceInfo extends Equatable {
  final String deviceId;
  final bool isFirstTime;

  const DeviceInfo({
    required this.deviceId,
    required this.isFirstTime,
  });

  @override
  List<Object?> get props => [deviceId, isFirstTime];
}
