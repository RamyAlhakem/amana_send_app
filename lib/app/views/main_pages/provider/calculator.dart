import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/agent.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/models/metadata.dart';
import '/models/payment_method.dart';
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

  List<AgentModel> _agents = <AgentModel>[];
  List<PaymentMethodModel> _payments = <PaymentMethodModel>[];

  List<CountryModel> _sendCountries = <CountryModel>[];
  List<CountryModel> _receiveCountries = <CountryModel>[];

  CountryModel _sendCountry = CountryModel();
  CountryModel _receiverCountry = CountryModel();
  CityModel _receiverCity = CityModel();
  AgentModel _receiverAgent = AgentModel();

  TextEditingController _sender = TextEditingController();
  TextEditingController _receiver = TextEditingController();

  bool _sendUSD = false;

  double _fees = 0;

  double _amountPlusFee = 0;
  double _exchangeRate = 0;

  //____________________________________________________________________________

  double get percentFee => _percentFee;
  double get minFee => _minFee;
  double get usdRate => _usdRate;
  double get usdRatio => _usdRatio;
  double get maxUSD => _maxUSD;
  double get minUSD => _minUSD;

  bool get isLoading => _isLoading;

  int get onlinePaymentMethodId => _onlinePaymentMethodId;
  int get cashPaymentMethodId => _cashPaymentMethodId;

  RecipientModel? get selectedRecipient => _selectedRecipient;

  List<PaymentMethodModel> get payments => _payments;
  List<AgentModel> get agents => _agents;

  List<CountryModel> get sendCountries => _sendCountries;
  List<CountryModel> get receiveCountries => _receiveCountries;

  CountryModel get sendCountry => _sendCountry;
  CountryModel get receiverCountry => _receiverCountry;
  CityModel get receiverCity => _receiverCity;
  AgentModel get receiverAgent => _receiverAgent;

  TextEditingController get sender => _sender;
  TextEditingController get receiver => _receiver;

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
    if (countries.isNotEmpty) setReceiverCountry(countries.first);

    initializeData();
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

  void getAgents(List<AgentModel> elements) {
    _agents = elements;

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
    _receiverAgent = AgentModel();
    if (country.cities.isNotEmpty) {
      _receiverCity = country.cities.first;
      if (country.cities.first.agents.isNotEmpty) {
        setAgent(country.cities.first.agents.first);
      }
    }

    // if [usdAvailability] is mandatory which is equal 2.
    _sendUSD = receiverAgent.usdAvailability == 2;

    setExchangeRate();
    notifyListeners();

    return country;
  }

  void setExchangeRate() {
    final rate = receiverAgent.rate / 1;
    sendUSD ? _exchangeRate = usdRate : _exchangeRate = rate;
    notifyListeners();
  }

  void setAgent(AgentModel agent) {
    _receiverAgent = agent;
    Global.snackKey.currentState?.hideCurrentSnackBar();
    setPrice(sender.text);
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setUSD(bool usd) {
    _sendUSD = usd;
    setPrice(sender.text);
  }

  void roundReceiverAmount() {
    double ceil = receiverCountry.currency.ceil;
    double round = double.tryParse(receiver.text) ?? 0;

    if (!sendUSD) {
      round = ceil > 0 ? (round / ceil).ceilToDouble() * ceil : round;
    } else {
      round = round.ceilToDouble();
    }

    Helper.log('round: $round');
    if (receiver.text.isNotEmpty) {
      _receiver.text = '$round';
      _receiver.text =
          Helper.priced(double.parse(_receiver.text), currency: false);
    }
    notifyListeners();
  }

  void setPrice(String value) {
    if (_sendUSD) {
      _minUSD = receiverCountry.minAmount / receiverAgent.rate;
      _maxUSD = receiverCountry.maxAmount / receiverAgent.rate;
    }

    if (value.isNotEmpty) {
      double convertedAmount = double.parse(value);
      convertedAmount = calculate(value, sender.text, receiver.text);

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

    notifyListeners();
  }

  double calculate(String controller, String sender, String receiver) {
    double receiverRate = 0;
    final double receiverRatio = receiverAgent.receiveFees;

    if (sendUSD) {
      receiverRate = usdRate;
    } else {
      receiverRate = receiverAgent.rate;
    }

    double amount = double.tryParse(controller) ?? 0;
    double converted = 0;

    if (controller == sender) {
      double userCountryFees = (percentFee * amount) / 100;
      double sendFees = userCountryFees > minFee ? userCountryFees : minFee;

      _fees = sendFees;
      double amountWithoutCountryFees = amount - sendFees;
      converted = sendUSD
          ? amountWithoutCountryFees
          : amountWithoutCountryFees * receiverRate;

      double ceil = receiverCountry.currency.ceil;
      _amountPlusFee = amount + receiverRatio;

      if (!sendUSD) {
        converted =
            ceil > 0 ? (converted / ceil).ceilToDouble() * ceil : converted;
      } else {
        converted = converted.ceilToDouble();
      }
    } else {
      double newAmountInUsd = sendUSD ? amount : amount / receiverAgent.rate;
      double newAmount =
          sendUSD ? newAmountInUsd : newAmountInUsd / (1 - (percentFee / 100));
      double newFees =
          sendUSD ? (percentFee * newAmount) / 100 : newAmount - newAmountInUsd;
      double sendFees = newFees > minFee ? newFees : minFee;

      _fees = sendFees;
      converted = newAmount;
      _amountPlusFee = newAmount + receiverRatio;
    }

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
      _sender.text = '${transfer.sendAmount}';
      _receiver.text = '${transfer.recipientAmount}';
      setReceiverCountry(transfer.recipient.country);
      if (transfer.provider.usdAvailability == 2) {
        _sendUSD = true;
      } else {
        _sendUSD = transfer.isReceiveInUsd;
      }

      setAgent(transfer.provider);
    }

    if (Provider.of<RecipientsState>(
      context,
      listen: false,
    ).recipients.any((e) => e.id == recipient.id)) {
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
        Helper.log(sender.text);
        Helper.log(receiver.text);
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
