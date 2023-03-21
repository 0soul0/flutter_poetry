import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUnit {
  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  storage(String key, dynamic value) async {
    await init();
    await prefs.setString(key, value.toString());
  }

  read(String key, String defaultValue) async {
    await init();
    if (!prefs.containsKey(key)) {
      return defaultValue;
    }
    return prefs.getString(key)!;
  }

}
