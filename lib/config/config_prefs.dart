import 'package:shared_preferences/shared_preferences.dart';

class ConfigPreference {
  // prevent making instance
  ConfigPreference._();

  // get storage
  static late SharedPreferences sharedPreferencesInstance;

  // STORING KEYS
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isFirstLaunchKey = 'is_first_launch';

  /// init get storage services
  static Future<void> init() async {
    sharedPreferencesInstance = await SharedPreferences.getInstance();
  }

  static SharedPreferences getStorage() => sharedPreferencesInstance;

  static setStorage(SharedPreferences sharedPreferences) {
    sharedPreferencesInstance = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      sharedPreferencesInstance.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      sharedPreferencesInstance.getBool(_lightThemeKey) ?? true;
  // todo set the default theme (true for light, false for dark)

  /// check if the app is first launch
  static bool isFirstLaunch() =>
      sharedPreferencesInstance.getBool(_isFirstLaunchKey) ?? true;

  /// est first launch flag to false
  static Future<void> setFirstLaunchCompleted() =>
      sharedPreferencesInstance.setBool(_isFirstLaunchKey, false);
}
