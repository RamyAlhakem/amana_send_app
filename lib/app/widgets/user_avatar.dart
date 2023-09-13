import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../theme/colors/main_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.maxRadius,
    this.size = 24,
    this.code = '',
    this.icon,
  });

  final double? maxRadius;
  final double size;
  final String code;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: maxRadius,
          width: maxRadius,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MainColors.color1.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: MainColors.color1),
          ),
          child: icon ??
              HeroIcon(HeroIcons.user, color: MainColors.color1, size: size),
        ),
        if (code.isNotEmpty)
          Positioned(
            top: -4,
            right: -4,
            child: Flag.fromString(
              code,
              height: 22,
              width: 22,
              borderRadius: 100,
              fit: BoxFit.fill,
            ),
          ),
      ],
    );
  }
}
