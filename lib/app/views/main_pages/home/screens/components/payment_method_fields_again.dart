import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/widgets/text_form_field/text_form.dart';
import 'package:amana_send/extensions/context_extension.dart';
import 'package:amana_send/global/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PaymentMethodFieldsAgain extends StatelessWidget {
  const PaymentMethodFieldsAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(
      builder: (context, calculator, child) {
        return Column(
          children: calculator.providerFieldsTransfer.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${field.field.name} (${context.arb.fixed} ${field.field.characterCount} ${context.arb.characters})"),
                  TextFieldX(
                    validator: (text) {
                      if (text!.isEmpty) {
                        return context.arb.invalidInput;
                      } else if (text.length < field.field.characterCount) {
                        return "${context.arb.pleaseEnter} ${field.field.characterCount} ${context.arb.characters}";
                      }
                      return null;
                    },
                    hint: field.field.description,
                    controller: TextEditingController(text: field.fieldValue),
                    input: [
                      LengthLimitingTextInputFormatter(
                          field.field.characterCount)
                    ],
                    onChanged: (val) {
                      calculator.setProviderFieldValue(field.id, val);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
