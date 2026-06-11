import 'package:amana_send/app/extensions/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/text/text_x.dart';
import '/models/city.dart';
import '/services/lang_service.dart';

class City extends StatelessWidget {
  const City(
      {required this.city,
      required this.selected,
      super.key,
      this.isExpanded = false});

  final CityModel city;
  final bool selected;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // color: context.isDarkMode
      //     ? Colors.black.withValues(alpha: 0.6)
      //     : Colors.white70.withValues(alpha: 0.8)),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isExpanded
                  ? Icon(Icons.arrow_drop_down,
                      color: context.isDarkMode ? Colors.white : Colors.black)
                  : Icon(Icons.arrow_right,
                      color: context.isDarkMode ? Colors.white : Colors.black),
              const SizedBox(width: 12),
              TextX(
                LangService.isAR() ? city.name : city.name,
                style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
          if (selected)
            const HeroIcon(HeroIcons.checkCircle, color: Colors.white)
        ],
      ),
    );
  }
}
