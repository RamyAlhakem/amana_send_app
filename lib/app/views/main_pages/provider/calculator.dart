import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/models/currency.dart';
import '/models/metadata.dart';
import '/models/payment_method.dart';
import '/models/provider.dart';
import '/models/recipient.dart';
import '/models/transfer.dart';
import '/models/user.dart';
import '/router/app_route.dart';

class Calculator extends ChangeNotifier {
  static final BuildContext context = Global.key.currentContext!;
  static late AppLocalizations? _arb;

  double _percentFee = 0;
  double _minFee = 0;
  double _usdRate = 0;
  double _usdRatio = 0;
  double _maxUSD = 0;
  double _minUSD = 0;

  bool _isLoading = true;

  int _onlinePaymentMethodId = 0;
  int _cashPaymentMethodId = 0;

  RecipientModel? _selectedRecipient;

  List<ProviderModel> _providers = <ProviderModel>[];
  List<PaymentMethodModel> _payments = <PaymentMethodModel>[];

  List<CountryModel> _sendCountries = <CountryModel>[];
  List<CountryModel> _receiveCountries = <CountryModel>[];

  CountryModel _sendCountry = CountryModel();
  CountryModel _receiverCountry = CountryModel();
  CityModel _receiverCity = CityModel();

  TextEditingController _sender = TextEditingController();
  TextEditingController _receiver = TextEditingController();

  int _receiveType = 0;
  String _receiveTypeTitle = '';
  bool _sendUSD = false;

  double _fees = 0;

  double _amountPlusFee = 0;
  double _exchangeRate = 0;

  //____________________________________________________________________________

  double get percentFee => _percentFee;
  double get minFee => _minFee;
  double get usdPrice => _usdRate;
  double get usdRatio => _usdRatio;
  double get maxUSD => _maxUSD;
  double get minUSD => _minUSD;

  bool get isLoading => _isLoading;

  int get onlinePaymentMethodId => _onlinePaymentMethodId;
  int get cashPaymentMethodId => _cashPaymentMethodId;

  RecipientModel? get selectedRecipient => _selectedRecipient;

  List<PaymentMethodModel> get payments => _payments;
  List<ProviderModel> get providers => _providers;

  List<CountryModel> get sendCountries => _sendCountries;
  List<CountryModel> get receiveCountries => _receiveCountries;
  CityModel get receiverCity => _receiverCity;

  CountryModel get sendCountry => _sendCountry;
  CountryModel get receiverCountry => _receiverCountry;

  TextEditingController get sender => _sender;
  TextEditingController get receiver => _receiver;

  int get receiveType => _receiveType;
  String get receiveTypeTitle => _receiveTypeTitle;
  bool get sendUSD => _sendUSD;

  double get fees => _fees;
  double get amountPlusFee => _amountPlusFee;
  double get exchangeRate => _exchangeRate;

  //** */
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  //** */

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  void initializeData() {
    _percentFee = AppMetadata.get.sendsFees;
    _minFee = AppMetadata.get.minimumSendFee;
    _usdRate = AppMetadata.get.usdRate;
    _usdRatio = AppMetadata.get.usdRatio;

    _fees = _minFee;
  }

  //**Select a recipient.
  void selectRecipient(RecipientModel recipient) {
    _selectedRecipient = recipient;

    notifyListeners();
  }

  //**DISPOSE send process.
  void clearRecipient() => _selectedRecipient = null;

  //**Get sender countries for registration purpose & setting exchange rates.
  void getSendCountries(List<CountryModel> countries) {
    final UserModel user = Database().getUser;

    _sendCountries = countries;

    if (Global.appSettings.token.isEmpty) {
      _sendCountry = countries.first;
    } else {
      _sendCountry = user.country;
    }

    setExchangeRate();
    notifyListeners();
  }

  //**Get receiver countries to add a recipient & setting exchange rates.
  void getReceiveCountries(List<CountryModel> countries) {
    _receiveCountries = countries;
    if (countries.isNotEmpty) {
      _receiverCountry = countries.first;
      if (countries.first.cities.isNotEmpty) {
        _receiverCity = countries.first.cities.first;
      }
    }

    // if [usdAvailability] is mandatory which is equal 2.
    _sendUSD = _receiverCountry.usdAvailability == 2;

    initializeData();
    setExchangeRate();
    notifyListeners();
  }

