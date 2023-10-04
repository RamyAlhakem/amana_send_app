import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';

class TotalFees extends StatelessWidget {
  const TotalFees({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Consumer<Calculator>(builder: (_, state, child) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(
              children: [
                RowSpaceBetween([
                  TextX(arb!.fees),
                  Text.rich(
                    textScaleFactor: 1.0,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '${state.receiverAgent.receiveFees.toStringAsFixed(2)} ',
                        ),
                        const TextSpan(text: 'USDT'),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                RowSpaceBetween([
                  TextX(arb.amountWeWillConvert),
                  Text.rich(
                    textScaleFactor: 1.0,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${state.sender.text} ',
                        ),
                        const TextSpan(text: 'USDT'),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const HDivider(height: 20),
          RowSpaceBetween([
            TextX(arb.total),
            Text.rich(
              textScaleFactor: 1.0,
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '${state.amountPlusFee.toStringAsFixed(2)} ',
                  ),
                  const TextSpan(text: 'USDT'),
                ],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          RowSpaceBetween([
            TextX(arb.receiverGets),
            Text.rich(
              textScaleFactor: 1.0,
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '${state.receiver.text} ',
                  ),
                  TextSpan(
                    text: state.sendUSD
                        ? 'USD'
                        : state.receiverCountry.currency.code,
                  ),
                ],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ]),
        ],
      );
      return child;
    });
  }
}
