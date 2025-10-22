import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';

extension AdbDeviceExtension on AdbDevice {
  bool get isReady => status == AdbDeviceStatus.device;

  String? get model => metadata?["model"]?.replaceAll("_", " ");

  String? get codename => metadata?["device"];

  bool get isUsb {
    return metadata?.keys.where((key) => key.contains("usb")).isNotEmpty ?? false;
  }

  bool get isWifi => !isUsb;
}
