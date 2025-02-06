import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/graphql/api/calculate_transfer_money.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final List<Map<int, String>> items;
  final String hint, subHint;
  final void Function(int?)? onChange;
  final double? width;
  final double radius;

  @override
  State<DropForm> createState() => _DropFormState();
}

class _DropFormState extends State<DropForm> {
  int? _selectedItem;

  @override
  Widget build(BuildContext context) {
    final calculator = Provider.of<Calculator>(context, listen: false);
    return SizedBox(
      child: InputDecorator(
        decoration: InputDecoration(
           filled: true,
          fillColor: Theme.of(context).cardColor,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.hint,
          labelStyle:  TextStyle( fontSize: 14),
          focusedBorder: GeneralWidgets.formBorder(context),
          enabledBorder: GeneralWidgets.formBorder(context, radius: 10),
          border: GeneralWidgets.formBorder(context, radius: 10),
          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        ),
        child: DropdownButton(
          value: _selectedItem,
          items: widget.items.map((Map<int, String> item) {
            return DropdownMenuItem(
              value: item.keys.first,
              child: Text(
                item.values.first,
                style:  TextStyle( fontSize: 14),
              ),
            );
          }).toList(),
          isExpanded: true,
          hint: Row(
            children: [
              Text(calculator.paymentMethodName,
                  style: const TextStyle( fontSize: 14)),
            ],
          ),
          icon: const Icon(Icons.expand_more_rounded),
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(widget.radius),
          onChanged: (value) => setState(() {
            calculator.setPaymentMethodID(value!);
            calculator.setPrice( calculator.sender.text);
            _selectedItem = value;
            if (widget.onChange != null) widget.onChange!(value);
          }),
        ),
      ),
    );
  }
}
