import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RefreshButton extends AnimatedWidget {
  const RefreshButton({
    super.key,
    required this.animation,
    required this.callback,
  }) : super(listenable: animation);

  final VoidCallback callback;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: animation.value,
      child: IconButton(
        icon: const Icon(LineIcons.syncIcon),
        onPressed: () => callback(),
      ),
    );
  }
}
