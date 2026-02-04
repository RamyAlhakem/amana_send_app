import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/extensions/text_underline.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/transfers/widgets/agent_description.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/scroll_button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/graphql/api/send_transfer.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/services/lang_service.dart';
import '/tools/tools.dart';
import 'components/bottom_buttons.dart';

class CheckOutDetails extends StatefulWidget {
  const CheckOutDetails({super.key});

  static const Duration _duration = Duration(milliseconds: 250);
  static Widget footer(BuildContext context, PageController page) {
    final AppLocalizations arb = AppLocalizations.of(context)!;
    return BottomButtons(
      key: UniqueKey(),
      firstButton: ExpandButton(
        () {
          Global.snackKey.currentState?.hideCurrentMaterialBanner();
          final calculator = Provider.of<Calculator>(context, listen: false);
          SendTransfer(
            context,
            page,
            recipientAmount: double.parse(calculator.receiver.text),
            sendAmount: calculator.calculateAmount.totalAmount +
                calculator.calculateAmount.receiveFees,
            recipientId: calculator.selectedRecipient!.id,
            isReceiveInUSD: calculator.sendUSD,
            receivingCityId: calculator.receiverCity.id,
            providerId: calculator.receiverAgent.id,
            paymentMethodId: calculator.paymentMethodID,
            fields: calculator.providerFieldValues,
          ).request();
        },
        height: 45,
        color: MainColors.color2,
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextX(
                arb.confirmSendingOrder,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Icon(LineIcons.check, color: Colors.white),
            ],
          ),
        ),
      ),
      thirdButton: Button(
        () => page.previousPage(duration: _duration, curve: Curves.easeIn),
        height: 45,
        color: MainColors.red.withOpacity(0.2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 8),
            TextX(
              arb.previous.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

  @override
  State<CheckOutDetails> createState() => _CheckOutDetailsState();
}

class _CheckOutDetailsState extends State<CheckOutDetails> {
  late AppLocalizations arb;
  late bool isAR;
  final ScrollController scrollCtrl = ScrollController();

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isAR = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    scrollCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(builder: (_, state, child) {
      final rate = state.receiverAgent.tab;

      final bool usd = state.receiverAgent.usdAvailability == 2;
      child = Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 14, 10, 10),
              decoration: Decorations.main(context),
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
                    child: TextX(
                      arb.transferDetails,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    decoration: Decorations.border(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowSpaceBetween([
                          TextX(arb.recipient),
                          const SizedBox(width: 15),
                          Flexible(
                            child: TextX(
                              '${state.selectedRecipient?.firstName} ${state.selectedRecipient?.fatherName} ${state.selectedRecipient?.lastName}'
                                  .toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.mobileNumber),
                          const SizedBox(width: 15),
                          Flexible(
                            child: TextX(
                              isAR
                                  ? ' ${state.selectedRecipient?.mobile} ${state.selectedRecipient!.country.phoneCode}+ '
                                      .toUpperCase()
                                  : "+${state.selectedRecipient!.country.phoneCode} ${state.selectedRecipient?.mobile} ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: MainColors.color3),
                            ),
                          ),
                          //   state.selectedRecipient!.country.coCode=="sy"

                          // ? const SyrFlag()
                          // : Flag.fromString(
                          //     state.selectedRecipient!.country.coCode,
                          //     height: 30,
                          //     width: 30,
                          //     fit: BoxFit.fill,
                          //     borderRadius: 100,
                          //   ),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.recipientGets),
                          Text.rich(
                            textScaler: TextScaler.noScaling,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${Tools.nicePrice(double.tryParse(state.receiver.text) ?? 0)} ',
                                ),
                                TextSpan(
                                  text: state.sendUSD
                                      ? 'USD'
                                      : state.receiverCountry.currency.code,
                                ),
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.city),
                          TextX(state.receiverCity.name),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.pickUpPoint),
                          TextX(state.receiverAgent.name),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.sendingRate),
                          Text.rich(
                            textScaler: TextScaler.noScaling,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${isAR ? ' ' : '1'} ${state.paymentMethodName} ${isAR ? '1 ' : ' '}= ',
                                ),
                                TextSpan(
                                  text:
                                      '${usd ? 'USD' : state.receiverCountry.currency.code}'
                                      ' '
                                      '${rate.toStringAsFixed(2).replaceFirst(RegExp(r'\.00$'), "")}',
                                ),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 8,
                        ),
                        // Column(
                        //   children: state.providerFieldValues.entries
                        //       .map(
                        //         (e) => RowSpaceBetween([
                        //           TextX(e.key.toString()),
                        //           TextX(e.value.toString()),
                        //         ]),
                        //       )
                        //       .toList(),
                        // )
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: state.providerFields
                                  .map((field) => Text(field.name))
                                  .toList(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 8,
                              children: state.providerFields
                                  .map((field) => Text(
                                        state.providerFieldValues[field.id]
                                                ?.toString() ??
                                            '',
                                      ))
                                  .toList(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    decoration: Decorations.border(context),
                    child: Column(
                      children: [
                        RowSpaceBetween([
                          TextX(arb.sendingAmount),
                          Text.rich(
                            textScaler: TextScaler.noScaling,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${state.calculateAmount.totalAmount.toStringAsFixed(2).replaceFirst(RegExp(r'\.00$'), '')} ',
                                ),
                                TextSpan(text: state.paymentMethodName),
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.fee),
                          Text.rich(
                            textScaler: TextScaler.noScaling,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${Tools.nicePrice(state.calculateAmount.receiveFees)} ',
                                ),
                                TextSpan(text: state.paymentMethodName),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        RowSpaceBetween([
                          TextX(arb.totalToPay),
                          Text.rich(
                            textScaler: TextScaler.noScaling,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${(state.calculateAmount.totalAmount + state.calculateAmount.receiveFees).toStringAsFixed(2).replaceFirst(RegExp(r'\.00$'), '')} ',
                                ),
                                TextSpan(text: state.paymentMethodName),
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  AgentDescription(html: state.receiverAgent.description),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration: Decorations.note(context),
                    child: TextX(
                      " ${arb.weOnlyAcceptInUSDT} ${state.paymentMethodName}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: MainColors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration: Decorations.note(context),
                    child: Text.rich(
                      textScaler: TextScaler.noScaling,
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${arb.beforeConfirmingYourOrderYouShouldHaveADigitalWallet}, ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: MainColors.red,
                                ),
                          ),
                          TextSpan(
                            text: arb.clickHereToLearnHowToPay,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.underline(
                                  color: MainColors.red,
                                  distance: 1,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Helper.launchURL(
                                    AppMetadata.get.paymentTutorialUrl,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: isAR ? null : 6,
            right: isAR ? 6 : null,
            child: ScrollButton(scrollCtrl: scrollCtrl),
          ),
        ],
      );
      return child;
    });
  }
}
