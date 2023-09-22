import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/views/registration/components/count_down.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/graphql/api/get_transfer.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/router/app_route.dart';

class WalletAddress extends StatefulWidget {
  const WalletAddress({super.key});

  @override
  State<WalletAddress> createState() => _WalletAddressState();
}

class _WalletAddressState extends State<WalletAddress>
    with TickerProviderStateMixin {
  late AppLocalizations? arb;
  late TransfersState provider;

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
        if (provider.transfer.status.name == 'isNew') {
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
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
    timer?.cancel();
    reTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransfersState>(builder: (_, state, child) {
      child = ListView(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextX(arb!.howToPay),
                const SizedBox(width: 8),
                const Icon(Icons.info_outlined),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: state.transfer.wallet.address,
                size: 200,
                embeddedImage: const AssetImage('assets/images/icon.png'),
                errorStateBuilder: (cxt, err) {
                  return Center(
                    child: Text(
                      'Uh oh! Something went wrong...',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: Decorations.main(context, radius: 10),
            child: Column(
              children: [
                TextX(
                  arb!.walletAddressWillExpireWithin,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Visibility(
                  visible: duration == 0,
                  replacement: Countdown(
                    animation: StepTween(begin: duration, end: 0).animate(ctrl),
                    size: 60,
                    color: null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: duration != 0 ? 2 : 15),
                    child: TextX(
                      arb!.oopsWalletAddressIsExpired,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: Decorations.main(context, radius: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextX(
                  arb!.walletAddress,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 15),
                TextC(
                  state.transfer.wallet.address,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      () => Share.share(state.transfer.wallet.address),
                      color: MainColors.color1.withOpacity(0.3),
                      Row(children: [
                        const Icon(Icons.share, size: 16),
                        const SizedBox(width: 8),
                        TextX(arb!.share),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    Button(
                      () => Clipboard.setData(
                        ClipboardData(text: state.transfer.wallet.address),
                      ).whenComplete(() {
                        Helper.snack(
                          '${arb!.copiedSuccessfully}\n${state.transfer.wallet.address}',
                        );
                      }),
                      Row(children: [
                        const Icon(Icons.copy, size: 16),
                        const SizedBox(width: 8),
                        TextX(arb!.copy),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextX(arb!.paymentDetails),
          const HDivider(),
          RowSpaceBetween([
            TextX(arb!.totalToPay),
            TextX(
              Helper.priced(state.transfer.totalAmount),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]),
          const SizedBox(height: kTextTabBarHeight / 2),
          TextX(
            arb!.pleaseNoteThatThisWalletAddressIsJustForThisTransferPleaseDoNotUseItForAnotherTransfers
                .toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextX(
            arb!.oncePaymentHasBeenConfirmedInOurSystemYouWillGetNotifiedAndTheTransactionWillStartToProcessedWithin24hours,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
      return child;
    });
  }
}
