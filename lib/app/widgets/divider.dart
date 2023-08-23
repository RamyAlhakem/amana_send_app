import 'package:flutter/material.dart';

class HDivider extends StatelessWidget {
  const HDivider({
    this.height = 12,
    this.thickness = 0.8,
    this.color,
    super.key,
  });

  final double? height, thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}

class VDivider extends StatelessWidget {
  const VDivider({
    this.thickness,
    this.color,
    Key? key,
  }) : super(key: key);

  final double? thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      thickness: thickness ?? 0.6,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}
