class AdbDevice {
  final String serial;
  final AdbDeviceStatus status;
  final List<String>? metadata;

  const AdbDevice({
    required this.serial,
    this.status = AdbDeviceStatus.offline,
    this.metadata,
  });

  bool get isReady => status == AdbDeviceStatus.device;
}

enum AdbDeviceStatus { offline, device, unauthorized }