import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';

import '/app/views/main_pages/home/widgets/city.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/services/lang_service.dart';

class CityPicker extends StatelessWidget {
  const CityPicker({
    super.key,
    required this.onChange,
    required this.country,
    required this.cities,
    required this.city,
    this.fieldColor,
  });

  final CountryModel? country;
  final List<CityModel> cities;
  final CityModel? city;
  final Function(CityModel) onChange;
  final Color? fieldColor;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final bool isAr = LangService.isAR();
    return Container(
      height: kTextTabBarHeight,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      decoration: GeneralWidgets.formDecoration(
        context,
        color: fieldColor ?? Colors.transparent,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          if (cities.isEmpty) {
            if (country == null || (country ?? CountryModel()).cities.isEmpty) {
              return Helper.toast(arb.selectCountry);
            }
          }
          SettingsDialog(
            onSubmit: null,
            title: arb.cities,
            subTitle: arb.selectCityFromTheListBelow,
            subTitleStyle: const TextStyle(color: Colors.white, fontSize: 14),
            horizontalPadding: 0,
            content: (state) => Scrollbar(
              interactive: true,
              thumbVisibility: true,
              thickness: 5,
              radius: const Radius.circular(100),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                        isAr ? 30 : 10, 0, isAr ? 10 : 30, 15),
                    itemCount: cities.length,
                    itemBuilder: (BuildContext _, int i) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => state(() {
                          SettingsDialog.dismiss();
                          onChange(cities[i]);
                        }),
                        child: City(
                          city: cities[i],
                          selected: city == cities[i],
                        ),
                      );
                    },
                    separatorBuilder: (__, ___) {
                      return const HDivider(
                        color: Colors.white,
                        height: 8,
                        thickness: 0.1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ).show();
        },
        child: SizedBox(
          width:
              MediaQuery.of(context).size.width * (city == null ? 0.24 : 0.2),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: city == null,
                  replacement: Flexible(
                    child: Row(
                      children: [
                        const Icon(LineIcons.city),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextX(
                            '${city?.name}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: TextX(
                    arb!.city,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
