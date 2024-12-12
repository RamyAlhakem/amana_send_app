import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SyrFlag extends StatelessWidget {
  const SyrFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
                width: 28,
                height: 28,
                child: ClipOval(
                  child: SvgPicture.asset(
                    "assets/icons/syr.svg",
                    width: 28,
                    height: 28,
                    fit: BoxFit.fill,
                  ),
                ),
              );
  }
}