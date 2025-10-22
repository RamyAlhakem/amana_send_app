import 'package:flutter/material.dart';

import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/text/text_x.dart';
import '/services/lang_service.dart';

class PickerForm extends StatelessWidget {
  const PickerForm(this.onTap,
      {super.key,
      required this.hint,
      this.value = '',
      this.height,
      this.width,
      this.borderRadius = 8,
      this.align = MainAxisAlignment.spaceBetween,
      this.color,
      this.hintIcon,
      this.valueIcon,
      this.borderColor});

  final String hint;
  final String value;
  final void Function()? onTap;
  final double? height, width;
  final double borderRadius;
  final MainAxisAlignment align;
  final Color? color;
  final Color? borderColor;
  final Widget? hintIcon;
  final Widget? valueIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: height ?? kTextTabBarHeight,
          width: width,
          margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
          decoration: GeneralWidgets.formDecoration(
            borderColor: borderColor,
            context,
            color: color,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: align,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        valueIcon ?? const SizedBox.shrink(),
                        if (valueIcon != null) const SizedBox(width: 4),
                        Flexible(
                          child: TextX(
                            value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.expand_more_rounded, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: LangService.isAR() ? 4 : null,
          left: LangService.isAR() ? null : 4,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(3),
            ),
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Row(
              children: [
                hintIcon ?? const SizedBox.shrink(),
                if (hintIcon != null) const SizedBox(width: 4),
                TextX(
                  hint,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
