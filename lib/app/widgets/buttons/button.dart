import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
    this.onPressed,
    this.child, {
    Key? key,
    this.height,
    this.width,
    this.color,
    this.foregroundColor,
    this.borderColor = Colors.transparent,
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
    this.customShape,
    this.padding,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final double? height, width;
  final Color? color;
  final Color? foregroundColor;
  final Color borderColor;
  final double borderRadius, borderWidth;
  final OutlinedBorder? customShape;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: padding ?? const EdgeInsets.fromLTRB(8, 2, 8, 2),
          foregroundColor: foregroundColor,
          backgroundColor: color,
          side: BorderSide(color: borderColor, width: borderWidth),
          shape: customShape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      ),
    );
  }
}
