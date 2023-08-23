import 'package:flutter/material.dart';

import '/app/widgets/dialogs/date_picker.dart';
import '/app/widgets/picker_form.dart';

class DatePick extends StatelessWidget {
  const DatePick(
    this.date,
    this.title,
    this.onChanged, {
    this.width,
    Key? key,
  }) : super(key: key);

  final DateTime date;
  final String title;
  final void Function(DateTime) onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return PickerForm(
      (() =>
          DatePicker(context, initialDate: date, onChanged: onChanged).show()),
      hint: title,
      value: '${date.month}/${date.day}/${date.year}  ',
      align: MainAxisAlignment.center,
      width: width ?? MediaQuery.of(context).size.width * 0.45,
    );
  }
}
