import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/home/screens/components/bottom_buttons.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/models/transfer.dart';
import '/router/app_route.dart';

class Success extends StatelessWidget {
  const Success({super.key, required this.transferData});

  final String transferData;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final transfer = TransferModel.fromJson(jsonDecode(transferData));
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(
          AppRoute.home,
          queryParameters: <String, String>{'i': '1'},
        );
        return false;
      },
      child: Scaffold(
        appBar: AutoAppBar(
          title: arb!.paymentSuccessful,
          subTitle: arb.yourPaymentHasBeenSubmittedSuccessfully,
          onPressed: () => context.goNamed(
            AppRoute.home,
            queryParameters: <String, String>{'i': '1'},
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: Decorations.main(context),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: OverflowBox(
                          maxHeight: 400,
                          maxWidth: 400,
                          child: Lottie.asset(
                            'assets/json/success.json',
                            repeat: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: OverflowBox(
                          maxHeight: 400,
                          maxWidth: 400,
                          child: Lottie.asset('assets/json/success_work.json'),
                        ),
                      ),
                    ],
                  ),
                ),
                TextX(
                  arb.success,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    TextX(
                      arb.transferDetails,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RowSpaceBetween([
                  TextX(
                    arb.transferId,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextC(
                    '#${transfer.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ]),
                const SizedBox(height: 5),
                RowSpaceBetween([
                  TextX(
                    arb.transactionDate,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextX(
                    transfer.addedAt.substring(0, 10),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ]),
                const SizedBox(height: 5),
                RowSpaceBetween([
                  TextX(
                    arb.sentTo,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextX(
                    '${transfer.recipient.firstName} ${transfer.recipient.lastName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ]),
                const HDivider(height: 25),
                RowSpaceBetween([
                  TextX(
                    arb.fee,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text.rich(
                    textScaleFactor: 1.0,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${transfer.fees.toStringAsFixed(2)} ',
                        ),
                        const TextSpan(text: 'USDT'),
                      ],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ]),
                RowSpaceBetween([
                  TextX(
                    arb.totalPaid,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text.rich(
                    textScaleFactor: 1.0,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${transfer.totalAmount.toStringAsFixed(2)} ',
                        ),
                        const TextSpan(text: 'USDT'),
                      ],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ]),
                const SizedBox(height: 18),
                if (transfer.cashToPay)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: Decorations.note(context),
                    child: TextX(
                      arb.pleasePayTheBalanceForThisTransactionWithin3DaysAtYourNearestApprovedCashPaymentAddress,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (transfer.cashToPay) const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: Decorations.note(context),
                  child: TextX(
                    arb.noteAmanaSendRegisterSmallPaymentToCarryOutMoneyTransferServicesUnderPaymentServices,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MainColors.red,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomButtons(
          firstButton: Button(
            () => context.goNamed(
              AppRoute.home,
              queryParameters: <String, String>{'i': '0'},
            ),
            color: MainColors.color2,
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextX(
                    arb.home.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LineIcons.home, color: Colors.white),
                ],
              ),
            ),
          ),
          secondButton: ExpandButton(
            () {
              context.goNamed(
                AppRoute.home,
                queryParameters: <String, String>{'i': '1'},
              );
              context.pushNamed(
                AppRoute.transfer,
                pathParameters: <String, String>{
                  'transfer': jsonEncode(transfer)
                },
              );
            },
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.track_changes, color: Colors.white),
                  const SizedBox(width: 8),
                  TextX(
                    arb.trackTransfer.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
