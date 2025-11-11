import 'package:scrcpy_buddy/application/shared_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AppSettings {
  static const _PREFIX = "settings";
  static const _KEY_SCRCPY_EXECUTABLE = "scrcpyExecutable";

  AppSettings(SharedPrefs prefs) : scrcpyExecutable = prefs.getString(prefix: _PREFIX, key: _KEY_SCRCPY_EXECUTABLE);

  final Preference<String> scrcpyExecutable;
}
