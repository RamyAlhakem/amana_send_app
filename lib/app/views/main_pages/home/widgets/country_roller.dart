import 'package:amana_send/app/views/main_pages/home/widgets/syria_flag.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/picker_form.dart';
import '/models/country.dart';
import '/services/lang_service.dart';
import 'country.dart';

class CountryRoller extends StatelessWidget {
  const CountryRoller({
    super.key,
    this.send = false,
    required this.title,
    this.width,
    this.borderRadius = 8,
  });

  final String title;
  final bool send;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final bool isAr = LangService.isAR();
    return Consumer<Calculator>(builder: (_, state, child) {
      CountryModel country = send ? state.sendCountry : state.receiverCountry;
      List<CountryModel> countries =
          send ? state.sendCountries : state.receiveCountries;
      List<CountryModel> allContries =
          send ? state.sendCountries : state.receiveCountries;
      child = PickerForm(
        () => SettingsDialog(
          onChanged: (text) {
            if(text.isNotEmpty){
              final List<CountryModel> foundContries=allContries.where((e)=>isAr? e.arName.toLowerCase().contains(text.toLowerCase()):e.enName.toLowerCase().startsWith(text.toLowerCase())).toList();
countries=foundContries;
state.updateUi();
            }
            else{
              countries =
          send ? state.sendCountries : state.receiveCountries;
          state.updateUi();
            }
          },
          onSubmit: null,
          title: title,
          subTitle: arb.chooseCountry,
          subTitleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          horizontalPadding: 0,
          content: (setState) => Scrollbar(
            interactive: true,
            thumbVisibility: true,
            thickness: 5,
            radius: const Radius.circular(100),
            child: Consumer<Calculator>(
              builder: (context, calculater, child) =>
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(
                        isAr ? 30 : 10, 0, isAr ? 10 : 30, 15),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < countries.length; i++)
                        if (send || countries[i].cities.isNotEmpty)
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => setState(() {
                                if (send) {
                                  country = state.setSendCountry(
                                   countries[i],
                                  );
                                } else {
                                  country = state.setReceiverCountry(
                                    countries[i],
                                  );
                                }
              
                                state.setPrice(state.sender.text);
                                SettingsDialog.dismiss();
                              }),
                              child: Country(
                                country: countries[i],
                                selected: country.coCode == countries[i].coCode,
                              ),
                            ),
                    ],
                  ),
                ],
              ) ,
              
            ),
          ),
        ).show(),
        hint: '${arb!.send} ${send ? arb.from : arb.to}',
        value: country.currency.code,
        width: width,
        borderRadius: borderRadius,
        hintIcon: HeroIcon(
          send ? HeroIcons.arrowUpRight : HeroIcons.arrowDownRight,
          size: 15,
        ),
        valueIcon: country.coCode == "sy"
            ? const SyrFlag()
            : Flag.fromString(
                country.coCode.isEmpty ? 'us' : country.coCode,
                height: 28,
                width: 28,
                borderRadius: 100,
                fit: BoxFit.fill,
              ),
        color: Theme.of(context).cardColor,
      );
      return child;
    });
  }
}
