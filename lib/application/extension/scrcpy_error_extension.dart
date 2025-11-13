import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';

extension ScrcpyErrorExtension on ScrcpyError {
  String get message {
    // TODO: i18n-ize error messages
    switch (runtimeType) {
      case const (UnknownScrcpyError):
        return (this as UnknownScrcpyError).exception?.toString() ?? 'Unknown error';
      case const (ScrcpyNotFoundError):
        return 'Scrcpy not found';
      case const (ScrcpyKillError):
        return "Failed to stop scrcpy: ${(this as ScrcpyKillError).message}";
      default:
        return "Unknown error";
    }
  }
}
