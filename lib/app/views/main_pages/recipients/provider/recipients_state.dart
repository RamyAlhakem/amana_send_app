import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/models/recipient.dart';
import '/router/app_route.dart';

class RecipientsState extends ChangeNotifier {
  bool _isLoading = true;

  bool _isEditRecipient = false;

  List<RecipientModel> _all = <RecipientModel>[];
  RecipientModel _recipient = RecipientModel();

  bool get isLoading => _isLoading;

  bool get isEditRecipient => _isEditRecipient;

  List<RecipientModel> get all => _all;
  RecipientModel get recipient => _recipient;

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  void getAll(List<RecipientModel> elements) {
    _all = elements;
    notifyListeners();
  }

  void getRecipient(RecipientModel recipient) {
    _recipient = recipient;
    notifyListeners();
  }

  void editRecipient(
    BuildContext context,
    RecipientModel recipient, {
    bool bankFocus = false,
    bool keepSendProcess = false,
  }) {
    _isEditRecipient = true;
    context.read<RegistrationState>().setCountry(recipient.country);
    context.read<Calculator>().receiveCountries.any((c) {
      if (c.coCode == recipient.country.coCode) {
        context.read<RegistrationState>().setCities(c.cities);
      }
      return c.coCode == recipient.country.coCode;
    });

    context.read<RegistrationState>().mobile.text = '${recipient.mobile}';
    context.pushNamed(
      AppRoute.addRecipient,
      pathParameters: <String, String>{
        'recipient': jsonEncode(recipient),
      },
      queryParameters: <String, String>{
        'bankFocus': bankFocus.toString(),
        'keepSendProcess': keepSendProcess.toString(),
      },
    );
  }

  void offEditRecipient() => _isEditRecipient = false;

  void clearRecipients() {
    _all.clear();
    notifyListeners();
  }
}
