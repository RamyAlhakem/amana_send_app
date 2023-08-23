import 'package:flutter/material.dart';

import '../../theme/colors/main_colors.dart';
import '/services/lang_service.dart';
import 'shimmer.dart';

class ShimmerShine extends StatelessWidget {
  const ShimmerShine({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = 3,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? MainColors.color1,
      highlightColor: highlightColor ?? MainColors.color1.withOpacity(0.4),
      period: Duration(seconds: duration),
      direction:
          LangService.isAR() ? ShimmerDirection.rtl : ShimmerDirection.ltr,
      child: child,
    );
  }
}
