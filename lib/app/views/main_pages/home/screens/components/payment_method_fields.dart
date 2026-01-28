import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/widgets/text_form_field/text_form.dart';
import 'package:amana_send/extensions/context_extension.dart';
import 'package:amana_send/global/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PaymentMethodFields extends StatelessWidget {
  const PaymentMethodFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(
      builder: (context, calculator, child) {
        return Form(
          key: Global.formKey,
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                final field = calculator.providerFields[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${field.name} (${context.arb.fixed} ${field.characterCount} ${context.arb.characters})"),
                    TextFieldX(
                      validator: (text) {
                        if (text!.isEmpty) {
                          return context.arb.invalidInput;
                        } else if (text.length < field.characterCount) {
                          return "${context.arb.pleaseEnter} ${field.characterCount} ${context.arb.characters}";
                        }
                        return null;
                      },
                      hint: "${context.arb.enter} ${field.name}",
                      controller: null,
                      input: [
                        LengthLimitingTextInputFormatter(field.characterCount)
                      ],
                      onChanged: (val) {
                        calculator.setProviderFieldValue(field.id, val);
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                    height: 20,
                  ),
              itemCount: calculator.providerFields.length),
        );
      },
    );
  }
}
