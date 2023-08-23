import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomSheeter {
  BottomSheeter(
    this.context, {
    required this.title,
    this.subTitle,
    required this.actions,
  });

  final BuildContext context;
  final String title;
  final String? subTitle;
  final List<Widget> Function(void Function(VoidCallback)) actions;

  static BuildContext? _dialogContext;

  void show() {
    final AppLocalizations? arb = AppLocalizations.of(context);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext _) => StatefulBuilder(builder: (__, state) {
        _dialogContext = _;

        return CupertinoActionSheet(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          message: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              subTitle ?? arb!.selectFromTheListBelow,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          actions: actions(state),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => dismiss(),
            child: Text(arb!.done),
          ),
        );
      }),
    );
  }

  static void dismiss() {
    if (_dialogContext != null) Navigator.pop(_dialogContext!);
  }
}
