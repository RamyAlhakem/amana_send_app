import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import '/database/injector.dart';
import '/models/user_base.dart';

class LangService {
  /// Loads the user's preferred [Lang] from local or remote storage.
  static Locale? locale;

  static Future<Locale?> loadLang() async {
    final UserBase user = Database().getUserBase;

    final String? lang = user.lang;

    final String defaultLang = kIsWeb
        ? (WidgetsBinding.instance.platformDispatcher.locale.languageCode)
        : Platform.localeName.substring(0, 2);

    locale = Locale(lang ?? defaultLang);

    return locale;
  }

  /// Persists the user's preferred [Lang] to local or remote storage.
  static Future<void> setLang(String lang) async {
    final UserBase user = Database().getUserBase;

    user.lang = lang;

    Database().setUserBase = user;
    await loadLang();
  }

  static bool isAR() => locale?.languageCode == 'ar';
}
