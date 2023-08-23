import 'package:flutter/material.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/image/image_widget.dart';
import '/app/widgets/text/text_x.dart';

class ReceiveButton extends StatelessWidget {
  const ReceiveButton(
    this.onPressed, {
    required this.selected,
    required this.title,
    required this.icon,
    this.height = 50,
    this.width,
    super.key,
  });

  final bool selected;
  final String title;
  final String icon;
  final void Function()? onPressed;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed,
      height: height,
      width: width ?? MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.zero,
      color: selected ? MainColors.color1 : Theme.of(context).cardColor,
      foregroundColor: selected ? Colors.white : null,
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          children: [
            ImageWidget(
              icon,
              height: 30,
              width: 60,
              radius: 6,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TextX(
                title,
                style: selected
                    ? const TextStyle(color: Colors.white, fontSize: 12)
                    : Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
