import 'package:amana_send/app/theme/colors/main_colors.dart';
import 'package:amana_send/app/views/main_pages/home/screens/check_out_details.dart';
import 'package:amana_send/app/views/main_pages/home/screens/components/bottom_buttons.dart';
import 'package:amana_send/app/views/main_pages/home/screens/components/payment_method_fields_again.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/views/registration/provider/registration_state.dart';
import 'package:amana_send/app/widgets/buttons/button.dart';
import 'package:amana_send/app/widgets/buttons/expand_button.dart';
import 'package:amana_send/app/widgets/dialogs/contact_us.dart';
import 'package:amana_send/app/widgets/text/text_x.dart';
import 'package:amana_send/database/injector.dart';
import 'package:amana_send/extensions/context_extension.dart';
import 'package:amana_send/global/variables.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:amana_send/models/user.dart';
import 'package:amana_send/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaymentMethodTransferAgain extends StatefulWidget {
  const PaymentMethodTransferAgain({super.key});
  static const Duration _duration = Duration(milliseconds: 250);
  static Widget footer(BuildContext context, PageController page) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final UserModel user = Database().getUser;
    final calculator = Provider.of<Calculator>(context, listen: false);
    Helper.log(
        "Provider fields transfer: ${calculator.providerFieldsTransfer.length}");
    return calculator.providerFieldsTransfer.isNotEmpty
        ? BottomButtons(
            firstButton: ExpandButton(
              () => context.pop(),
              height: 45,
              color: Theme.of(context).buttonTheme.colorScheme?.secondary,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 8),
                  TextX(
                    arb!.previous.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            secondButton: ExpandButton(
              () {
                // if (user.verified != 1) {
                //   Helper.userVerify(context, user.verified, navigate: true);
                //   Helper.bannerWarning(
                //     arb.toEnsureThatYouCanSendMoneyWorldwidePleaseVerifyYourAccount,
                //   );
                //   return;
                // }

                if (calculator.selectedRecipient == null) {
                  return Helper.bannerWarning(arb.pleaseSelectRecipient);
                }
                if (calculator.sender.text.isEmpty) {
                  return Helper.bannerWarning(arb.pleaseEnterSendingAmount);
                }
                double senderAmount = double.parse(calculator.sender.text);

                if (user.level.maxAmount < senderAmount) {
                  return ContactUs(
                    message:
                        '${arb.yourMaxLevelSendingAmountIs} ${user.level.maxAmount} ${calculator.paymentMethodName}.\n${arb.toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount}',
                  ).show();
                }
                if (user.remainingSendLimit < senderAmount) {
                  return ContactUs(
                    message:
                        '${arb.yourMaxSendingAmountWithin} ${user.level.duration.toStringAsFixed(0)} ${arb.day} ${arb.iS} ${user.remainingSendLimit} ${calculator.paymentMethodName}.\n${arb.toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount}',
                  ).show();
                }
                if (double.parse(calculator.receiver.text) <
                    calculator.receiverAgent.minAmount) {
                  return Helper.bannerWarning(
                    '${arb.minimumReceivingLimitToThisPickUpPointIs} ${calculator.receiverAgent.minAmount} ${calculator.sendUSD ? 'USD' : calculator.selectedRecipient!.country.currency.code}',
                  );
                }
                if (calculator.receiverAgent.id == 0) {
                  return Helper.bannerWarning(arb.pleaseSelectReceiveType);
                }
                if (Global.formKey.currentState!.validate()) {
                  Global.snackKey.currentState?.hideCurrentMaterialBanner();
                  page.nextPage(duration: _duration, curve: Curves.easeIn);
                }

                // Global.snackKey.currentState?.hideCurrentMaterialBanner();
                // page.nextPage(duration: _duration, curve: Curves.easeIn);
              },
              height: 45,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextX(
                    arb.nextStep.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
            thirdButton: Visibility(
              visible: calculator.selectedRecipient == null,
              child: Button(
                () {
                  context.read<RegistrationState>().setCountry(
                        calculator.receiverCountry,
                      );
                  context.pushNamed(
                    AppRoute.addRecipient,
                    pathParameters: <String, String>{'recipient': 'null'},
                  );
                },
                height: 45,
                color: MainColors.color2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    const SizedBox(width: 8),
                    TextX(
                      arb.addNewRecipient.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        : CheckOutDetails.footer(context, page);
  }

  @override
  State<PaymentMethodTransferAgain> createState() =>
      _PaymentMethodTransferAgainState();
}

class _PaymentMethodTransferAgainState
    extends State<PaymentMethodTransferAgain> {
  @override
  Widget build(BuildContext context) {
    final calculator = Provider.of<Calculator>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Form(
              key: Global.formKey,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RichText(
                  //     text: TextSpan(children: [
                  //   TextSpan(
                  //       text: "${calculator.receiverAgent.name}: ",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Theme.of(context).brightness == Brightness.dark
                  //             ? Colors.white
                  //             : Colors.black,
                  //       )),
                  //   TextSpan(
                  //       text: AppLocalizations.of(context)!
                  //           .requiredAdditionalFields,
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Theme.of(context).brightness == Brightness.dark
                  //             ? Colors.white
                  //             : Colors.black,
                  //       ))
                  // ])),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  PaymentMethodFieldsAgain(),
                ],
              ),
            ),
          ),
          // const PaymentMethodDescriptions(),
          if (calculator.receiverAgent.note.isNotEmpty)
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                width: context.screenWidth,
                decoration: BoxDecoration(
                    color: MainColors.color4,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.7),
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Html(
                  data: calculator.receiverAgent.note,
                  style: {
                    "body": Style(color: Colors.black),
                  },
                )),
        ],
      ),
    );
  }
}
