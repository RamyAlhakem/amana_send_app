import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SyrFlag extends StatelessWidget {
  final double? width;
  final double? height;
  const SyrFlag({super.key,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?? 28,
      height: height?? 28,
      child: ClipOval(
        child: SvgPicture.asset(
          "assets/icons/syr.svg",
          width:width?? 28,
          height:height?? 28,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
