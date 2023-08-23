import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/picker_form.dart';
import '/models/country.dart';
import '/models/provider.dart';
import '/services/lang_service.dart';
import 'country.dart';

class CountryRoller extends StatelessWidget {
  const CountryRoller({
    super.key,
    required this.title,
    this.width,
    this.borderRadius = 8,
  });

  final String title;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final bool isAr = LangService.isAR();
    return Consumer<Calculator>(builder: (_, state, child) {
      CountryModel country = state.receiverCountry;
      List<CountryModel> countries = state.receiveCountries;

      child = PickerForm(
        () => SettingsDialog(
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
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                      isAr ? 30 : 10, 0, isAr ? 10 : 30, 15),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: countries.length,
                  itemBuilder: (BuildContext _, int i) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => setState(() {
                        state.setReceiverCountry(state.receiveCountries[i]);
                        state.setReceiveType(ProviderModel());

                        country = state.receiverCountry;
                        countries = state.receiveCountries;

                        state.setPrice(state.sender.text, country);
                        SettingsDialog.dismiss();
                      }),
                      child: Country(
                        country: countries[i],
                        selected: country.coCode == countries[i].coCode,
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
        ).show(),
        hint: '${arb!.send} ${arb.to}',
        value: country.currency.code,
        width: width,
        borderRadius: borderRadius,
        hintIcon: const HeroIcon(HeroIcons.arrowDownRight, size: 15),
        valueIcon: Flag.fromString(
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
