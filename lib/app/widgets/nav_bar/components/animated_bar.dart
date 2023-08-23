import 'package:flutter/material.dart';

import '/app/theme/colors/main_colors.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({required this.isActive, super.key});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 3),
      height: 4,
      width: isActive ? 40 : 0,
      decoration: const BoxDecoration(
        color: MainColors.color2,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
