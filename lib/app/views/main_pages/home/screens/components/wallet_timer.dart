import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/registration/components/count_down.dart';
import '/app/widgets/text/text_x.dart';
import '/models/metadata.dart';
import '/models/transfer.dart';

class WalletTimer extends StatefulWidget {
  const WalletTimer({
    super.key,
    required this.transfer,
    this.hideDecorations = false,
  });
  final TransferModel transfer;
  final bool hideDecorations;

  @override
  State<WalletTimer> createState() => _WalletTimerState();
}

class _WalletTimerState extends State<WalletTimer>
    with TickerProviderStateMixin {
  late AppLocalizations arb;
  late AnimationController ctrl;
  TransferModel transfer = TransferModel();

  Timer? timer;
  Timer? reTimer;
  int duration = 120;
  int reDuration = 5; // five seconds.

  void isTimeOut() {
    if (duration > 0) {
      timer = Timer.periodic(
        Duration(seconds: duration),
        (_) => setState(() => duration = 0),
      );
    }
  }

  int calculateRemainingTime() {
    final int initial = AppMetadata.get.walletAddressValidTime * 60;
    final DateTime now = DateTime.now();

    // Get transactionDate + additional timezone hours:
    final date = DateTime.parse(transfer.addedAt).add(
      now.timeZoneOffset - const Duration(hours: 1),
    );

    // Calculate the remaining time
    final Duration difference = now.difference(date);
    final int seconds = initial - difference.inSeconds;

    return seconds > 0 ? seconds : 0;
  }

  @override
  void initState() {
    super.initState();
    transfer = widget.transfer;
    duration = calculateRemainingTime();
    ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );

    ctrl.forward();
    isTimeOut();
  }

  @override
  void didUpdateWidget(covariant WalletTimer oldWidget) {
    transfer = widget.transfer;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
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
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration:
          widget.hideDecorations ? null : Decorations.main(context, radius: 10),
      child: Column(
        children: [
          TextX(
            '${arb.timeLimitToPay}:',
          ),
          Visibility(
            visible: duration == 0,
            replacement: Countdown(
              animation: StepTween(begin: duration, end: 0).animate(ctrl),
              color: null,
            ),
            child: TextX(
              arb.oopsWalletAddressIsExpired,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextX(
            arb.ifThePaymentHasNotBeenDoneInCertainTimeItIsNoLongerPossibleToUseThisWalletAndTheOrderWillBeCanceled,
            style: const TextStyle(color: MainColors.lightRed, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
