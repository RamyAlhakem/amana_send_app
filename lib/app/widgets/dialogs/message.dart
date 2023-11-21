import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/dotted_border/dotted_border.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';

class MessageDialog {
  MessageDialog(this.message, {this.action, this.actionTitle, this.title});

  final String message;
  final void Function()? action;
  final String? actionTitle;
  final Widget? title;

  Future<void> show() async {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (_) {
        return AlertDialog(
          title: title ??
              Row(
                children: [
                  Icon(
                    Icons.report_gmailerrorred,
                    size: 28,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  TextX(
                    arb.attention,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 15),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DottedBorder(
                borderType: BorderType.rRect,
                radius: const Radius.circular(20),
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
            if (action != null)
              Button(
                () {
                  dismiss();
                  action!();
                },
                borderRadius: 100.0,
                TextX(
                  actionTitle ?? arb.ok,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
              ),
            if (action != null) const SizedBox(height: 10),
            Button(
              () => dismiss(),
              TextX(arb.close, style: Theme.of(context).textTheme.bodyMedium),
              color: Theme.of(context).buttonTheme.colorScheme?.secondary,
              borderRadius: 100.0,
            ),
          ],
        );
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
