import 'package:flutter/material.dart';

import '/app/extensions/dark_mode.dart';
import '../colors/main_colors.dart';
import '/app/theme/gradient/gradients.dart';

class Decorations {
  static BoxDecoration main(
    BuildContext context, {
    double radius = 6.0,
    Color? color,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: color ?? Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? const Color(0xff5e5d5d).withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  static BoxDecoration customMain(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).scaffoldBackgroundColor,
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static BoxDecoration note(BuildContext context, {double radius = 6.0}) {
    return BoxDecoration(
      color: MainColors.red.withOpacity(context.isDarkMode ? 0.1 : 0.05),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration flat(BuildContext context, {double radius = 2}) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        if (!context.isDarkMode)
          BoxShadow(
            color: const Color(0xff5e5d5d).withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
      ],
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration border(
    BuildContext context, {
    double radius = 6.0,
    double width = 1.0,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Theme.of(context).dividerColor, width: width),
    );
  }

  static BoxDecoration arrows = BoxDecoration(
    gradient: Gradients.arrowButton,
    borderRadius: BorderRadius.circular(4),
  );
}
