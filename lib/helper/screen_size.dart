import 'package:flutter/material.dart';

class ScreenSize {
  static final MediaQueryData window = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.single,
  );

  // Screen size in density independent pixels
  static final width = (window.size.shortestSide / window.devicePixelRatio);
  static final height = (window.size.longestSide / window.devicePixelRatio);

// Screen size in real pixels
  static final widthPixels = window.size.shortestSide;
  static final heightPixels = window.size.longestSide;

  static final isTablet = window.size.shortestSide >= 600;
}
