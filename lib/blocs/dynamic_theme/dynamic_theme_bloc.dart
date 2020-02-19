import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_viewer_8/blocs/bloc_base.dart';

class DynamicThemeBloc extends BlocBase {
//  DynamicThemeBloc

  @override
  void dispose() {}
}

class DynamicThemeController {
  static const _themeKey = 'theme_mode';

  static final DynamicThemeController _instance = DynamicThemeController._();

  DynamicThemeController._() : _data = DynamicThemeData();

  factory DynamicThemeController() => _instance;

  DynamicThemeData get data => _data;
  final DynamicThemeData _data;

  ThemeMode _defaultThemeMode;

  static setThemes(ThemeData theme, ThemeData darkTheme, ThemeMode defaultThemeMode) {
    if (_instance._defaultThemeMode == null) {
      _instance._defaultThemeMode = defaultThemeMode;
      DynamicThemeData._setThemes(theme, darkTheme);
    }
  }

  void toggleThemeMode() {
    _data._toggleThemeMode();
  }

  void saveThemeMode() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_themeKey, _data.themeMode.index);
    });
  }

  Future<void> reloadThemeMode() async {
    await _loadThemeMode();
  }

  Future<ThemeMode> _loadThemeMode() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_themeKey)) {
        _data._setThemeMode(ThemeMode.values.elementAt(prefs.getInt(_themeKey)));
      } else {
        _data._setThemeMode(_defaultThemeMode);
      }
      return _data.themeMode;
    });
  }
}

class DynamicThemeData {
  static final DynamicThemeData _instance = DynamicThemeData._();

  DynamicThemeData._();

  factory DynamicThemeData() => _instance;

  static _setThemes(ThemeData theme, ThemeData darkTheme) {
    _instance._theme = theme;
    _instance._darkTheme = darkTheme;
  }

  ThemeData get theme => _theme;
  ThemeData _theme;

  ThemeData get darkTheme => _darkTheme;
  ThemeData _darkTheme;

  ThemeMode get themeMode => _themeMode;
  ThemeMode _themeMode;

  void _toggleThemeMode() => _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  void _setThemeMode(ThemeMode themeMode) => _themeMode = themeMode;
}
