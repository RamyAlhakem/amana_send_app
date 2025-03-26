// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/registration/components/phone_country_picker.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/global/variables.dart';
import '/graphql/api/add_edit_recipient.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/recipient.dart';
import '/services/lang_service.dart';

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
  late AppLocalizations arb;
  RecipientModel? _recipient;

  late RegistrationState _registerState; // Includes countryCode & mobile.
  late RecipientsState _recipientProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _fatherName = TextEditingController();
  TextEditingController enName = TextEditingController();
  TextEditingController enLast = TextEditingController();
  TextEditingController enFather = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController _whatsApp = TextEditingController();

  bool keepSendProcess = false, isAR = false;

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
      _whatsApp = TextEditingController(text: _recipient?.whatsappNumber);

      if (widget.query.isNotEmpty) {
        if (widget.query['keepSendProcess'] == 'true') keepSendProcess = true;
      }
    }
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    isAR = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();

    _firstName.dispose();
    _lastName.dispose();
    _fatherName.dispose();

    _registerState.setCountry(null);
    _registerState.setCities(<CityModel>[]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: widget.recipient != 'null'
              ? arb.editRecipient
              : arb.addNewRecipient,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, kToolbarHeight),
            children: [
              TextX(
                arb.contactDetails,
                style: Theme.of(context).textTheme.labelMedium,
              ),

              // Phone country select
              const PhoneCountryPicker(isRegistration: false),
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextFieldX(
                  controller: _whatsApp,
                  hint: '${arb.whatsApp} ${arb.mobileNumber.toLowerCase()}',
                  type: TextInputType.phone,
                  input: TextFieldValidator.onlyDigits(),
                  onChanged: (_) =>
                      TextFieldValidator.validateMobile(_whatsApp),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(height: 8),
              TextX(
                arb.recipientName,
                style: Theme.of(context).textTheme.labelMedium,
              ),

              // Name
              Row(children: [
                Expanded(
                  child: TextFieldX(
                    controller: _firstName,
                    hint: arb.firstName,
                    type: TextInputType.name,
                    onChanged: (_) {
                      TextFieldValidator.arabic(context, _firstName);
                    },
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: TextFieldX(
                    controller: _lastName,
                    hint: arb.lastName,
                    type: TextInputType.name,
                    onChanged: (_) {
                      TextFieldValidator.arabic(context, _lastName);
                    },
                  ),
                ),
              ]),
              TextFieldX(
                controller: _fatherName,
                hint: arb.fatherName,
                type: TextInputType.name,
                onChanged: (_) {
                  TextFieldValidator.arabic(context, _fatherName);
                },
                onSubmitted: (_) => _submit(),
              ),
              isAR
              ?Container()
              :      Row(children: [
                Expanded(
                  child: TextFieldX(
                         validator: (String){
                  return null;
                },
                    controller: enName,
                    hint:"${ arb.firstName}(optional)",
                    type: TextInputType.name,
                    onChanged: (_) {
                      TextFieldValidator.latin(context, enName);
                    },
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: TextFieldX(
                               validator: (String){
                  return null;
                },
                    controller: enLast,
                    hint: "${ arb.lastName}(optional)",
                    type: TextInputType.name,
                    onChanged: (_) {
                      TextFieldValidator.latin(context, enLast);
                    },
                  ),
                ),
              ]),
              TextFieldX(
                           validator: (String){
                  return null;
                },
                controller: enFather,
                hint: "${ arb.fatherName}(optional)",
                type: TextInputType.name,
                onChanged: (_) {
                  TextFieldValidator.latin(context, enFather);
                },
                onSubmitted: (_) => _submit(),
              ),
              // TextFieldX(
              //     validator: (String){
              //     return null;
              //   },
              //   controller: enName,
              //   hint: "Recipient Name(optional)",
              //   type: TextInputType.name,
              //   onChanged: (_) {
              //     TextFieldValidator.latin(context, enName);
              //   },
              //   onSubmitted: (_) => _submit(),
              // ),
              TextFieldX(
                // ignore: avoid_types_as_parameter_names
                validator: (String){
                  return null;
                },
                controller: notes,
                hint: "Notes(optional)",
                type: TextInputType.name,
                onChanged: (_) {
                  // TextFieldValidator.latin(context, notes);
                },
                onSubmitted: (_) => _submit(),
              ),
              // ---

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
                      TextX(arb.cancel),
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
                            ? arb.addRecipient
                            : arb.editRecipient,
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                decoration: Decorations.note(context),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                width: MediaQuery.of(context).size.width,
                child: TextX(
                  arb.pleaseMakeSureToEnterPhoneNumberWhatsAppNumberAndFullNameCorrectlyToAvoidDelayingTheTransferDelivery,
                  style: const TextStyle(color: MainColors.lightRed),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

    if (_registerState.country == null) return Helper.toast(arb.selectCountry);
    if (_registerState.mobile.text.isEmpty) {
      return Helper.toast(arb.enterMobileNumber);
    }
    if (isNameEmpty()) return Helper.toast(arb.enterRecipientName);

    Global.snackKey.currentState?.hideCurrentMaterialBanner();

    AddEditRecipientAPI(
      firstName: enName.text,
      lastName: enLast.text,
      fatherName: enFather.text,
      countryCode: '${_registerState.country?.coCode}',
      mobile: _registerState.mobile.text,
      whatsApp: _whatsApp.text,
      arFatherName: _fatherName.text,
      arFirstName:_firstName.text ,
      arLastName:_lastName.text ,
      note: notes.text,
      id: widget.recipient != 'null' ? _recipient!.id : 0,
    ).request().whenComplete(() {
      if (_recipientProvider.isEditRecipient) {
        _recipientProvider.offEditRecipient();
        if (!keepSendProcess) context.pop();
      }
    });
  }
}
