import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {

  static const String prefKeyIsWordOfTheDayScheduled = "wordOfTheDay";

  static void setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key)?? false;
  }
}