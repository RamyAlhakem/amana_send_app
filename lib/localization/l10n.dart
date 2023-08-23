import 'package:flutter/material.dart';

class L10n {
  static final Map<Locale, String> all = {
    const Locale('ar'): 'العربية',
    const Locale('en'): 'English',
  };
  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇦🇪';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
