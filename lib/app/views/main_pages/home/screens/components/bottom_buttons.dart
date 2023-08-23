import 'package:flutter/material.dart';

import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.firstButton,
    this.secondButton,
    this.thirdButton,
  });

  final Widget firstButton;
  final Widget? secondButton, thirdButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HDivider(height: 0),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RowSpaceBetween([
                firstButton,
                if (secondButton != null) const SizedBox(width: 12),
                secondButton ?? const SizedBox(),
              ]),
              if (thirdButton != null) const SizedBox(height: 12),
              if (thirdButton != null) thirdButton ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
