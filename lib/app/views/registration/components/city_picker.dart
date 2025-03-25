import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/home/widgets/city.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/picker_form.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/services/lang_service.dart';

class CityPicker extends StatefulWidget {
  const CityPicker({
    super.key,
    required this.country,
    required this.onChange,
    this.fieldColor,
  });

  final CountryModel country;
  final Function(CityModel) onChange;
  final Color? fieldColor;

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  CountryModel country = CountryModel();
  CityModel? city;
late List<CityModel> cities;
late List<CityModel> allCities;
  @override
  void initState() {
    country = widget.country;
cities=widget.country.cities;
allCities=cities;
    if (country.cities.isNotEmpty) city = country.cities.first;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CityPicker oldWidget) {
    if (oldWidget.country != widget.country) {
      country = widget.country;
      if (widget.country.cities.isNotEmpty) city = widget.country.cities.first;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final bool isAr = LangService.isAR();
    final state=Provider.of<Calculator>(context);
    return PickerForm(
      () {
        cities=widget.country.cities;
        if (country.cities.isEmpty) {
          return Helper.toast(arb.selectCountry);
        }
        SettingsDialog(
          onChanged: (text) {
            if(text.isNotEmpty){
              List<CityModel>foundCities=allCities.where((e)=>e.name.toLowerCase().startsWith(text.toLowerCase())).toList();
cities=foundCities;
state.updateUi();
Helper.log("text =========>>>>$text  citites=======>>>>>>>$cities");
            }
            else{
              cities=widget.country.cities;
              state.updateUi();
            }
          },
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
            child: Consumer<Calculator>(
              builder: (context, state, child) =>
              ListView(
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
                        onTap: () {
                          SettingsDialog.dismiss();
                          widget.onChange(cities[i]);
                          setState(() => city = cities[i]);
                        },
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
              ) ,
              
            ),
          ),
        ).show();
      },
      hint: arb!.selectCity,
      value: '${city?.name}',
      valueIcon: const Icon(LineIcons.city),
      color: Theme.of(context).cardColor,
    );
  }
}
