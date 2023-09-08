import 'package:amana_send/models/agent.dart';
import 'package:flutter/material.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/image/image_widget.dart';
import '/app/widgets/text/text_x.dart';

class AgentButton extends StatelessWidget {
  const AgentButton(
    this.onPressed, {
    required this.selected,
    required this.agent,
    this.height = 50,
    this.width,
    super.key,
  });

  final bool selected;
  final AgentModel agent;
  final void Function()? onPressed;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Button(
          onPressed,
          height: height,
          padding: EdgeInsets.zero,
          color: Theme.of(context).cardColor,
          borderColor: selected ? MainColors.color2 : Colors.transparent,
          borderWidth: 2,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                ImageWidget(
                  agent.iconUrl,
                  height: 30,
                  width: 60,
                  radius: 6,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextX(
                    agent.name,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selected)
          Positioned(
            top: -8,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: MainColors.color2, width: 2),
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ),
          ),
      ],
    );
  }
}
