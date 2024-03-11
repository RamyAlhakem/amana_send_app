import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';

class Messages {
  static copySuccess(BuildContext context, {required TransferModel transfer}) {
    final AppLocalizations arb = AppLocalizations.of(context)!;
    Helper.snack(
      arb.copiedSuccessfully,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      seconds: 99,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: TextX(
              transfer.wallet.address,
              style: TextStyle(
                color: context.isDarkMode ? Colors.greenAccent : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: TextX(
              arb.attentionWhenMakingThePayment,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'almarai',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Text.rich(
              textScaler: TextScaler.noScaling,
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: arb.makeSureToEnterTheWalletAddressCorrectly,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const TextSpan(
                    text: ' POLYGON (MATIC) ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: arb.polygonNetworkOnly,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Button(
            () => Global.snackKey.currentState?.hideCurrentSnackBar(),
            width: MediaQuery.of(context).size.width,
            TextX(arb.done),
          ),
        ],
      ),
    );
  }
}
