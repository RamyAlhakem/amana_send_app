import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/components/city_picker.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/global/variables.dart';
import '/helper/dart_ui.dart';
import '/helper/helper.dart';
import 'agent_button.dart';
import 'country_roller.dart';
import 'currency_roller.dart';
import 'total_fees.dart';

class SendFormFields extends StatefulWidget {
  const SendFormFields({super.key, this.keepAlive = false});

  final bool keepAlive;

  @override
  State<SendFormFields> createState() => _SendFormFieldsState();
}

class _SendFormFieldsState extends State<SendFormFields>
    with AutomaticKeepAliveClientMixin {
  late AppLocalizations arb;
  late Calculator _calculator;

  String selection = '';

  final List<TextInputFormatter> _input = [
    LengthLimitingTextInputFormatter(9),
    FilteringTextInputFormatter.digitsOnly,
  ];

  final double borderRadius = 11;

  @override
  void initState() {
    super.initState();
    _calculator = Provider.of<Calculator>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _calculator.clearFields();
    _calculator.agentsVisibility(false);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<Calculator>(builder: (_, state, child) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Global.appSettings.token.isEmpty)
            CountryRoller(
              send: true,
              title: arb.sendCountries,
              borderRadius: 11,
            ),
          if (state.showAgents)
            Row(
              children: [
                // Select country
                if (state.selectedRecipient == null)
                  Expanded(
                    child: CountryRoller(
                      title: arb.receiverCountries,
                      borderRadius: 11,
                    ),
                  ),
                if (state.selectedRecipient == null) const SizedBox(width: 10),

                // Select city.
                Expanded(
                  child: CityPicker(
                    country: state.receiverCountry,
                    onChange: (city) => state.setReceiveCity(city),
                    fieldColor: Theme.of(context).cardColor,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          TextFieldX(
            hint: arb.youSend,
            controller: state.sender,
            type: TextInputType.phone,
            input: _input,
            suffixIcon: Container(
              width: 60,
              alignment: Alignment.center,
              child: TextX(
                'USDT',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            borderRadius: borderRadius,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 4),
            onChanged: (String value) => state.setPrice(value),
          ),
          TextFieldX(
            hint: arb.receiverGets,
            controller: state.receiver,
            type: TextInputType.phone,
            input: _input,
            suffixIcon: const CurrencyRoller(),
            borderRadius: borderRadius,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            onChanged: (String value) => state.setPrice(value),
            onSubmitted: (_) => state.roundReceiverAmount(),
          ),
          if (!widget.keepAlive)
            if (state.receiverCity.agents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
                child: TextX(arb.selectProvider),
              ),
          if (state.showAgents)
            if (state.receiverCity.agents.isNotEmpty)
              MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: DartUI.isTablet ? 4 : 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: state.receiverCity.agents.length,
                itemBuilder: (_, i) {
                  selection = '${state.receiverAgent.id}';
                  return AgentButton(
                    () {
                      selection = '${state.receiverCity.agents[i].id}';
                      state.setAgent(state.receiverCity.agents[i]);
                    },
                    selected: selection == '${state.receiverCity.agents[i].id}',
                    agent: state.receiverCity.agents[i],
                  );
                },
              ),
          if (state.currencies.isNotEmpty) const SizedBox(height: 8),
          if (state.currencies.isNotEmpty) Text(arb.currenciesExchangeRate),
          if (state.currencies.isNotEmpty)
            Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              decoration: Decorations.note(context),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                itemCount: state.currencies.length,
                itemBuilder: (_, i) {
                  return Row(children: [
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextX(
                          state.currencies[i].name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text.rich(
                          textScaleFactor: 1.0,
                          TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: '1 USDT = '),
                              TextSpan(
                                text: Helper.priced(
                                  state.currencies[i].rate,
                                  currencyCode: state.currencies[i].code,
                                ),
                              ),
                            ],
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    if (i + 1 < state.currencies.length) const VDivider(),
                  ]);
                },
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: TotalFees(),
          ),
          SizedBox(height: state.receiverAgent.name.isNotEmpty ? 15 : 5),
        ],
      );
      return child;
    });
  }
}

/// ---------------------------------------------------------------------
///
///
///

// class CurrenciesNews extends StatefulWidget {
//   const CurrenciesNews({Key? key, required this.currencies}) : super(key: key);
//   final List<CurrencyModel> currencies;

//   @override
//   State<CurrenciesNews> createState() => _CurrenciesNewsState();
// }

// class _CurrenciesNewsState extends State<CurrenciesNews> {
//   final ScrollController controller = ScrollController();
//   late Timer timer;
//   final double scrollSpeed = 0.4; // Adjust the automatic scroll speed.
//   double scrollOffset = 0, itemWidth = 135;
//   bool forward = true;

//   @override
//   void initState() {
//     super.initState();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     timer = Timer.periodic(const Duration(milliseconds: 30), (_) => _scroll());
//   }

//   void _scroll() {
//     if (!controller.hasClients) return;
//     // Calculate the total width of all items
//     double totalWidth = widget.currencies.length * itemWidth;

//     if (totalWidth <= MediaQuery.of(context).size.width) {
//       // Stop automatic scrolling if the total width is less than or equal to
//       // the screen width
//       timer.cancel();
//       return;
//     }
//     if (forward) {
//       scrollOffset += scrollSpeed;
//       if (scrollOffset >= controller.position.maxScrollExtent) forward = false;
//     } else {
//       scrollOffset -= scrollSpeed;
//       if (scrollOffset <= 0) forward = true;
//     }
//     controller.animateTo(
//       scrollOffset,
//       duration: const Duration(milliseconds: 30),
//       curve: Curves.linear,
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 8),
//         Text('Currencies exchange rate'),
//         Container(
//           height: 50, // Adjust the height as needed
//           margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//           decoration: Decorations.note(context),
//           child: NotificationListener<ScrollNotification>(
//             onNotification: (notification) {
//               if (notification is ScrollStartNotification) {
//                 // The user starts scrolling, stop automatic scrolling
//                 timer.cancel();
//               } else if (notification is ScrollEndNotification) {
//                 // The user stops scrolling, resume automatic scrolling
//                 _startAutoScroll();
//               }
//               return false;
//             },
//             child: ListView.builder(
//               controller: controller,
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemExtent: itemWidth,
//               padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
//               itemCount: widget.currencies.length,
//               itemBuilder: (_, i) {
//                 return Row(children: [
//                   Container(
//                     alignment: Alignment.center,
//                     margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
//                     child: Text.rich(
//                       textScaleFactor: 1.0,
//                       TextSpan(
//                         children: <TextSpan>[
//                           const TextSpan(text: '1 USDT = '),
//                           TextSpan(
//                             text: Helper.priced(
//                               widget.currencies[i].rate,
//                               currencyCode: widget.currencies[i].code,
//                             ),
//                           ),
//                         ],
//                       ),
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ),
//                   if (i + 1 < widget.currencies.length)
//                     const SizedBox(width: 18, child: VDivider()),
//                 ]);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
