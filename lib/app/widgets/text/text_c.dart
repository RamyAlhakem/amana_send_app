import 'package:flutter/material.dart';

class TextC extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const TextC(this.text,
      {Key? key,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.maxLines,
      this.textWidthBasis,
      this.textHeightBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
