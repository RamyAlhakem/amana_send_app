import 'dart:async';

import 'package:amana_send/app/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
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
  State<SelectRecipient> createState() => _SelectRecipientState();
}

class _SelectRecipientState extends State<SelectRecipient>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Calculator _calc;
  late RecipientsState _recipients;

  List<bool> selection = <bool>[];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calc = Provider.of<Calculator>(context, listen: false);
    _recipients = Provider.of<RecipientsState>(context, listen: false);
    _recipients.resetPage();
    GetRecipients.request();
  }

  @override
  Widget build(BuildContext context) {
    final arb = AppLocalizations.of(context)!;
    super.build(context);
    return Consumer<RecipientsState>(builder: (_, recipients, child) {
      child = Visibility(
        visible: !recipients.isLoading,
        replacement: ListView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          children: const [ShimmerLoad(height: 80, verticalCount: 4)],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SearchWidget(
              hint: arb.search,
              onChange: (text) {
                // recipients.search(text);
                if (_timer != null) _timer!.cancel();

                _timer = Timer(const Duration(milliseconds: 500), () {
                  GetRecipients.request(search: text);
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                itemCount: recipients.receipients.length,
                itemBuilder: (BuildContext context, int i) {
                  // Fill up select list once empty or when recipients list is changed.
                  selection =
                      Tools.setSelect(recipients.receipients, selection);
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() {
                      // give selected recipient values for start send purpose
                      _calc
                          .recipientSend(recipients.receipients[i])
                          .then((isOK) {
                        /// if all conditions met [isOK]:
                        if (isOK) {
                          // reset [selection] list to close all expanded recipients cards.
                          selection =
                              Tools.setSelect(recipients.receipients, <bool>[]);

                          // select recipient by expanding their card.
                          selection[i] = !selection[i];
                        }
                      });
                    }),
                    child: RecipientSelector(
                      recipient: recipients.receipients[i],
                      select: selection[i],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  recipients.increasePage();
                  Helper.log("page ${recipients.page}");
                  GetRecipients.request(page: recipients.page);
                  recipients.updateUi();
                },
                child: recipients.isLoadingBtn
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(arb.loadMore)),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      );
      return child;
    });
  }
}
