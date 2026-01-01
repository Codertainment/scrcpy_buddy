import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';

final _ipRegex = RegExp(
  r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?):(?:[0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$",
);

extension AdbDeviceExtension on AdbDevice {
  bool get isReady => status == AdbDeviceStatus.device;

  String? get model => metadata?["model"]?.replaceAll("_", " ");

  String? get codename => metadata?["device"];

  bool get isUsb {
    return !_ipRegex.hasMatch(serial);
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
      case AdbDeviceStatus.authorizing:
        return WindowsIcons.settings;
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
      case AdbDeviceStatus.authorizing:
        return 'common.deviceState.authorizing';
      case AdbDeviceStatus.unauthorized:
        return 'common.deviceState.unauthorized';
    }
  }
}
