import 'dart:ui';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          height: height,
          width: width ?? MediaQuery.of(context).size.width,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
          child: child,
        ),
      ),
    );
  }
}
