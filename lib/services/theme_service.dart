import 'package:flutter/material.dart';

import '/database/injector.dart';
import '/models/user_base.dart';

class ThemeService {
  /// Loads the user's preferred [ThemeMode] from local or remote storage.
  static ThemeMode? mode;

  static Future<ThemeMode> themeMode() async {
    final UserBase user = Database().getUserBase;

    final String theme = user.theme;

    switch (theme) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
    }

    return mode ?? ThemeMode.light;
  }

  /// Persists the user's preferred [ThemeMode] to local or remote storage.
  static Future<void> setThemeMode(ThemeMode themeValue) async {
    final UserBase user = Database().getUserBase;

    switch (themeValue) {
      case ThemeMode.light:
        user.theme = 'light';
        break;

      case ThemeMode.dark:
        user.theme = 'dark';
        break;

      case ThemeMode.system:
        user.theme = 'system';
        break;

      default:
        user.theme = 'system';
    }

    Database().setUserBase = user;
  }
}
