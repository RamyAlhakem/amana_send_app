import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/home/widgets/country.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/models/country.dart';
import '/services/lang_service.dart';
import '/tools/tools.dart';

class PhoneCountryPicker extends StatefulWidget {
  const PhoneCountryPicker({super.key, this.isRegistration = true});

  final bool isRegistration;

  @override
  State<PhoneCountryPicker> createState() => _PhoneCountryPickerState();
}

class _PhoneCountryPickerState extends State<PhoneCountryPicker>
    with AutomaticKeepAliveClientMixin {
  late Calculator _calculator;
  late RegistrationState provider;

  late AppLocalizations? _arb;

  late List<CountryModel> _countries;
  late bool isRegistration;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<RegistrationState>(context, listen: false);
    _calculator = Provider.of<Calculator>(context, listen: false);
    isRegistration = widget.isRegistration;
    _countries = isRegistration
        ? _calculator.sendCountries
        : _calculator.receiveCountries;
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.mobile.clear();
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isAr = LangService.isAR();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFieldX(
        onSubmitted: (_) {
          if (!provider.isRegister) {
            FocusScope.of(context).requestFocus(provider.passwordNode);
          }
        },
        controller: provider.mobile,
        hint: _arb!.mobileNumber,
        type: TextInputType.phone,
        prefixIcon: Visibility(
          visible: _countries.isNotEmpty,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => SettingsDialog(
              onSubmit: null,
              title: _arb!.countries,
              subTitle: _arb!.selectCountryPhoneCodeFromTheListBelow,
              subTitleStyle:
                  const TextStyle(color: Colors.white, fontSize: 14),
              horizontalPadding: 0,
              content: (state) => Scrollbar(
                interactive: true,
                thumbVisibility: true,
                thickness: 5,
                radius: const Radius.circular(100),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                          isAr ? 30 : 10, 0, isAr ? 10 : 30, 15),
                      itemCount: _countries.length,
                      itemBuilder: (BuildContext _, int i) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () => state(() {
                            setState(() {
                              if (isRegistration) {
                                provider.setCountry(
                                  _calculator.setSendCountry(_countries[i]),
                                );
                              } else {
                                provider.setCountry(
                                  _calculator
                                      .setReceiverCountry(_countries[i]),
                                );
                              }
                              provider.setCities(_countries[i].cities);
      
                              _calculator.setPrice(_calculator.sender.text,
                                  usd: _calculator.sendUSD);
                            });
      
                            SettingsDialog.dismiss();
                          }),
                          child: Country(
                            registration: true,
                            country: _countries[i],
                            selected: provider.country?.coCode ==
                                _countries[i].coCode,
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
            ).show(),
            child: Visibility(
              visible: provider.country == null,
              replacement: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  if (provider.country != null)
                    Flag.fromString(
                      provider.country!.coCode,
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                      borderRadius: 100,
                    ),
                  const SizedBox(width: 8),
                  if (provider.country != null)
                    TextX('+${provider.country!.phoneCode}'),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Icon(Icons.expand_more),
                  ),
                  TextX(
                    _arb!.country,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        input: TextFieldValidator.onlyDigits(),
        onChanged: (_) => TextFieldValidator.validateMobile(provider.mobile),
        validator: (v) {
          if (v == '' && provider.isRegister) {
            return _arb!.mobileNumber;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
