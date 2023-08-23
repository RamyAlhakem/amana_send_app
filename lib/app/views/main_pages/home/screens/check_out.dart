import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/graphql/api/send_transfer.dart';
import '/helper/helper.dart';
import '/models/user_base.dart';
import '/services/lang_service.dart';
import 'components/accept_terms.dart';
import 'components/bottom_buttons.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  static const Duration _duration = Duration(milliseconds: 250);
  static Widget footer(BuildContext context, PageController page) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return BottomButtons(
      firstButton: ExpandButton(
        () {
          final UserBase user = Database().getUserBase;
          if (!user.acceptTerms) {
            return Helper.bannerWarning(arb.pleaseReadOurTermsAndConditions);
          }
          Global.snackKey.currentState?.hideCurrentMaterialBanner();
          final calculator = Provider.of<Calculator>(context, listen: false);
          SendTransfer(
            context,
            page,
            recipientAmount: double.parse(calculator.receiver.text),
            sendAmount: double.parse(calculator.sender.text),
            recipientId: calculator.selectedRecipient!.id,
            isReceiveInUSD: calculator.sendUSD,
            providerId: calculator.receiveType,
            paymentMethodId: 1,
          ).request();
        },
        height: 45,
        color: MainColors.color3,
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextX(
                arb!.reviewAndCheckout,
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
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
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
      child = Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: Decorations.main(context),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextX(
              _arb!.transferDetails,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 12),
            RowSpaceBetween([
              TextX(_arb!.youSend),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            RowSpaceBetween([
              TextX(_arb!.todayExchangeRate),
              Text.rich(
                textScaleFactor: 1.0,
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${isAr ? '' : '1'} ${state.sendCountry.currency.code} ${isAr ? '1 ' : ''}= ',
                    ),
                    TextSpan(
                      text: state.exchangeRate.toStringAsFixed(2),
                    ),
                    TextSpan(
                      text:
                          ' ${state.sendUSD ? 'USD' : state.receiverCountry.currency.code}',
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 8),
            RowSpaceBetween([
              TextX(_arb!.fees),
              Text.rich(
                textScaleFactor: 1.0,
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${state.fees.toStringAsFixed(2)} ',
                    ),
                    TextSpan(
                      text: state.sendCountry.currency.code,
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 8),
            RowSpaceBetween([
              TextX(_arb!.recipientName),
              TextX(
                '${state.selectedRecipient?.firstName} ${state.selectedRecipient?.lastName}'
                    .toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ]),
            const HDivider(height: 22),
            RowSpaceBetween([
              TextX(_arb!.totalToPay),
              Text.rich(
                textScaleFactor: 1.0,
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${state.amountPlusFee.toStringAsFixed(2)} ',
                    ),
                    TextSpan(
                      text: state.sendCountry.currency.code,
                    ),
                  ],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            RowSpaceBetween([
              TextX(_arb!.receiverGets),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            TextX(
              _arb!.termsAndConditions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 6),
            const AcceptTerms(), // accept terms.
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: Decorations.note(context),
              child: TextX(
                _arb!
                    .noteAllRemittanceWillBeWithin48HoursExceptForPublicHolidays,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: MainColors.red,
                    ),
              ),
            )
          ],
        ),
      );
      return child;
    });
  }
}
