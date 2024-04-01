import 'package:flutter/material.dart';
import '/app/widgets/text/text_x.dart';

class Countdown extends AnimatedWidget {
  const Countdown({
    super.key,
    required this.animation,
    this.size = 35,
    this.color = Colors.blueGrey,
  }) : super(listenable: animation);

  final Animation<int> animation;
  final double size;
  final Color? color;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inHours > 0 ? '${clockTimer.inHours.remainder(24).toString().padLeft(2, '0')}:' : ''}${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return TextX(
      timerText,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
