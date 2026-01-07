import 'dart:async';

import 'package:amana_send/app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/components/city_picker.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_shine.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/helper/screen_size.dart';
import '/services/tutorial_service.dart';
import '/tools/tools.dart';
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
  Timer? debounceTimer;
  String selection = '';

  bool isHome = true;

  final List<TextInputFormatter> _input = [
    LengthLimitingTextInputFormatter(9),
    FilteringTextInputFormatter.digitsOnly,
  ];

  final double borderRadius = 11;

  @override
  void initState() {
    super.initState();
    _calculator = Provider.of<Calculator>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  _calculator = Provider.of<Calculator>(context, listen: false);
      Tutorial(context).showTutorial();
      _calculator.clearAgents();
//       Future.delayed(const Duration(seconds: 2),(){
// _calculator.setIsLoad(false);

//       });
    });
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isHome = '${GoRouterState.of(context).uri}' == '/';
    Helper.log('location: ${GoRouterState.of(context).uri}');
    Helper.log('isHome: $isHome');
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
      final double send = double.tryParse(state.sender.text) ?? 1;
      child = state.isLoad
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
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
                            key: isHome ? Tutorial.key1 : null,
                            title: arb.receiverCountries,
                            borderRadius: 11,
                          ),
                        ),
                      if (state.selectedRecipient == null)
                        const SizedBox(width: 10),

                      // Select city.
                      Expanded(
                        child: CityPicker(
                          key: isHome ? Tutorial.key2 : null,
                          country: state.receiverCountry,
                          onChange: (city) => state.setReceiveCity(city),
                          fieldColor: Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                if (!widget.keepAlive)
                  if (state.receiverCity.agents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: TextX(
                        arb.selectPickUpPoint,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                if (state.showAgents)
                  if (state.agents.isNotEmpty)
                    MasonryGridView.count(
                      key: isHome ? Tutorial.key3 : null,
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: ScreenSize.isTablet ? 4 : 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      itemCount: state.agents.length,
                      itemBuilder: (_, i) {
                        selection = '${state.receiverAgent.id}';
                        return AgentButton(
                          () {
                            Helper.log("aget tab==> ${state.agents[i].tab}");
                            selection = '${state.agents[i].id}';
                            state.setAgent(state.agents[i]);
                          },
                          selected: selection == '${state.agents[i].id}',
                          agent: state.agents[i],
                        );
                      },
                    ),
                // you send
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFieldX(
                        key: isHome ? Tutorial.key4 : null,
                        hint: arb.youSend,
                        controller: state.sender,
                        enabled: state.senderLoading ? false : true,
                        type: TextInputType.phone,
                        input: _input,
                        borderRadius: borderRadius,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        suffixIcon: Container(
                          width: 60,
                          alignment: Alignment.center,
                          child: state.senderLoading
                              ? const LoadingWidget(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                )
                              : TextX(
                                  state.paymentMethodName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                        onChanged: (String value) {
                          state.receiver.clear();
                          state.recieverLoading = true;
                          if (debounceTimer?.isActive ?? false) {
                            debounceTimer?.cancel();
                          }
                          debounceTimer = Timer(
                              const Duration(milliseconds: 1000), () async {
                            state.setPrice(value);
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Today exchange rate
                Padding(
                  key: isHome ? Tutorial.key5 : null,
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: RowSpaceBetween([
                    TextShine(arb.estimatedValueInLocalCurrency, fontSize: 12),
                    const SizedBox(width: 10),
                    Flexible(
                      child: FittedBox(
                        
                        child: TextX(
                          '${state.sendCountry.currency.code} ${Tools.nicePrice(state.sendCountry.currency.rate * send)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ]),
                ),

                TextFieldX(
                  key: isHome ? Tutorial.key6 : null,
                  hint: arb.receiverGets,
                  controller: state.receiver,
                  type: TextInputType.phone,
                  enabled: state.recieverLoading ? false : true,
                  input: _input,
                  suffixIcon: Container(
                    child: state.recieverLoading
                        ? const LoadingWidget(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10))
                        : const CurrencyRoller(),
                  ),

                  borderRadius: borderRadius,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  onChanged: (String value) {
                    state.senderLoading = true;
                    state.sender.clear();
                    if (debounceTimer?.isActive ?? false) {
                      debounceTimer?.cancel();
                    }
                    debounceTimer =
                        Timer(const Duration(milliseconds: 1000), () async {
                      state.setPrice(value);
                      FocusScope.of(context).unfocus();
                    });
                  },
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  // onSubmitted: (_) => state.roundReceiverAmount(),
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
