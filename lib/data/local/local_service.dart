import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static final LocaleService _instance = LocaleService._init();

  late SharedPreferences _preferences;
  static LocaleService get instance => _instance;

  LocaleService._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static preferencesInit() async {
    instance._preferences = await SharedPreferences.getInstance();
    return;
  }

  Future<void> setStringValue(String key, String value) async {
    await _preferences.setString(key.toString(), value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key.toString(), value);
  }

  String getStringValue(String key) =>
      _preferences.getString(key.toString()) ?? "";

  List getStringList(String key) =>
      _preferences.getStringList(key.toString()) ?? [];

  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  void clear() => _preferences.clear();

  void remove(String key) => _preferences.remove(key);

  String getValue(String key) => _preferences.getString(key.toString()) ?? "";

  bool containKey(String key) => _preferences.containsKey(key);
}