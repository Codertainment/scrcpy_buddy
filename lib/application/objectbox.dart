import 'dart:io';

import 'package:scrcpy_buddy/service/snap_environment.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`
import 'model/profile.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<ObjectBox> create(SnapEnvironment snapEnvironment) async {
    final String dbPath = await snapEnvironment.getStoragePath();

    final dir = Directory(dbPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }

    final store = await openStore(directory: dbPath);
    return ObjectBox._create(store);
  }

  Box<Profile> get profileBox => store.box();
}
