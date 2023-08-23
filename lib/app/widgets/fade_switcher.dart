import 'package:flutter/material.dart';

import 'vertical_fade.dart';

class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({super.key, required this.child, this.delay});

  final Widget child;
  final int? delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: VerticalFade(key: UniqueKey(), child: child),
    );
  }
}
