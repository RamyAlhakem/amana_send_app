import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/home/screens/components/recipient_selector.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/dialogs/contact_us.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/app/widgets/text/text_x.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/graphql/api/get_recipients.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import '/tools/tools.dart';
import 'components/bottom_buttons.dart';

class SelectRecipient extends StatefulWidget {
  const SelectRecipient({super.key});

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
            const SizedBox(width: 8),
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
                  '${arb.yourMaxLevelSendingAmountIs} ${user.level.maxAmount} ${user.country.currency.code}.\n${arb.toIncreaseYourMaxLevelAmountKindlyContactOurSupportTeam}',
            ).show();
          }
          if (user.remainingSendLimit < senderAmount) {
            return ContactUs(
              message:
                  '${arb.yourMaxSendingAmountWithin} ${user.level.duration.toStringAsFixed(0)} ${arb.day} ${arb.iS} ${user.remainingSendLimit} ${user.country.currency.code}.\n${arb.toIncreaseYourMaxLevelAmountKindlyContactOurSupportTeam}',
            ).show();
          }
          if (double.parse(calculator.receiver.text) <
              calculator.receiverAgent.minAmount) {
            return Helper.bannerWarning(
              '${arb.minimumReceivingLimitToThisCountryIs} ${calculator.receiverAgent.minAmount} ${calculator.selectedRecipient!.country.currency.code}',
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
  State<SelectRecipient> createState() => _SelectRecipientState();
}

class _SelectRecipientState extends State<SelectRecipient>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Calculator _calc;

  List<bool> selection = <bool>[];

  @override
  void initState() {
    super.initState();
    _calc = Provider.of<Calculator>(context, listen: false);
    GetRecipients.request();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<RecipientsState>(builder: (_, recipients, child) {
      child = Visibility(
        visible: !recipients.isLoading,
        replacement: ListView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          children: const [ShimmerLoad(height: 80, verticalCount: 4)],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          itemCount: recipients.all.length,
          itemBuilder: (BuildContext context, int i) {
            // Fill up select list once empty or when recipients list is changed.
            selection = Tools.setSelect(recipients.all, selection);
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() {
                // give selected recipient values for start send purpose
                _calc.recipientSend(recipients.all[i]).then((isOK) {
                  /// if all conditions met [isOK]:
                  if (isOK) {
                    // reset [selection] list to close all expanded recipients cards.
                    selection = Tools.setSelect(recipients.all, <bool>[]);

                    // select recipient by expanding their card.
                    selection[i] = !selection[i];
                  }
                });
              }),
              child: RecipientSelector(
                recipient: recipients.all[i],
                select: selection[i],
              ),
            );
          },
        ),
      );
      return child;
    });
  }
}
