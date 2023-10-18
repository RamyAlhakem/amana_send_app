import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/graphql/api/send_transfer.dart';
import '/helper/helper.dart';
import '/services/lang_service.dart';
import 'components/bottom_buttons.dart';

class CheckOutDetails extends StatefulWidget {
  const CheckOutDetails({super.key});

  static const Duration _duration = Duration(milliseconds: 250);
  static Widget footer(BuildContext context, PageController page) {
    final AppLocalizations arb = AppLocalizations.of(context)!;
    return BottomButtons(
      firstButton: ExpandButton(
        () {
          Global.snackKey.currentState?.hideCurrentMaterialBanner();
          final calculator = Provider.of<Calculator>(context, listen: false);
          SendTransfer(
            context,
            page,
            recipientAmount: double.parse(calculator.receiver.text),
            sendAmount: calculator.amountPlusFee,
            recipientId: calculator.selectedRecipient!.id,
            isReceiveInUSD: calculator.sendUSD,
            receivingCityId: calculator.receiverCity.id,
            providerId: calculator.receiverAgent.id,
            paymentMethodId: 1,
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
  late AppLocalizations? _arb;

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = LangService.isAR();
    return Consumer<Calculator>(builder: (_, state, child) {
      final rate = state.receiverAgent.rate * (1 - (state.percentFee / 100));
      child = Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 14, 10, 10),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: Decorations.main(context),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
                child: TextX(
                  _arb!.transferDetails,
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
                      TextX(_arb!.recipient),
                      TextX(
                        '${state.selectedRecipient?.firstName} ${state.selectedRecipient?.lastName}'
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ]),
                    const SizedBox(height: 8),
                    RowSpaceBetween([
                      TextX(_arb!.recipientGets),
                      Text.rich(
                        textScaleFactor: 1.0,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${state.receiver.text} ',
                            ),
                            TextSpan(
                              text: state.sendUSD
                                  ? 'USD'
                                  : state.receiverCountry.currency.code,
                            ),
                          ],
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    RowSpaceBetween([
                      TextX(_arb!.pickUpPoint),
                      TextX(state.receiverAgent.name),
                    ]),
                    const SizedBox(height: 8),
                    RowSpaceBetween([
                      TextX(_arb!.sendingRate),
                      Text.rich(
                        textScaleFactor: 1.0,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${isAr ? '' : '1'} USDT ${isAr ? '1 ' : ''}= ',
                            ),
                            TextSpan(
                              text: Helper.priced(rate,
                                  currencyCode:
                                      state.receiverCountry.currency.code),
                            ),
                          ],
                        ),
                      ),
                    ]),
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
                      TextX(_arb!.sendingAmount),
                      Text.rich(
                        textScaleFactor: 1.0,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${num.tryParse(state.sender.text)?.toStringAsFixed(2)} ',
                            ),
                            TextSpan(
                              text: state.sendCountry.currency.code,
                            ),
                          ],
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    RowSpaceBetween([
                      TextX(_arb!.fee),
                      Text.rich(
                        textScaleFactor: 1.0,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${state.receiverAgent.receiveFees.toStringAsFixed(2)} ',
                            ),
                            const TextSpan(text: 'USDT'),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    RowSpaceBetween([
                      TextX(_arb!.totalToPay),
                      Text.rich(
                        textScaleFactor: 1.0,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${state.amountPlusFee.toStringAsFixed(2)} ',
                            ),
                            TextSpan(
                              text: state.sendCountry.currency.code,
                            ),
                          ],
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                decoration: Decorations.note(context),
                child: TextX(
                  _arb!.weOnlyAcceptInUSDT,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MainColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            ],
          ),
        ),
      );
      return child;
    });
  }
}
