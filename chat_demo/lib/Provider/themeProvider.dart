import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  SharedPreferences sharedPreferences;
  int lightMode = THEMEMODE.LIGHT;
  int selColor = THEMECOLORMAPPING.BLUEGREY;
  Color themeColor = THEMECOLOR.BLUEGREY;
  ThemeProvider(SharedPreferences prefs) {
    sharedPreferences = prefs;
    if (prefs.containsKey('dark')) {
      lightMode = prefs.getInt('dark');
    }

    if (prefs.containsKey('color')) {
      selColor = prefs.getInt('color');
      themeColor = getThemeColorFromPrefs(selColor);
    }
  }

  changeSelColor(int index) {
    themeColor = getThemeColorFromPrefs(index);
    sharedPreferences.setInt('color', index);
    notifyListeners();
  }

  changeThemeMode() {
    lightMode = lightMode == THEMEMODE.DARK ? THEMEMODE.LIGHT : THEMEMODE.DARK;
    sharedPreferences.setInt('dark', lightMode).then((_) {
      notifyListeners();
    });
  }

  Color getThemeColorFromPrefs(int chooseColor) {
    // var chooseColor = pref.getInt('color');
    Color result;
    switch (chooseColor) {
      case THEMECOLORMAPPING.BLUEGREY:
        result = THEMECOLOR.BLUEGREY;
        break;
      case THEMECOLORMAPPING.YELLOW:
        result = THEMECOLOR.YELLOW;
        break;
      case THEMECOLORMAPPING.PURPLE:
        result = THEMECOLOR.PURPLE;
        break;
      case THEMECOLORMAPPING.RED:
        result = THEMECOLOR.RED;
        break;
      default:
        result = THEMECOLOR.BLUEGREY;
        break;
    }
    return result;
  }
}
