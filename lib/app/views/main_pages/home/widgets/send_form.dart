import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/components/city_picker.dart';
import '/app/widgets/expander.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/helper/dart_ui.dart';
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
          Expander(
            expand: state.receiverAgent.name.isNotEmpty,
            child: Wrap(
              children: [
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
              ],
            ),
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
          Expander(
            expand: state.receiverAgent.name.isNotEmpty,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: TotalFees(),
            ),
          ),
          SizedBox(height: state.receiverAgent.name.isNotEmpty ? 15 : 5),
        ],
      );
      return child;
    });
  }
}
