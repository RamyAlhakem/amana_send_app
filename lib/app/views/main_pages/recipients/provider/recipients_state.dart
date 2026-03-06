import 'dart:convert';

import 'package:amana_send/helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/models/recipient.dart';
import '/router/app_route.dart';

class RecipientsState extends ChangeNotifier {
  bool _isLoading = true;
  bool _isLoadingBtn = false;
  int _page = 1;
  bool _isFinish = false;

  bool _isEditRecipient = false;

  List<RecipientModel> _all = <RecipientModel>[];
  List<RecipientModel> foundReceipients = <RecipientModel>[];
  List<RecipientModel> receipients = <RecipientModel>[];
  RecipientModel _recipient = RecipientModel();

  bool get isLoading => _isLoading;
  int get page => _page;
  bool get isLoadingBtn => _isLoadingBtn;

  bool get isEditRecipient => _isEditRecipient;

  List<RecipientModel> get all => _all;
  RecipientModel get recipient => _recipient;

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  bool get isFinish => _isFinish;

  void getAll(List<RecipientModel> elements, {int page = 1}) {
    if (page == 1) {
      _all = elements;
      receipients = _all;
      Helper.log("add $page ");
    } else {
      for (var element in elements) {
        if (!_all.any((item) => item.id == element.id)) {
          _all.add(element);
        }
      }

      Helper.log("add all");
    }
    if (elements.isEmpty) {
      _isFinish = true;
    } else {
      _isFinish = false;
    }

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
        context
            .read<RegistrationState>()
            .setCities(c.states.expand((s) => s.cities).toList());
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

  search(String text) {
    if (text.isNotEmpty) {
      foundReceipients = all
          .where((e) =>
              (("${e.firstName} ${e.fatherName} ${e.lastName}").toLowerCase())
                  .contains(text.toLowerCase()))
          .toList();
      receipients = foundReceipients;
      notifyListeners();
    } else {
      receipients = all;
      notifyListeners();
    }
  }

  updateUi() {
    notifyListeners();
  }

  changeLoadBtn(bool load) {
    _isLoadingBtn = load;
    // notifyListeners();
  }

  increasePage() {
    _page++;
    notifyListeners();
  }

  resetPage() {
    _page = 1;
    Helper.log("reset page $_page");
    // notifyListeners();
  }
}
