import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/components/city_picker.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/helper/dart_ui.dart';
import '/services/lang_service.dart';
import '/tools/tools.dart';
import 'country_roller.dart';
import 'currency_roller.dart';
import 'receive_button.dart';
import 'total_fees.dart';

class SendFormFields extends StatefulWidget {
  const SendFormFields({super.key, this.keepAlive = false});

  final bool keepAlive;

  @override
  State<SendFormFields> createState() => _SendFormFieldsState();
}

class _SendFormFieldsState extends State<SendFormFields>
    with AutomaticKeepAliveClientMixin {
  late AppLocalizations? _arb;
  late Calculator _calculator;

  List<bool> selection = <bool>[];

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
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _calculator.clearFields();
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
          Row(
            children: [
              // Select country
              Expanded(
                child: CountryRoller(
                  title: _arb!.receiverCountries,
                  borderRadius: borderRadius,
                ),
              ),
              const SizedBox(width: 10),

              // Select city.
              Expanded(
                child: Stack(
                  children: [
                    CityPicker(
                      onChange: (city) => state.setReceiveCity(city),
                      country: state.receiverCountry,
                      cities: state.receiverCountry.cities,
                      city: state.receiverCity,
                      fieldColor: Theme.of(context).cardColor,
                    ),
                    Positioned(
                      top: 0,
                      right: LangService.isAR() ? 4 : null,
                      left: LangService.isAR() ? null : 4,
                      child: Container(
                        decoration: Decorations.flat(context),
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: TextX(
                          _arb!.selectCity,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 10,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextFieldX(
            hint: _arb!.youSend,
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
            onChanged: (String value) => state.setPrice(
              value,
              state.receiverCountry,
            ),
          ),
          TextFieldX(
            hint: _arb!.receiverGets,
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
            onChanged: (String value) =>
                state.setPrice(value, state.sendCountry),
          ),
          if (state.receiverCity.providers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
              child: TextX(_arb!.selectReceiveType),
            ),
          if (state.receiverCity.providers.isNotEmpty)
            MasonryGridView.count(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: DartUI.isTablet ? 4 : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: state.receiverCity.providers.length,
              itemBuilder: (_, i) {
                // Fill up select list once empty or when recipients list is changed.
                selection =
                    Tools.setSelect(state.receiverCity.providers, selection);
                return ReceiveButton(
                  () {
                    selection =
                        Tools.setSelect(state.receiverCity.providers, <bool>[]);
                    selection[i] = !selection[i];
                    state.setReceiveType(state.receiverCity.providers[i]);
                  },
                  selected: selection[i],
                  title: state.receiverCity.providers[i].name,
                  icon: state.receiverCity.providers[i].iconUrl,
                );
              },
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: TotalFees(),
          ),
          const SizedBox(height: 15),
        ],
      );
      return child;
    });
  }
}
