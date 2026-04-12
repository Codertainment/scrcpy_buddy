import 'dart:developer' as developer;
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Provides information about the Snap environment the app may be running in.
class SnapEnvironment {
  /// Returns `true` if the application is running inside a Snap package.
  bool get isRunningInSnap => Platform.environment['SNAP'] != null;

  /// Returns the correct persistent storage directory for the app,
  /// respecting the Snap environment variables when running as a Snap.
  ///
  /// Priority: `SNAP_USER_COMMON` → `SNAP_USER_DATA` → system app support dir.
  Future<String> getStoragePath() async {
    final snapUserCommon = Platform.environment['SNAP_USER_COMMON'];
    final snapUserData = Platform.environment['SNAP_USER_DATA'];

    if (snapUserCommon != null) {
      return path.join(snapUserCommon, 'scrcpy_buddy');
    } else if (snapUserData != null) {
      return path.join(snapUserData, 'scrcpy_buddy');
    } else {
      final dir = await getApplicationSupportDirectory();
      return path.join(dir.path, 'scrcpy_buddy_db');
    }
  }

  /// Returns the scrcpy binary path for the Snap bundle, or `null` if the
  /// bundle path cannot be determined or the binary does not exist there.
  String? getSnapScrcpyPath() {
    final snapPath = Platform.environment['SNAP'];
    if (snapPath == null) return null;

    developer.log('SNAP_PATH: $snapPath', name: 'scrcpy_buddy.snap');
    final scrcpyPath = '$snapPath/scrcpy-runtime/usr/local/bin/scrcpy';
    return File(scrcpyPath).existsSync() ? scrcpyPath : null;
  }

  /// Returns the path to the tray icon in the Snap bundle, or `null` if the
  /// bundle path cannot be determined.
  String? getSnapTrayIconPath(String iconName) {
    final snapDir = Platform.environment['SNAP'];
    if (snapDir == null) return null;
    return '$snapDir/data/flutter_assets/assets/tray/$iconName.png';
  }
}
