import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';

class CurrencyRoller extends StatelessWidget {
  const CurrencyRoller({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Consumer<Calculator>(builder: (_, state, child) {
      child = Button(
        () {
          // if [usdAvailability] is mandatory which is equal 2:
          if (state.receiverAgent.usdAvailability == 2) {
            return Helper.banner(
              'Receive only in USD for this country',
              leadingIcon: HeroIcons.checkCircle,
              leadingIconColor: Colors.green,
            );
          }

          // if [usdAvailability] is optional which is equal 1:
          if (state.receiverAgent.usdAvailability == 1) {
            SettingsDialog(
              onSubmit: null,
              title: arb!.selectCurrency,
              subTitle: arb.selectReceiveCurrencyForThisCountry,
              subTitleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              content: (setState) => Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HDivider(color: Colors.white),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        state.setPrice(state.sender.text);
                        SettingsDialog.dismiss();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextX(
                              '${state.receiverCountry.currency.code} (${state.receiverCountry.currency.name})',
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (!state.sendUSD)
                              const HeroIcon(
                                HeroIcons.checkCircle,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const HDivider(color: Colors.white),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        if (state.receiverAgent.usdAvailability > 0) {
                          state.setPrice(state.sender.text, usd: true);
                        } else {
                          state.setPrice(state.sender.text, usd: false);

                          Helper.bannerWarning(
                            arb.usdIsNotAvailableForThisCountry,
                          );
                        }
                        SettingsDialog.dismiss();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextX(
                              arb.usdDollar,
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (state.sendUSD)
                              const HeroIcon(
                                HeroIcons.checkCircle,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const HDivider(color: Colors.white),
                  ],
                ),
              ),
            ).show();
          }
        },
        color: Colors.transparent,
        padding: EdgeInsets.zero,
        TextX(
          state.sendUSD ? 'USD' : state.receiverCountry.currency.code,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
      return child;
    });
  }
}
