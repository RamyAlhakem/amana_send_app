import 'package:flutter/material.dart';

class ExpandButton extends StatelessWidget {
  const ExpandButton(
    this.onPressed,
    this.child, {
    Key? key,
    this.height,
    this.color,
    this.foregroundColor,
    this.borderColor = Colors.transparent,
    this.borderRadius = 10.0,
    this.customShape,
    this.padding,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final double? height;
  final Color? color;
  final Color? foregroundColor;
  final Color borderColor;
  final double borderRadius;
  final OutlinedBorder? customShape;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: padding,
            foregroundColor: foregroundColor,
            backgroundColor: color,
            side: BorderSide(color: borderColor),
            shape: customShape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        ),
      ),
    );
  }
}
