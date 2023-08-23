import 'dart:ui';

class DartUI {
  // Screen size in density independent pixels
  static final screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  static final screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

// Screen size in real pixels
  static final screenWidthPixels = window.physicalSize.shortestSide;
  static final screenHeightPixels = window.physicalSize.longestSide;

  static final isTablet = screenWidth >= 600;
}
