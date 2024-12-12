import 'package:amana_send/app/views/main_pages/home/widgets/syria_flag.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/text/text_x.dart';
import '/models/country.dart';
import '/services/lang_service.dart';

class Country extends StatelessWidget {
  const Country({
    required this.country,
    required this.selected,
    this.registration = false,
    super.key,
  });

  final CountryModel country;
  final bool selected;
  final bool registration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (country.coCode.isNotEmpty)
                country.coCode == "sy"
                    ? const SyrFlag()
                    : Flag.fromString(
                        country.coCode,
                        height: 30,
                        width: 30,
                        fit: BoxFit.fill,
                        borderRadius: 100,
                      ),
              const SizedBox(width: 12),
              TextX(
                LangService.isAR() ? country.arName : country.enName,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 6),
              Visibility(
                visible: registration,
                replacement: TextX(
                  '(${country.currency.code})',
                  style: const TextStyle(color: Colors.white),
                ),
                child: TextX(
                  '+${country.phoneCode}',
                  style: const TextStyle(color: Colors.white),
                ),
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
