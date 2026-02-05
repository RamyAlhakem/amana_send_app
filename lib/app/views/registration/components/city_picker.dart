import 'package:amana_send/app/views/main_pages/home/widgets/area_widget.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/models/city.dart';
import 'package:amana_send/models/state.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/home/widgets/city.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/picker_form.dart';
import '/helper/helper.dart';
import '/models/country.dart';
import '/services/lang_service.dart';

class CityPicker extends StatefulWidget {
  const CityPicker({
    super.key,
    required this.country,
    required this.onChange,
    this.fieldColor,
  });

  final CountryModel country;
  final Function(StateModel) onChange;
  final Color? fieldColor;

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  CountryModel country = CountryModel();
  StateModel? selectedState;
  CityModel? selectedCity;
  List<StateModel> states = [];
  List<StateModel> allStates = [];
  final Set<int> _expandedStates = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      country = widget.country;
      if (country.states.isNotEmpty) {
        // Handle init if needed
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CityPicker oldWidget) {
    if (oldWidget.country != widget.country) {
      country = widget.country;
      if (widget.country.states.isNotEmpty) {
        selectedState = null;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final bool isAr = LangService.isAR();
    final calculator = Provider.of<Calculator>(context);
    return PickerForm(
      () {
        states = widget.country.states;
        allStates = states;
        if (states.isEmpty) {
          return Helper.toast(arb.selectCountry);
        }
        SettingsDialog(
          onChanged: (text) {
            if (text.isNotEmpty) {
              List<StateModel> foundStates = allStates
                  .where(
                      (e) => e.name.toLowerCase().contains(text.toLowerCase()))
                  .toList();
              states = foundStates;
              calculator.updateUi();
            } else {
              states = allStates;
              calculator.updateUi();
            }
          },
          onSubmit: null,
          title: arb.selectCityFromTheListBelow,
          subTitle: "",
          subTitleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          horizontalPadding: 0,
          content: (dialogSetState) => Scrollbar(
            interactive: true,
            thumbVisibility: true,
            thickness: 5,
            radius: const Radius.circular(100),
            child: Consumer<Calculator>(
              builder: (context, calculatorState, child) => ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                        isAr ? 30 : 10, 0, isAr ? 10 : 30, 15),
                    itemCount: states.length,
                    itemBuilder: (BuildContext _, int i) {
                      final bool isExpanded =
                          _expandedStates.contains(states[i].id);
                      return InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          dialogSetState(() {
                            if (isExpanded) {
                              _expandedStates.remove(states[i].id);
                            } else {
                              _expandedStates.add(states[i].id);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            City(
                              isExpanded: isExpanded,
                              city: CityModel(
                                name: states[i].name,
                                id: states[i].id,
                                coCode: states[i].coCode,
                                status: states[i].status,
                              ),
                              selected: selectedState == states[i],
                            ),
                            Visibility(
                              visible: isExpanded,
                              child: Container(
                                padding: EdgeInsets.all(
                                    states[i].cities.isEmpty ? 0 : 15),
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  spacing: 10,
                                  children: states[i]
                                      .cities
                                      .map(
                                        (city) => InkWell(
                                          onTap: () {
                                            Helper.log(
                                                "receiver city ${city.name} id:${city.id}");
                                            SettingsDialog.dismiss();
                                            widget.onChange(states[i]);
                                            calculatorState
                                                .setReceiveCity(city);
                                            calculator.setBorderColor(null);
                                          },
                                          child: AreaWidget(
                                            city: city,
                                            selected: calculatorState
                                                    .receiverCity.id ==
                                                city.id,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (__, ___) {
                      return const HDivider(
                        color: Colors.white,
                        height: 8,
                        thickness: 0.1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ).show();
      },
      hint: arb!.selectCity, // Expect arb update eventually
      value: (calculator.receiverCity.id != 0 &&
              calculator.receiverCity.name.isNotEmpty)
          ? calculator.receiverCity.name
          : arb.chooseTheCity,
      valueIcon: const Icon(LineIcons.city),
      color: Theme.of(context).cardColor,
      borderColor: calculator.borderColor,
    );
  }
}
