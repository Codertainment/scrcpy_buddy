import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPrefs {
  Future<void> initialize() async {
    _prefs = await StreamingSharedPreferences.instance;
  }

  late final StreamingSharedPreferences _prefs;

  String _key(String? prefix, String key) => "${prefix != null ? "$prefix." : ""}key";

  Future<void> setString({String? prefix, required String key, required String value}) async {
    await _prefs.setString(_key(prefix, key), value);
  }

  Preference<String> getString({String? prefix, required String key}) {
    return _prefs.getString(_key(prefix, key), defaultValue: '');
  }

  Future<void> setBool({String? prefix, required String key, required bool value}) async {
    await _prefs.setBool(_key(prefix, key), value);
  }

  Preference<bool> getBool({String? prefix, required String key}) {
    return _prefs.getBool(_key(prefix, key), defaultValue: false);
  }

  Future<void> remove({String? prefix, required String key}) async {
    await _prefs.remove(_key(prefix, key));
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
