import 'package:flutter/material.dart';

extension Underline on TextStyle {
  /// A method to underline a text with a customizable [distance] between the
  /// text and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underline({Color? color, double distance = 4}) {
    return copyWith(
      shadows: [
        Shadow(
          color: color ?? this.color ?? Colors.transparent,
          offset: Offset(0, -distance),
        )
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: color,
    );
  }

  TextStyle underlineDashed({Color? color, double distance = 4}) {
    return copyWith(
      shadows: [
        Shadow(
          color: color ?? this.color ?? Colors.transparent,
          offset: Offset(0, -distance),
        )
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: color,
      decorationStyle: TextDecorationStyle.dashed,
    );
  }
}
