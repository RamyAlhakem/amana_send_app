import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';

class ImagePickSource {
  static void select({
    required VoidCallback camera,
    required VoidCallback gallery,
  }) {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;
    final Color? button = Theme.of(context).buttonTheme.colorScheme?.secondary;
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          actions: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    () {
                      Navigator.pop(Global.key.currentContext!); // close dialog
                      camera();
                    },
                    TextX(
                      arb.camera,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    color: button,
                    borderRadius: 100,
                  ),
                ),
                const SizedBox(height: 25),
                Button(
                  () {
                    Navigator.pop(Global.key.currentContext!); // close dialog
                    gallery();
                  },
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  FittedBox(
                    child: TextX(
                      arb.gallery,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  color: button,
                  borderRadius: 100,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
