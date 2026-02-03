import 'package:amana_send/app/extensions/dark_mode.dart';
import 'package:amana_send/app/theme/colors/dark_colors.dart';
import 'package:amana_send/app/theme/colors/main_colors.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodDescriptions extends StatelessWidget {
  const PaymentMethodDescriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(
      builder: (context, calculator, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    width: context.screenWidth,
                    decoration: BoxDecoration(
                        color: MainColors.color4,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.7),
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Text(
                      calculator.providerFields[index].description,
                      style: const TextStyle(
                          backgroundColor: Colors.yellow,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: calculator.providerFields.length),
        );
      },
    );
  }
}
