import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/shared_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AppSettings {
  static const _PREFIX = "settings";
  static const _KEY_SCRCPY_EXECUTABLE = "scrcpyExecutable";
  static const _KEY_THEME_BRIGHTNESS = "theme.brightness";
  static const _KEY_IS_LAST_USED_PROFILE_DEFAULT = "isLastUsedProfileDefault";
  static const _KEY_DEFAULT_PROFILE_ID = "defaultProfileId";

  AppSettings(SharedPrefs prefs)
    : scrcpyExecutable = prefs.getString(prefix: _PREFIX, key: _KEY_SCRCPY_EXECUTABLE),
      themeBrightness = prefs.getBrightness(prefix: _PREFIX, key: _KEY_THEME_BRIGHTNESS),
      isLastUsedProfileDefault = prefs.getBool(prefix: _PREFIX, key: _KEY_IS_LAST_USED_PROFILE_DEFAULT, defaultValue: true),
      defaultProfileId = prefs.getInt(prefix: _PREFIX, key: _KEY_DEFAULT_PROFILE_ID);

  final Preference<String> scrcpyExecutable;
  final Preference<Brightness?> themeBrightness;
  final Preference<bool> isLastUsedProfileDefault;
  final Preference<int> defaultProfileId;
}
