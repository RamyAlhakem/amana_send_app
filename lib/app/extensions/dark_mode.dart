import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  bool get isDarkMode {
    final Brightness brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
