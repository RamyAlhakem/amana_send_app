import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/app/widgets/blurry_container.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';

class DatePicker {
  DatePicker(
    this.context, {
    required this.initialDate,
    required this.onChanged,
    this.height = 250,
  });

  final BuildContext context;
  final DateTime initialDate;
  final void Function(DateTime) onChanged;
  final double height;

  static BuildContext? _dialogContext;

  void show() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext _) {
        _dialogContext = _;
        return BlurryContainer(
          color: Theme.of(context).cardColor.withOpacity(0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Button(
                  () => dismiss(),
                  TextX(
                    'Done',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 5),
                ),
              ]),
              SizedBox(
                height: height,
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onChanged,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void dismiss() {
    if (_dialogContext != null) Navigator.pop(_dialogContext!);
  }
}
