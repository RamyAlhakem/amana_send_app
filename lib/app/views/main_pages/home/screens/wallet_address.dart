import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/views/registration/components/count_down.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/scroll_button.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/graphql/api/get_transfer.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/router/app_route.dart';
import '/services/lang_service.dart';
import '/services/user_service.dart';

class WalletAddress extends StatefulWidget {
  const WalletAddress({super.key});

  @override
  State<WalletAddress> createState() => _WalletAddressState();
}

class _WalletAddressState extends State<WalletAddress>
    with TickerProviderStateMixin {
  late AppLocalizations arb;
  late TransfersState provider;
  late bool isAR;

  final ScrollController scrollCtrl = ScrollController();

  int duration = 120;
  int reDuration = 5; // five seconds.
  late AnimationController ctrl;
  Timer? timer;
  Timer? reTimer;

  void isTimeOut() {
    if (duration > 0) {
      timer = Timer.periodic(
        Duration(seconds: duration),
        (_) => setState(() => duration = 0),
      );
    }
  }

  void checkTransaction(int id) {
    reTimer = Timer.periodic(Duration(seconds: reDuration), (_) {
      GetTransfer(context, id).request().whenComplete(() {
        if (provider.transfer.status.name.toLowerCase() == 'new') {
          UserService.countTransfers(count: 1); // add +1
          context.pushReplacementNamed(
            AppRoute.success,
            pathParameters: <String, String>{
              'transfer': jsonEncode(provider.transfer),
            },
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<TransfersState>(context, listen: false);
    duration = AppMetadata.get.walletAddressValidTime * 60;
    ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );

    ctrl.forward();
    isTimeOut();
    checkTransaction(provider.transfer.id);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isAR = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
    timer?.cancel();
    reTimer?.cancel();
    scrollCtrl.dispose();
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
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      textScaleFactor: 1.0,
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: '${arb.walletNetwork}: '),
                          const TextSpan(
                            text: 'Polygon',
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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: Decorations.main(context, radius: 10),
                child: Column(
                  children: [
                    TextX(
                      '${arb.timeLimitToPay}:',
                    ),
                    Visibility(
                      visible: duration == 0,
                      replacement: Countdown(
                        animation:
                            StepTween(begin: duration, end: 0).animate(ctrl),
                        size: 60,
                        color: null,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: duration != 0 ? 2 : 15),
                        child: TextX(
                          arb.oopsWalletAddressIsExpired,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextX(
                      arb.ifThePaymentHasNotBeenDoneInCertainTimeItIsNoLongerPossibleToUseThisWalletAndTheOrderWillBeCanceled,
                      style: const TextStyle(
                          color: MainColors.lightRed, fontSize: 12),
                    ),
                  ],
                ),
              ),
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
