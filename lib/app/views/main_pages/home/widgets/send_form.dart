import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      Tutorial(context).showTutorial(Tutorial(context).targetSendForm());
    });
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isHome = GoRouter.of(context).location == '/';
    Helper.log('location: ${GoRouter.of(context).location}');
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
      child = Column(
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
                if (state.selectedRecipient == null) const SizedBox(width: 10),

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
            if (state.receiverCity.agents.isNotEmpty)
              MasonryGridView.count(
                key: isHome ? Tutorial.key3 : null,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: ScreenSize.isTablet ? 4 : 2,
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
          TextFieldX(
            key: isHome ? Tutorial.key4 : null,
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
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
            onChanged: (String value) => state.setPrice(value),
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
                    Helper.priced(
                      state.sendCountry.currency.rate * send,
                      currencyCode: state.sendCountry.currency.code,
                    ),
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
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
            onSubmitted: (_) => state.roundReceiverAmount(),
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
