import 'package:amana_send/app/extensions/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:line_icons/line_icons.dart';

import '/app/widgets/text/text_x.dart';
import '/models/city.dart';
import '/services/lang_service.dart';

class AreaWidget extends StatelessWidget {
  const AreaWidget({required this.city, required this.selected, super.key});

  final CityModel city;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            selected ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LineIcons.city,
                  color: selected
                      ? context.isDarkMode
                          ? Colors.white
                          : Colors.black
                      : Colors.white),
              const SizedBox(width: 12),
              TextX(
                LangService.isAR() ? city.name : city.name,
                style: TextStyle(
                    color: selected
                        ? context.isDarkMode
                            ? Colors.white
                            : Colors.black
                        : Colors.white),
              ),
            ],
          ),
          if (selected)
            Icon(
              Icons.check_circle,
              color: context.isDarkMode ? Colors.white : Colors.black,
            )
        ],
      ),
    );
  }
}
