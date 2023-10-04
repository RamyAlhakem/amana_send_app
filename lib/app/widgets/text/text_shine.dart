import 'package:flutter/material.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/shimmer/shimmer_shine.dart';
import 'text_x.dart';

class TextShine extends StatelessWidget {
  const TextShine(this.text, {super.key, this.fontSize, this.fontWeight});
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return ShimmerShine(
      baseColor: MainColors.color2,
      highlightColor: MainColors.color1,
      child: TextX(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
