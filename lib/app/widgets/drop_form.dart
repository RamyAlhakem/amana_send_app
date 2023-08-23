import 'package:flutter/material.dart';

import '/app/widgets/text/text_x.dart';
import 'general/general_widgets.dart';

class DropForm extends StatefulWidget {
  const DropForm({
    super.key,
    required this.hint,
    required this.subHint,
    required this.items,
    this.onChange,
    this.radius = 8,
    this.width,
  });

  final List<String> items;
  final String hint, subHint;
  final void Function(String?)? onChange;
  final double? width;
  final double radius;

  @override
  State<DropForm> createState() => _DropFormState();
}

class _DropFormState extends State<DropForm> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: InputDecorator(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.hint,
          focusedBorder: GeneralWidgets.formBorder(context),
          enabledBorder: GeneralWidgets.formBorder(context),
          border: GeneralWidgets.formBorder(context),
          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        ),
        child: DropdownButton(
          value: _selectedItem,
          items: widget.items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          isExpanded: true,
          hint: TextX(widget.subHint),
          icon: const Icon(Icons.expand_more_rounded),
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(widget.radius),
          onChanged: (value) => setState(() {
            _selectedItem = value;
            if (widget.onChange != null) widget.onChange!(value);
          }),
        ),
      ),
    );
  }
}
