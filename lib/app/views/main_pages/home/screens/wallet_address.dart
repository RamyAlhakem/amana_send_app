import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/scroll_button.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/wallet_timer.dart';
import '/helper/helper.dart';
import '/services/lang_service.dart';

class WalletAddress extends StatefulWidget {
  const WalletAddress({super.key});

  @override
  State<WalletAddress> createState() => _WalletAddressState();
}

class _WalletAddressState extends State<WalletAddress>
    with TickerProviderStateMixin {
  late AppLocalizations arb;
  late bool isAR;

  final ScrollController scrollCtrl = ScrollController();

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isAR = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransfersState>(builder: (_, state, child) {
      child = Stack(
        children: [
          ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: Decorations.note(context, radius: 10),
                child: TextC(
                  '${arb.yourOrderHasBeenReceivedSuccessfully.toUpperCase()} \n${arb.transactionNo} #${state.transfer.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MainColors.color2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: Decorations.main(context, radius: 10),
                child: Column(
                  children: [
                    TextX(
                      '${arb.toCompleteTheTransferPleasePayTheDueAmount}:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_coin.png',
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        TextX(
                          Helper.priced(state.transfer.totalAmount),
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TextX(
                      arb.pleaseMakeSureToPayTheExactAmountToTheWALLETInOneGoOtherwiseIfTheAmountPaidInMoreOrLessWeWillPayOutExactlyWhatWeReceivedOnSameExchangeRate,
                      style: const TextStyle(
                          color: MainColors.lightRed, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: Decorations.main(context, radius: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextX(
                      '${arb.toThisWalletAddress}:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    TextC(
                      state.transfer.wallet.address,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MainColors.color1,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          () => Share.share(state.transfer.wallet.address),
                          color: MainColors.color2,
                          Row(children: [
                            const Icon(Icons.share, size: 16),
                            const SizedBox(width: 8),
                            TextX(arb.share),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Button(
                          () => Clipboard.setData(
                            ClipboardData(text: state.transfer.wallet.address),
                          ).whenComplete(() {
                            Helper.snack(
                              '${arb.copiedSuccessfully}\n${state.transfer.wallet.address}',
                            );
                          }),
                          Row(children: [
                            const Icon(Icons.copy, size: 16),
                            const SizedBox(width: 8),
                            TextX(arb.copy),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      textScaler: TextScaler.noScaling,
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: '${arb.walletNetwork}: '),
                          const TextSpan(
                            text: 'Polygon - (MATIC)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextX(
                      arb.useThisUniqueWalletAddressForOneTimeAndForThisTransferOnly,
                      style: const TextStyle(color: MainColors.lightRed),
                    ),
                  ],
                ),
              ),

              // Timer:
              WalletTimer(transfer: state.transfer),

              Container(
                decoration: Decorations.note(context),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.all(15),
                child: TextX(
                  arb.onceThePaymentIsBeingConfirmedWeWillNotifyYouAndProcessTheTransferImmediately,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: isAR ? null : 10,
            right: isAR ? 10 : null,
            child: ScrollButton(scrollCtrl: scrollCtrl),
          ),
        ],
      );
      return child;
    });
  }
}
