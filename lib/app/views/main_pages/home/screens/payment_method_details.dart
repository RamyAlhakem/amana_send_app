import 'package:amana_send/app/theme/colors/main_colors.dart';
import 'package:amana_send/app/views/main_pages/home/screens/components/bottom_buttons.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/views/registration/provider/registration_state.dart';
import 'package:amana_send/app/widgets/buttons/button.dart';
import 'package:amana_send/app/widgets/buttons/expand_button.dart';
import 'package:amana_send/app/widgets/dialogs/contact_us.dart';
import 'package:amana_send/app/widgets/text/text_x.dart';
import 'package:amana_send/app/widgets/text_form_field/text_form.dart';
import 'package:amana_send/database/injector.dart';
import 'package:amana_send/global/variables.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:amana_send/models/user.dart';
import 'package:amana_send/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaymentMethodDetails extends StatefulWidget {
  const PaymentMethodDetails({super.key});
  static const Duration _duration = Duration(milliseconds: 250);
  static Widget footer(BuildContext context, PageController page) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final UserModel user = Database().getUser;
    final calculator = Provider.of<Calculator>(context, listen: false);
    return BottomButtons(
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

          Global.snackKey.currentState?.hideCurrentMaterialBanner();
          page.nextPage(duration: _duration, curve: Curves.easeIn);
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
    );
  }

  @override
  State<PaymentMethodDetails> createState() => _PaymentMethodDetailsState();
}

class _PaymentMethodDetailsState extends State<PaymentMethodDetails> {
  final TextEditingController _walletController = TextEditingController();
  final TextEditingController _recipientIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: "Sham cash Wallet: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                TextSpan(
                    text: "Required additional fields.",
                    style: TextStyle(fontSize: 16, color: Colors.black))
              ])),
              const SizedBox(
                height: 20,
              ),
              const Text("Wallet address (fixed 32 characters)"),
              TextFieldX(
                hint: "Enter sham cash wallet address",
                controller: _walletController,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Recipient ID (6 digits)"),
              TextFieldX(
                hint: "Enter recipient ID",
                controller: _recipientIdController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
