import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:line_icons/line_icons.dart';

import '/app/widgets/text/text_x.dart';
import '/models/city.dart';
import '/services/lang_service.dart';

class City extends StatelessWidget {
  const City({required this.city, required this.selected, super.key});

  final CityModel city;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LineIcons.city, color: Colors.white),
              const SizedBox(width: 12),
              TextX(
                LangService.isAR() ? city.name : city.name,
                style: const TextStyle(color: Colors.white),
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
