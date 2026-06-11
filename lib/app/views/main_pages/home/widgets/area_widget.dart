import 'package:amana_send/app/extensions/dark_mode.dart';
import 'package:amana_send/app/theme/colors/main_colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '/app/widgets/text/text_x.dart';
import '/models/city.dart';
import '/services/lang_service.dart';

class AreaWidget extends StatelessWidget {
  const AreaWidget(
      {required this.city,
      required this.selected,
      super.key,
      this.borderRadius});

  final CityModel city;
  final bool selected;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.transparent,
          // context.isDarkMode
          // ? Colors.black.withValues(alpha: 0.3)
          // : Colors.white.withValues(alpha: 0.4),
          border: Border.all(
              width: 2,
              color: selected ? MainColors.color2 : Colors.transparent)
          // ? Border.all(
          //     color: context.isDarkMode ? Colors.white : Colors.black,
          //     width: 2)
          // : null
          // selected ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
          ),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Container(
              //     padding: const EdgeInsets.all(6),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: context.isDarkMode
              //           ? Colors.white.withValues(alpha: 0.3)
              //           : Colors.grey.withValues(alpha: 0.5),
              //     ),
              //     child:
              Icon(LineIcons.city,
                  color: context.isDarkMode ? Colors.white : Colors.black),
              // Icon(
              //   Icons.location_on,
              //   color: context.isDarkMode ? Colors.white : Colors.black,
              //   size: 20,
              // ),
              // ),
              const SizedBox(width: 12),
              TextX(
                LangService.isAR() ? city.name : city.name,
                style: TextStyle(
                    color:
                        //  selected
                        //     ?
                        context.isDarkMode ? Colors.white : Colors.black
                    // : Colors.white
                    ),
              ),
            ],
          ),
          if (selected)
            const Icon(Icons.check_circle, color: Colors.green
                //  context.isDarkMode ? Colors.white : Colors.black,
                )
        ],
      ),
    );
  }
}
