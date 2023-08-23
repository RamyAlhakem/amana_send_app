import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/registration/components/city_picker.dart';
import '/app/views/registration/components/phone_country_picker.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/global/variables.dart';
import '/graphql/api/add_edit_recipient.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/models/recipient.dart';

class AddRecipient extends StatefulWidget {
  const AddRecipient({
    super.key,
    this.recipient = 'null',
    this.query = const <String, String>{},
  });

  final String recipient;
  final Map<String, String> query;

  @override
  State<AddRecipient> createState() => _AddRecipientState();
}

class _AddRecipientState extends State<AddRecipient> {
  late AppLocalizations? _arb;
  RecipientModel? _recipient;

  late RegistrationState _registerState; // Includes countryCode & mobile.
  late RecipientsState _recipientProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _fatherName = TextEditingController();

  TextEditingController _arFirstName = TextEditingController();
  TextEditingController _arLastName = TextEditingController();
  TextEditingController _arFatherName = TextEditingController();

  TextEditingController _relation = TextEditingController();

  TextEditingController _area = TextEditingController();
  String _pickUp = '';

  TextEditingController _bankAccountNumber = TextEditingController();
  TextEditingController _bankName = TextEditingController();

  bool bankFocus = false;
  bool keepSendProcess = false;

  final FocusNode _bankAccountNumberNode = FocusNode();

  bool arabicMandatory() =>
      (_registerState.country ?? CountryModel()).recipientArabicMandatory;
  bool englishMandatory() =>
      (_registerState.country ?? CountryModel()).recipientEnglishMandatory;

