import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/database/injector.dart';
import 'package:amana_send/models/payment_method.dart';
import 'package:amana_send/services/lang_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/blurry_container.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import 'package:go_router/go_router.dart';

class SettingsDialog {
  SettingsDialog({
    required this.onSubmit,
    required this.title,
    required this.subTitle,
    required this.content,
    this.barrierDismissible = false,
    this.onSubmitTitle,
    this.subTitleStyle,
    this.onSubmitTitleStyle,
    this.onSubmitColor,
    this.horizontalPadding = 20,
    this.backgroundColor,
  });

  final String title;
  final String subTitle;
  final Widget Function(void Function(VoidCallback)) content;
  final bool barrierDismissible;
  final String? onSubmitTitle;
  final TextStyle? subTitleStyle, onSubmitTitleStyle;
  final Color? onSubmitColor, backgroundColor;
  final double horizontalPadding;
  final void Function()? onSubmit;

  Future<void> show() async {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations? arb = AppLocalizations.of(context);
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black26,
      useSafeArea: false,
      builder: (BuildContext _) {
        return StatefulBuilder(builder: (__, state) {
          return BlurryContainer(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: backgroundColor ?? Colors.transparent,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextX(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                    child: TextX(
                      subTitle,
                      style: subTitleStyle ??
                          Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              insetPadding: EdgeInsets.fromLTRB(
                horizontalPadding,
                kTextTabBarHeight,
                horizontalPadding,
                0,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: content(state),
              ),
              contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              actions: [
                Column(
                  children: [
                    if (onSubmit != null)
                      Button(
                        onSubmit,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        TextX(
                          onSubmitTitle ?? arb!.ok,
                          style: onSubmitTitleStyle ??
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        color: onSubmitColor ?? MainColors.color5,
                        borderRadius: 100,
                      ),
                    if (onSubmit != null) const SizedBox(height: 12),
                    Button(
                      () => dismiss(),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      FittedBox(
                        child: TextX(
                          onSubmit == null ? arb!.done : arb!.ok,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.secondary,
                      borderRadius: 100,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}

class CurrencyWidget extends StatelessWidget {
  final Calculator controller;
  final AppLocalizations? arb;

  const CurrencyWidget({
    Key? key,
    required this.controller,
    required this.arb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      child:Global.appSettings.token.isNotEmpty
      ? Container()
      :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextX(
            arb?.typeOfCurrency ?? "",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: TextX(
              arb?.pleaseChooseCurrency ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < controller.payments.length; i++)
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        PaymentMethodModel payment = controller.payments[i];
                        Database().setCurrency = payment;
                        controller.setPaymentMethodID(payment);
                        controller.setPrice(controller.sender.text);
                      },
                      child: Row(children: [
                        Image.network(
                          controller.payments[i].iconUrl,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          controller.payments[i].name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 60,
                        )
                      ]),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     TextX(
      //       arb?.typeOfCurrency ?? "",
      //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
      //             color: Colors.white,
      //             fontWeight: FontWeight.w600,
      //           ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
      //       child: TextX(
      //         arb?.pleaseChooseCurrency ?? "",
      //         style: const TextStyle(color: Colors.white, fontSize: 14),
      //       ),
      //     ),
      //     ListView(
      //       shrinkWrap: true,
      //       padding: EdgeInsets.zero,
      //       children: [
      //         ListView(
      //           shrinkWrap: true,
      //           padding: const EdgeInsets.all(10),
      //           physics: const NeverScrollableScrollPhysics(),
      //           children: [
      //             for (int i = 0; i < controller.payments.length; i++)
      //               InkWell(
      //                 borderRadius: BorderRadius.circular(100),
      //                 onTap: () {
      //                   PaymentMethodModel payment = controller.payments[i];
      //                   Database().setCurrency = payment;
      //                   controller.setPaymentMethodID(payment);
      //                   controller.setPrice(controller.sender.text);
      //                 },
      //                 child: Row(children: [
      //                   Image.network(
      //                     controller.payments[i].iconUrl,
      //                     height: 50,
      //                     fit: BoxFit.cover,
      //                     errorBuilder: (context, error, stackTrace) =>
      //                         const SizedBox(),
      //                   ),
      //                   const SizedBox(
      //                     width: 20,
      //                   ),
      //                   Text(
      //                     controller.payments[i].name,
      //                     style: const TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 14,
      //                         fontWeight: FontWeight.w700),
      //                   ),
      //                   const SizedBox(
      //                     height: 60,
      //                   )
      //                 ]),
      //               ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
