import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/message.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/models/metadata.dart';
import '/models/transfer.dart';

class PopupService {
  static Future<void> show() async {
    if (AppMetadata.get.popupStatus) {
      await MessageDialog(AppMetadata.get.popupMessage).show();
    }
  }

  static void copySuccess({required TransferModel transfer}) {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;
    const padding = EdgeInsets.fromLTRB(12, 12, 12, 12);
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext _) {
        return AlertDialog(
          elevation: 0,
          insetPadding: padding,
          contentPadding: padding,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
          title: TextX(
            arb.copiedSuccessfully,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: TextX(
                  transfer.wallet.address,
                  style: TextStyle(
                    color:
                        context.isDarkMode ? Colors.greenAccent : Colors.green,
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
                        text: ' POLYGON POS ',
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
                () => Navigator.of(context).pop(),
                width: MediaQuery.of(context).size.width,
                borderRadius: 100,
                TextX(arb.continueX),
              ),
            ],
          ),
        );
      },
    );
  }
}