  @override
  void initState() {
    super.initState();
    _registerState = Provider.of<RegistrationState>(context, listen: false);
    _recipientProvider = Provider.of<RecipientsState>(context, listen: false);

    if (widget.recipient != 'null') {
      _recipient = RecipientModel.fromJson(jsonDecode(widget.recipient));
      _firstName = TextEditingController(text: _recipient?.firstName);
      _lastName = TextEditingController(text: _recipient?.lastName);
      _fatherName = TextEditingController(text: _recipient?.fatherName);

      _arFirstName = TextEditingController(text: _recipient?.arFirstName);
      _arLastName = TextEditingController(text: _recipient?.arLastName);
      _arFatherName = TextEditingController(text: _recipient?.arFatherName);

      _relation = TextEditingController(text: _recipient?.relative);

      _area = TextEditingController(text: _recipient?.area);
      _bankAccountNumber =
          TextEditingController(text: _recipient?.bankAccountNumber);
      _bankName = TextEditingController(text: _recipient?.bankAccountHolder);

      if (_recipient!.country.cities.isNotEmpty) {
        _pickUp = _recipient?.country.cities.first.areaNote ?? '';
      }

      if (widget.query.isNotEmpty) {
        if (widget.query['bankFocus'] == 'true') {
          bankFocus = true;
          _bankAccountNumberNode.requestFocus();
        }
        if (widget.query['keepSendProcess'] == 'true') keepSendProcess = true;
      }
    }
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();

    _arFirstName.dispose();
    _arLastName.dispose();
    _arFatherName.dispose();

    _firstName.dispose();
    _lastName.dispose();
    _fatherName.dispose();

    _relation.dispose();

    _area.dispose();

    _registerState.setCountry(null);
    _registerState.setCities(<CityModel>[]);
    _registerState.setCity(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: widget.recipient != 'null'
              ? _arb!.editRecipient
              : _arb!.addNewRecipient,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, kToolbarHeight),
            children: [
              TextX(
                _arb!.contactDetails,
                style: Theme.of(context).textTheme.labelMedium,
              ),

              // Phone country select
              PhoneCountryPicker(
                isRegistration: false,
                // clear previous city [areaNote] when recipient country changed.
                areaNote: (clear) => setState(() => _pickUp = clear),
              ),

              // City select
              CityPicker(
                onChange: (city) {
                  setState(() => _pickUp = city.areaNote);
                  _registerState.setCity(city);
                },
                country: _registerState.country,
                cities: _registerState.cities,
                city: _registerState.city,
              ),
              TextFieldX(
                controller: _area,
                hint: _arb!.areaOptionalEXStreetName,
                type: TextInputType.name,
                validator: (v) => null,
              ),
              Container(
                decoration: Decorations.border(context),
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextX(
                      _arb!.pickUpPointsReadOnly,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    TextC(
                      _pickUp,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              TextX(
                arabicMandatory()
                    ? _arb!.recipientNameArabic
                    : _arb!.recipientNameArabicOptional,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(children: [
                Expanded(
                  child: TextFieldX(
                    controller: _arFirstName,
                    hint: _arb!.firstName,
                    type: TextInputType.name,
                    onChanged: (v) =>
                        TextFieldValidator.arabic(context, _arFirstName),
                    validator: (v) => null,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: TextFieldX(
                    controller: _arLastName,
                    hint: _arb!.lastName,
                    type: TextInputType.name,
                    onChanged: (v) =>
                        TextFieldValidator.arabic(context, _arLastName),
                    validator: (v) => null,
                  ),
                ),
              ]),
              TextFieldX(
                controller: _arFatherName,
                hint: _arb!.fatherName,
                type: TextInputType.name,
                onChanged: (v) =>
                    TextFieldValidator.arabic(context, _arFatherName),
                validator: (v) => null,
              ),
              const SizedBox(height: 8),
              TextX(
                englishMandatory()
                    ? _arb!.recipientNameEnglish
                    : _arb!.recipientNameEnglishOptional,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: TextFieldX(
                          controller: _firstName,
                          hint: _arb!.firstName,
                          type: TextInputType.name,
                          onChanged: (v) =>
                              TextFieldValidator.latin(context, _firstName),
                          validator: (v) => null,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: TextFieldX(
                          controller: _lastName,
                          hint: _arb!.lastName,
                          type: TextInputType.name,
                          onChanged: (v) =>
                              TextFieldValidator.latin(context, _lastName),
                          validator: (v) => null,
                        ),
                      ),
                    ]),
                    TextFieldX(
                      controller: _fatherName,
                      hint: _arb!.fatherName,
                      type: TextInputType.name,
                      onChanged: (v) =>
                          TextFieldValidator.latin(context, _fatherName),
                      validator: (v) => null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextX(
                _arb!.relation,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              TextFieldX(
                controller: _relation,
                hint: _arb!.relativeRelation,
                type: TextInputType.name,
              ),

              // bank.
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  initiallyExpanded: bankFocus,
                  title: TextX(
                    _arb!.recipientBankDetailsOptional,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: context.isDarkMode
                            ? Colors.grey[850]
                            : Colors.grey[350],
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: [
                            TextFieldX(
                              controller: _bankAccountNumber,
                              hint: _arb!.accountNumber,
                              focusNode: _bankAccountNumberNode,
                              validator: (v) => null,
                            ),
                            TextFieldX(
                              controller: _bankName,
                              hint: _arb!.bankName,
                              type: TextInputType.name,
                              onChanged: (v) =>
                                  TextFieldValidator.latin(context, _bankName),
                              validator: (v) => null,
                              onSubmitted: (v) => _submit(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              RowSpaceBetween([
                ExpandButton(
                  () => context.pop(),
                  height: 45,
                  color: MainColors.red,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.close),
                      const SizedBox(width: 5),
                      TextX(_arb!.cancel),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ExpandButton(
                  () => _submit(),
                  height: 45,
                  color: MainColors.color3,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.recipient == 'null' ? Icons.add : Icons.check,
                      ),
                      const SizedBox(width: 5),
                      TextX(
                        widget.recipient == 'null'
                            ? _arb!.addRecipient
                            : _arb!.editRecipient,
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  bool isArNameEmpty() {
    bool empty = false;
    if (_arFirstName.text.isEmpty) empty = true;
    if (_arFatherName.text.isEmpty) empty = true;
    if (_arLastName.text.isEmpty) empty = true;
    return empty;
  }

  bool isNameEmpty() {
    bool empty = false;
    if (_firstName.text.isEmpty) empty = true;
    if (_fatherName.text.isEmpty) empty = true;
    if (_lastName.text.isEmpty) empty = true;
    return empty;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_registerState.country == null) {
      return Helper.toast(_arb!.selectCountry);
    }

    if (_registerState.mobile.text.isEmpty) {
      return Helper.toast(_arb!.enterMobileNumber);
    }

    if (_registerState.city == null) return Helper.toast(_arb!.selectCity);

    if (_registerState.country!.recipientArabicMandatory) {
      if (isArNameEmpty()) {
        return Helper.toast(_arb!.enterRecipientArabicName);
      }
    }

    if (_registerState.country!.recipientEnglishMandatory) {
      if (isNameEmpty()) {
        return Helper.toast(_arb!.enterRecipientEnglishName);
      }
    }

    if (isArNameEmpty() && isNameEmpty()) {
      return Helper.toast(_arb!.enterRecipientEnglishName);
    }

    if (_bankAccountNumber.text.isNotEmpty) {
      if (_bankName.text.isEmpty) return Helper.toast('Enter bank name');
    }

    Global.snackKey.currentState?.hideCurrentMaterialBanner();

    AddEditRecipientAPI(
      context,
      firstName: _firstName.text,
      lastName: _lastName.text,
      fatherName: _fatherName.text,
      arFirstName: _arFirstName.text,
      arLastName: _arLastName.text,
      arFatherName: _arFatherName.text,
      relation: _relation.text,
      countryCode: '${_registerState.country?.coCode}',
      mobile: _registerState.mobile.text,
      cityId: _registerState.city!.id,
      area: _area.text,
      bankAccountNumber: _bankAccountNumber.text,
      bankName: _bankName.text,
      id: widget.recipient != 'null' ? _recipient!.id : 0,
    ).request().whenComplete(() {
      if (_recipientProvider.isEditRecipient) {
        _recipientProvider.offEditRecipient();
        if (!keepSendProcess) context.pop();
      }
    });
  }
}
