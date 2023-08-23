import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/dotted_border/dotted_border.dart';
import '/app/widgets/text/text_x.dart';

class MessageDialog {
  MessageDialog(this.message, {this.action, this.actionTitle});

  final String message;
  final void Function()? action;
  final String? actionTitle;

  static BuildContext? _dialogContext;
  void show(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext _) {
        _dialogContext = _;

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.report_gmailerrorred,
                  size: 28, color: Colors.grey[400]),
              const SizedBox(width: 6),
              TextX(
                arb!.attention,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actionsPadding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              DottedBorder(
                borderType: BorderType.rRect,
                radius: const Radius.circular(5),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                dashPattern: const [8, 8],
                color: Theme.of(context).dividerColor,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextX(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            ],
          ),
          actions: [
            Button(
              () => dismiss(),
              width: MediaQuery.of(context).size.width * 0.2,
              TextX(arb.close, style: Theme.of(context).textTheme.bodyMedium),
              color: Theme.of(context).buttonTheme.colorScheme?.secondary,
              borderRadius: 6.0,
            ),
            if (action != null)
              Button(
                () {
                  dismiss();
                  action!();
                },
                TextX(
                  actionTitle ?? arb.ok,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
                borderRadius: 3.0,
              ),
          ],
        );
      },
    );
  }

  static void dismiss() {
    if (_dialogContext != null) Navigator.pop(_dialogContext!);
  }
}