  //**Get receiver city.
  void setReceiveCity(CityModel city) {
    _receiverCity = city;

    notifyListeners();
  }

  void clearFields() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sender.clear();
      _receiver.clear();
      _amountPlusFee = 0;
    });
  }

  bool isRecipientArabicMandatoryNameEmpty(RecipientModel recipient) {
    bool empty = false;

    if (recipient.country.recipientArabicMandatory) {
      if (recipient.arFirstName.isEmpty) empty = true;
      if (recipient.arFatherName.isEmpty) empty = true;
      if (recipient.arLastName.isEmpty) empty = true;
    }

    return empty;
  }

  bool isRecipientEnglishMandatoryNameEmpty(RecipientModel recipient) {
    bool empty = false;

    if (recipient.country.recipientEnglishMandatory) {
      if (recipient.firstName.isEmpty) empty = true;
      if (recipient.fatherName.isEmpty) empty = true;
      if (recipient.lastName.isEmpty) empty = true;
    }

    return empty;
  }

  void getPayments(List<PaymentMethodModel> elements) {
    _payments = elements;

    List.generate(elements.length, (index) {
      // isManual = 1 which is cash.
      // isManual = 0 which is online.
      if (elements[index].isManual == 1) {
        _cashPaymentMethodId = elements[index].id;
      } else if (elements[index].isManual == 0) {
        _onlinePaymentMethodId = elements[index].id;
      }
    });

    notifyListeners();
  }

  void getProviders(List<ProviderModel> elements) {
    _providers = elements;

    notifyListeners();
  }

  CountryModel setSendCountry(country) {
    _sendCountry = country;

    setExchangeRate();
    notifyListeners();

    return country;
  }

  CountryModel setReceiverCountry(CountryModel country) {
    _receiverCountry = country;
    _receiverCity = CityModel();
    if (country.cities.isNotEmpty) _receiverCity = country.cities.first;

    // if [usdAvailability] is mandatory which is equal 2.
    _sendUSD = _receiverCountry.usdAvailability == 2;

    setExchangeRate();
    notifyListeners();

    return country;
  }

  void setExchangeRate() {
    final rate = receiverCountry.currency.rate / sendCountry.currency.rate;

    if (_sendUSD) {
      _exchangeRate = _usdRate;
    } else {
      _exchangeRate = rate / receiverCountry.currency.profitRatio;
    }
  }

  void setReceiveType(ProviderModel provider) {
    _receiveType = provider.id;
    _receiveTypeTitle = ' ';
    Global.snackKey.currentState?.hideCurrentSnackBar();
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setUSD(bool usd) {
    _sendUSD = usd;

    setPrice(_sender.text, _receiverCountry);
  }

  void setPrice(String value, CountryModel country) {
    //
    // Calculate minimum recipient amount limit if USD
    if (country.coCode == _receiverCountry.coCode) {
      final CurrencyModel cu = country.currency;
      if (_sendUSD) {
        _minUSD = country.minAmount /
            (cu.rate / _usdRate / cu.profitRatio) /
            cu.profitRatio;
        _maxUSD = country.maxAmount /
            (cu.rate / _usdRate / cu.profitRatio) /
            cu.profitRatio;
      }
    }
    //

    if (value.isNotEmpty) {
      double convertedAmount = double.parse(value);
      convertedAmount = calculate(value, sender.text, receiver.text);
      double feesPercent = sender.text.isEmpty
          ? 0.00
          : (_percentFee / 100) * double.parse(sender.text);

      _minFee = _minFee > feesPercent ? _minFee : feesPercent;

      if (value == sender.text) {
        _receiver = TextEditingController(
          text: convertedAmount.toStringAsFixed(
            _receiverCountry.currency.code == 'SYP' ? 0 : 2,
          ),
        );
      } else {
        _sender =
            TextEditingController(text: convertedAmount.toStringAsFixed(2));
      }
    } else {
      clearFields();
    }

    setExchangeRate();
    notifyListeners();
  }

  double calculate(String controller, String sender, String receiver) {
    //percent: final rate
    //recipientCountry.rate: currency rate or USD rate
    //recipientCountry.ratio: profit
    double receiverRate = 0, receiverRatio = 0;
    if (_sendUSD) {
      receiverRate = _usdRate;
      receiverRatio = _usdRatio;
    } else {
      receiverRate = _receiverCountry.currency.rate;
      receiverRatio = _receiverCountry.currency.profitRatio;
    }

    // double profit = receiverRate / sendCountry.currency.rate / receiverRatio;
    double profit = receiverRate / 1 / receiverRatio;

    // ROUND UP DOUBLE two numbers only after comma
    double percent = double.parse(profit.toStringAsFixed(2));

    double converted = 0;

    converted = (controller == receiver)
        ? double.parse(controller) / percent
        : double.parse(controller) * percent;

    double amount = 0;
    amount = (controller == receiver) ? converted : double.parse(sender);

    double percentFee = amount * (_percentFee / 100);
    if (percentFee > AppMetadata.get.minimumSendFee) {
      _fees = percentFee;
    } else {
      _fees = AppMetadata.get.minimumSendFee;
    }

    _amountPlusFee = amount + _fees;

    setExchangeRate();

    return converted;
  }

  Future<bool> recipientSend(
    RecipientModel recipient, {
    bool navigate = false,
    TransferModel? transfer,
  }) async {
    _arb = AppLocalizations.of(context);
    bool allConditions = true;

    if (transfer != null) {
      setReceiveType(ProviderModel()); // reset setReceiveType.

      setReceiverCountry(transfer.recipient.country);
      if (transfer.recipient.country.usdAvailability == 2) {
        _sendUSD = true;
      } else {
        _sendUSD = transfer.isReceiveInUsd;
      }

      setReceiveType(transfer.provider);
      _sender.text = '${transfer.sendAmount}';
    }

    // Check if user wants to send from recipient/recipients page.
    if (sender.text.isEmpty) setReceiverCountry(recipient.country);

    if (Provider.of<RecipientsState>(
      context,
      listen: false,
    ).recipients.any((e) => e.id == recipient.id)) {
      if (receiveType == 2 && recipient.bankAccountNumber.isEmpty) {
        Helper.bannerWarning(
          _arb!
              .recipientBankInfoIsMissingPleaseEditRecipientByAddingBankAccountDetails,
          action: Button(
            () {
              Global.snackKey.currentState?.hideCurrentMaterialBanner();
              context.read<RecipientsState>().editRecipient(
                    context,
                    recipient,
                    bankFocus: true,
                    keepSendProcess: true,
                  );
            },
            TextX(_arb!.editRecipient),
          ),
        );
        return allConditions = false;
      }

      if (isRecipientArabicMandatoryNameEmpty(recipient)) {
        context.read<RecipientsState>().editRecipient(
              context,
              recipient,
              keepSendProcess: true,
            );
        Helper.bannerWarning(_arb!.enterRecipientArabicName);
        return allConditions = false;
      }

      if (isRecipientEnglishMandatoryNameEmpty(recipient)) {
        context.read<RecipientsState>().editRecipient(
              context,
              recipient,
              keepSendProcess: true,
            );
        Helper.bannerWarning(_arb!.enterRecipientEnglishName);
        return allConditions = false;
      }

      if (receiveCountries.any((e) => e.coCode == recipient.country.coCode)) {
        setPrice(sender.text, recipient.country);
        selectRecipient(recipient);
        if (receiver.text.isNotEmpty) {
          if (double.parse(receiver.text) < recipient.country.minAmount) {
            Helper.bannerWarning(
              '${_arb!.minimumReceivingLimitToThisCountryIs} ${recipient.country.minAmount} ${recipient.country.currency.code}',
            );
            return allConditions = false;
          }
        }
        if (navigate) {
          context.pushNamed(
            AppRoute.sendHub,
            pathParameters: <String, String>{'recipient': 'true'},
          );
        }
      } else {
        Helper.toast(_arb!.recipientCountryUnavailableAtTheMoment);
      }
    } else {
      Helper.bannerWarning(
        '\n${_arb!.cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer}\n',
      );
    }
    return allConditions;
  }
}
