import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';

extension AdbErrorExtension on AdbError {
  String get message {
    // TODO: i18n-ize error messages
    switch (runtimeType) {
      case const (UnknownAdbError):
        return (this as UnknownAdbError).exception?.toString() ?? 'Unknown error';
      case const (AdbNotFoundError):
        return 'ADB not found';
      case const (AdbConnectError):
        return "Failed to connect: ${(this as AdbConnectError).message}";
      case const (AdbGetDeviceIpError):
        return "Failed to get device IP: ${(this as AdbGetDeviceIpError).message}";
      case const (AdbSwitchToTcpIpError):
        return "Failed to switch to network: ${(this as AdbSwitchToTcpIpError).message}";
      case const (AdbDisconnectError):
        return "Failed to disconnect: ${(this as AdbDisconnectError).message}";
      default:
        return "Unknown error";
    }
  }
}
