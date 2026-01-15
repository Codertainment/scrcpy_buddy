import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`
import 'model/profile.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<ObjectBox> create() async {
    // Get snap-safe directory
    final String dbPath = await _getStoragePath();

    // Ensure directory exists
    final dir = Directory(dbPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }

    final store = await openStore(directory: dbPath);
    return ObjectBox._create(store);
  }

  Box<Profile> get profileBox => store.box();

  static Future<String> _getStoragePath() async {
    // Check if running in snap
    final snapUserCommon = Platform.environment['SNAP_USER_COMMON'];
    final snapUserData = Platform.environment['SNAP_USER_DATA'];

    if (snapUserCommon != null) {
      // Use SNAP_USER_COMMON for persistent data across snap revisions
      return path.join(snapUserCommon, 'scrcpy_buddy');
    } else if (snapUserData != null) {
      // Use SNAP_USER_DATA (backed up on snap refresh)
      return path.join(snapUserData, 'scrcpy_buddy');
    } else {
      // Not running as snap, use default location
      final docsDir = await getApplicationDocumentsDirectory();
      return path.join(docsDir.path, "scrcpy_buddy");
    }
  }
}
