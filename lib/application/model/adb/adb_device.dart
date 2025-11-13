import 'package:equatable/equatable.dart';

class AdbDevice extends Equatable {
  final String serial;
  final AdbDeviceStatus status;
  final Map<String, String>? metadata;

  const AdbDevice({required this.serial, this.status = AdbDeviceStatus.offline, this.metadata});

  @override
  List<Object?> get props => [serial, status, metadata];
}

enum AdbDeviceStatus { offline, device, sideload, recovery, authorizing, unauthorized }
