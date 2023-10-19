import 'package:flutter/material.dart';

import 'vertical_fade.dart';

class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({super.key, required this.child, this.delay = 150});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: delay),
      reverseDuration: Duration(milliseconds: delay),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: VerticalFade(key: UniqueKey(), child: child),
    );
  }
}
