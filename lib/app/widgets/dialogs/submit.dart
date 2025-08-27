import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';

import '/app/theme/colors/main_colors.dart';
import '/global/variables.dart';

class SubmitDialog {
  SubmitDialog(this.onSubmit, {required this.content});

  final void Function() onSubmit;
  final String content;

  void show() {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations? arb = AppLocalizations.of(context);
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return CupertinoAlertDialog(
          title: Text(arb!.attention,
              style: Theme.of(context).textTheme.titleLarge),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(content, style: Theme.of(context).textTheme.bodyLarge),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => dismiss(),
              child: Text(arb.no, style: Theme.of(context).textTheme.bodyLarge),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                dismiss();
                Future<void>.delayed(const Duration(milliseconds: 250), () {
                  onSubmit();
                });
              },
              child: Text(
                arb.yes,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: MainColors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
