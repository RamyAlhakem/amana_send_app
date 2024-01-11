import 'package:flutter/material.dart';

import '/localization/l10n.dart';
import '/services/lang_service.dart';
import '/services/theme_service.dart';
import '/services/user_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the UserService to store and retrieve user settings.
class AppSettings with ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  static String _token = '';

  String get token => _token;
  bool get loggedIn => _token.isNotEmpty;

  /// Load the user's settings from the ThemeService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings({bool rebuild = true}) async {
    _themeMode = await ThemeService.themeMode();
    _locale = await LangService.loadLang();
    _token = await UserService.saveUser();

    if (rebuild) notifyListeners();
  }

  /// Update and persist the [ThemeMode] based on the user's selection.
  Future<void> setThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    // if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    notifyListeners();

    // Persist the changes to a local database using the ThemeService.
    await ThemeService.setThemeMode(newThemeMode).whenComplete(
      () async => _themeMode = await ThemeService.themeMode(),
    );
  }

  // lang
  Future<void> setLang(Locale locale) async {
    if (!L10n.all.keys.contains(locale)) return;

    await LangService.loadLang();
    _locale = locale;
    notifyListeners();

    await LangService.setLang(locale.languageCode);
  }

  static void getToken(String token) => _token = token;

  static void clearToken() => _token = '';
}
