import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';

extension AdbDeviceExtension on AdbDevice {
  bool get isReady => status == AdbDeviceStatus.device;

  String? get model => metadata?["model"]?.replaceAll("_", " ");

  String? get codename => metadata?["device"];

  bool get isUsb {
    return metadata?.keys.where((key) => key.contains("usb")).isNotEmpty ?? false;
  }

  bool get isNetwork => !isUsb;

  IconData get statusIcon {
    switch (status) {
      case AdbDeviceStatus.offline:
        return WindowsIcons.network_offline;
      case AdbDeviceStatus.device:
        if (isUsb) {
          return WindowsIcons.usb;
        } else {
          return WindowsIcons.wifi;
        }
      case AdbDeviceStatus.recovery:
        return WindowsIcons.incident_triangle;
      case AdbDeviceStatus.sideload:
        return WindowsIcons.download;
      case AdbDeviceStatus.unauthorized:
        return FluentIcons.user_warning;
    }
  }

  String get statusText {
    switch (status) {
      case AdbDeviceStatus.offline:
        return 'common.deviceState.offline';
      case AdbDeviceStatus.device:
        if (isUsb) {
          return 'common.deviceState.usb';
        } else {
          return 'common.deviceState.network';
        }
      case AdbDeviceStatus.recovery:
        return 'common.deviceState.recovery';
      case AdbDeviceStatus.sideload:
        return 'common.deviceState.sideload';
      case AdbDeviceStatus.unauthorized:
        return 'common.deviceState.unauthorized';
    }
  }
}
