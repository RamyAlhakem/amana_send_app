import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BlurryContainer extends StatelessWidget {
  const BlurryContainer({
    required this.child,
    this.sigmaX = 18,
    this.sigmaY = 18,
    this.height,
    this.width,
    this.radius,
    this.color = Colors.black12,
    this.padding,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final double sigmaX;
  final double sigmaY;

  final double? height, width, radius;
  final Color color;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final double effectiveSigmaX = kIsWeb ? 0 : sigmaX;
    final double effectiveSigmaY = kIsWeb ? 0 : sigmaY;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveSigmaX,
          sigmaY: effectiveSigmaY,
        ),
        child: Container(
          height: height,
          width: width ?? MediaQuery.of(context).size.width,
          padding: padding,
          decoration: BoxDecoration(
            color: _effectiveColor,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
          child: child,
        ),
      ),
    );
  }

  Color get _effectiveColor {
    if (!kIsWeb) return color;

    // On web (HTML renderer), BackdropFilter blur is unreliable, so we use a
    // more opaque solid color to approximate the frosted-glass effect.
    final Color base = color == Colors.transparent ? Colors.black12 : color;
    final double targetAlpha = (base.a * 255) + 80;
    return base.withValues(
      alpha: targetAlpha.clamp(0, 255) / 255,
    );
  }
}
