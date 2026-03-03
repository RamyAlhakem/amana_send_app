import 'package:amana_send/app/views/main_pages/home/widgets/area_widget.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/widgets/text/text_x.dart';
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
  TextEditingController cityFilterController = TextEditingController();
  CountryModel country = CountryModel();
  StateModel? selectedState;
  CityModel? selectedCity;
  List<StateModel> states = [];
  List<StateModel> allStates = [];

  final Set<int> _expandedStates = {};
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
              String searchText = text.toLowerCase();
              List<StateModel> foundStates = [];

              for (var state in allStates) {
                // Check if state name matches
                bool stateMatches =
                    state.name.toLowerCase().contains(searchText);

                // Check if any city within this state matches
                List<CityModel> matchingCities = state.cities
                    .where(
                        (city) => city.name.toLowerCase().contains(searchText))
                    .toList();

                if (stateMatches) {
                  // If state matches, include it with all its cities
                  foundStates.add(state);
                  // Auto-expand if cities exist
                  if (state.cities.isNotEmpty) {
                    _expandedStates.add(state.id);
                  }
                } else if (matchingCities.isNotEmpty) {
                  // If only cities match, create a filtered state with matching cities
                  StateModel filteredState = StateModel(
                    id: state.id,
                    name: state.name,
                    coCode: state.coCode,
                    status: state.status,
                    cities: matchingCities,
                  );
                  foundStates.add(filteredState);
                  // Auto-expand to show matching cities
                  _expandedStates.add(state.id);
                }
              }

              states = foundStates;
              calculator.updateUi();
            } else {
              states = allStates;
              _expandedStates.clear();
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
                      final TextEditingController controller =
                          _controllers.putIfAbsent(
                              states[i].id, () => TextEditingController());
                      List<CityModel> foundCities = controller.text.isEmpty
                          ? states[i].cities
                          : states[i]
                              .cities
                              .where((city) => city.name
                                  .toLowerCase()
                                  .contains(controller.text.toLowerCase()))
                              .toList();

                      return InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          dialogSetState(() {
                            if (isExpanded) {
                              _expandedStates.remove(states[i].id);
                            } else {
                              _expandedStates.add(states[i].id);
                              if (states[i].cities.length == 1) {
                                SettingsDialog.dismiss();
                                widget.onChange(states[i]);
                                calculatorState
                                    .setReceiveCity(states[i].cities.first);
                                calculator.setBorderColor(null);
                              }
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
                                    // color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  children: [
                                    // TextField(
                                    //   controller: controller,
                                    //   onChanged: (text) {
                                    //     Helper.log(
                                    //         "search for city with text $text");
                                    //     calculatorState.updateUi();
                                    //   },
                                    //   decoration: InputDecoration(
                                    //     filled: true,
                                    //     hintText: arb.search,
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(10),
                                    //     ),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(10),
                                    //     ),
                                    //   ),
                                    // ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: foundCities.length,
                                      itemBuilder: (context, index) {
                                        final city = foundCities[index];
                                        return InkWell(
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
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return HDivider(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                          height: 1,
                                          thickness: 1,
                                        );
                                      },
                                    ),
                                  ],
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
