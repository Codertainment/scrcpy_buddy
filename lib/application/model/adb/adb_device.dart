import 'package:equatable/equatable.dart';

class AdbDevice extends Equatable {
  final String serial;
  final AdbDeviceStatus status;
  final Map<String, String>? metadata;

  const AdbDevice({required this.serial, this.status = AdbDeviceStatus.offline, this.metadata});

  bool get isReady => status == AdbDeviceStatus.device;

  @override
  List<Object?> get props => [serial, status, metadata];
}

enum AdbDeviceStatus { offline, device, unauthorized }
