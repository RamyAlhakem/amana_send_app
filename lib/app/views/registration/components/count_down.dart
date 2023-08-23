import 'package:flutter/material.dart';
import '/app/widgets/text/text_x.dart';

class Countdown extends AnimatedWidget {
  const Countdown({
    Key? key,
    required this.animation,
    this.size = 35,
    this.color = Colors.blueGrey,
  }) : super(key: key, listenable: animation);

  final Animation<int> animation;
  final double size;
  final Color? color;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation!.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

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
