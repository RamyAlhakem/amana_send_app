import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/expander.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';

class TotalFees extends StatelessWidget {
  const TotalFees({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Consumer<Calculator>(builder: (_, state, child) {
      final double receiverAmount = double.tryParse(state.receiver.text) ?? 0;
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Column(
              children: [
                RowSpaceBetween([
                  TextX(arb!.fee),
                  Text.rich(
                    textScaler: TextScaler.noScaling,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '${state.calculateAmount.sendFees} ',
                        ),
                        TextSpan(text: state.paymentMethodName),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                RowSpaceBetween([
                  TextX(arb.sendingAmount),
                  Text.rich(
                    textScaler: TextScaler.noScaling,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '${double.tryParse(state.calculateAmount.totalAmount.toString()) ?? 0} ',
                        ),
                        TextSpan(text: state.paymentMethodName),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const HDivider(height: 20),
          Expander(
            expand: receiverAmount > 0,
            child: Column(
              children: [
                RowSpaceBetween([
                  TextX(arb.total,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  Text.rich(
                    textScaler: TextScaler.noScaling,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${state.calculateAmount.totalAmount+state.calculateAmount.sendFees} ',
                        ),
                         TextSpan(text: state.paymentMethodName),
                      ],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                // RowSpaceBetween([
                //   TextX(arb.recipientGets),
                //   Text.rich(
                //     textScaler: TextScaler.noScaling,
                //     TextSpan(
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: '${Tools.nicePrice(receiverAmount)} ',
                //         ),
                //         TextSpan(
                //           text: state.sendUSD
                //               ? 'USD'
                //               : state.receiverCountry.currency.code,
                //         ),
                //       ],
                //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
                //             fontWeight: FontWeight.w500,
                //           ),
                //     ),
                //   ),
                // ]),
              ],
            ),
          ),
        ],
      );
      return child;
    });
  }
}
