import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:shared_preferences/src/shared_preferences_legacy.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPrefs {
  Future<void> initialize() async {
    _prefs = await StreamingSharedPreferences.instance;
  }

  late final StreamingSharedPreferences _prefs;

  String _key(String? prefix, String key) => "${prefix != null ? "$prefix." : ""}$key";

  Preference<String> getString({String? prefix, required String key}) {
    return _prefs.getString(_key(prefix, key), defaultValue: '');
  }

  Preference<int> getInt({String? prefix, required String key}) {
    return _prefs.getInt(_key(prefix, key), defaultValue: -1);
  }

  Preference<Brightness?> getBrightness({String? prefix, required String key}) {
    return _prefs.getCustomValue(_key(prefix, key), defaultValue: null, adapter: _BrightnessAdapter());
  }

  Preference<bool> getBool({String? prefix, required String key, bool defaultValue = false}) {
    return _prefs.getBool(_key(prefix, key), defaultValue: defaultValue);
  }

  Future<void> remove({String? prefix, required String key}) async {
    await _prefs.remove(_key(prefix, key));
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}

class _BrightnessAdapter extends PreferenceAdapter<Brightness?> {
  @override
  Brightness? getValue(SharedPreferences preferences, String key) {
    final storedValue = preferences.getString(key);
    if (storedValue == null) return null;
    return Brightness.values.where((brightness) => brightness.name == storedValue).firstOrNull;
  }

  @override
  Future<bool> setValue(SharedPreferences preferences, String key, Brightness? value) {
    if (value == null) return preferences.remove(key);
    return preferences.setString(key, value.name);
  }
}
