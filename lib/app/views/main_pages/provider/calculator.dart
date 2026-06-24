import 'dart:async';
import 'package:amana_send/graphql/api/calculate_transfer_money.dart';
import 'package:amana_send/graphql/api/get_provider_fields.dart';
import 'package:amana_send/graphql/api/get_providers.dart';
import 'package:amana_send/graphql/api/get_sliders.dart';
import 'package:amana_send/helper/debug_colors.dart';
import 'package:amana_send/models/slider_model.dart';
import 'package:amana_send/models/transfer_provider_field.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/agent.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/models/currency.dart';
import '/models/metadata.dart';
import '/models/payment_method.dart';
import '/models/provider_field.dart';
import '/models/recipient.dart';
import '/models/transfer.dart';
import '/models/user.dart';
import '/router/app_route.dart';

class Calculator with ChangeNotifier {
  bool _showInstall = true;
  bool get showInstall => _showInstall;
  changeInstall(bool value) {
    _showInstall = value;
    Database().setInstall = _showInstall;

    notifyListeners();
  }

  static late AppLocalizations? _arb;
  List<SlidersModel> sliders = [];
  List<AgentModel> providersNew = [];
  PageController pageController = PageController();
  int currentSlider = 0;
  Timer? timer;
  double _percentFee = 0;
  double _minFee = 0;
  double _usdRate = 0;
  double _usdRatio = 0;
  double _maxUSD = 0;
  double _minUSD = 0;
  bool _isLoading = true;
  bool senderLoading = false;
  bool recieverLoading = false;
  int _paymentMethodId = 1;
  String _paymentMethodName = "";
  String icon = "";
  RecipientModel? _selectedRecipient;
  List<AgentModel> _agents = <AgentModel>[];
  List<PaymentMethodModel> _payments = <PaymentMethodModel>[];
  List<CountryModel> _sendCountries = <CountryModel>[];
  List<CountryModel> _receiveCountries = <CountryModel>[];
  List<CurrencyModel> _currencies = <CurrencyModel>[];
  CountryModel _sendCountry = CountryModel();
  CountryModel _receiverCountry = CountryModel();
  CityModel _receiverCity = CityModel();
  AgentModel _receiverAgent = AgentModel();
  List<ProviderFieldModel> _providerFields = [];
  List<TransferProviderFieldModel> _providerFieldsTransfer = [];
  TextEditingController _sender = TextEditingController();
  TextEditingController _receiver = TextEditingController();
  CalculateAmountModel _calculateAmount = CalculateAmountModel();
  bool _sendUSD = false;
  bool _showAgents = false;
  double _exchangeRate = 0;
  bool isLoad = false;
  Color? borderColor;

  //____________________________________________________________________________

  double get percentFee => _percentFee;
  double get minFee => _minFee;
  double get usdRate => _usdRate;
  double get usdRatio => _usdRatio;
  double get maxUSD => _maxUSD;
  double get minUSD => _minUSD;
  bool get isLoading => _isLoading;
  int get paymentMethodID => _paymentMethodId;
  String get paymentMethodName => _paymentMethodName;
  CalculateAmountModel get calculateAmount => _calculateAmount;
  RecipientModel? get selectedRecipient => _selectedRecipient;
  List<PaymentMethodModel> get payments => _payments;
  List<AgentModel> get agents => _agents;
  List<CountryModel> get sendCountries => _sendCountries;
  List<CountryModel> get receiveCountries => _receiveCountries;
  List<CurrencyModel> get currencies => _currencies;
  CountryModel get sendCountry => _sendCountry;
  CountryModel get receiverCountry => _receiverCountry;
  CityModel get receiverCity => _receiverCity;
  AgentModel get receiverAgent => _receiverAgent;
  List<ProviderFieldModel> get providerFields => _providerFields;
  List<TransferProviderFieldModel> get providerFieldsTransfer =>
      _providerFieldsTransfer;
  TextEditingController get sender => _sender;
  TextEditingController get receiver => _receiver;
  bool get sendUSD => _sendUSD;
  bool get showAgents => _showAgents;
  double get exchangeRate => _exchangeRate;
  final Map<int, String> _providerFieldValues = {};
  Map<int, String> get providerFieldValues => _providerFieldValues;

  void setProviderFieldValue(int id, String value) {
    _providerFieldValues[id] = value;
  }

  void clearProviderFieldValues() {
    _providerFieldValues.clear();
  }

  void clearProviderFieldTransfer() {
    _providerFieldsTransfer.clear();
  }

  //** */
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  //** */

  void setPaymentMethodID(PaymentMethodModel getPaymentMethod) {
    if (getPaymentMethod.id != 0) {
      _paymentMethodId = getPaymentMethod.id;
      _paymentMethodName = getPaymentMethod.name;
      icon = getPaymentMethod.iconUrl;
      notifyListeners();
    }
  }

  void isRequestLoading(bool loading) {
    _isLoading = loading;
    if (!loading) notifyListeners();
  }

  void initializeData() {
    _percentFee = AppMetadata.get.sendsFees;
    _usdRate = AppMetadata.get.usdRate;
    _usdRatio = AppMetadata.get.usdRatio;
  }

  //**Select a recipient.
  void selectRecipient(RecipientModel recipient) {
    _selectedRecipient = recipient;
    notifyListeners();
  }

  //**DISPOSE send process.
  void clearRecipient() {
    _selectedRecipient = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  //**Get sender countries for registration purpose & setting exchange rates.
  void getSendCountries(List<CountryModel> countries) {
    initializeData();
    final UserModel user = Database().getUser;
    _sendCountries = countries;
    if (countries.isNotEmpty) {
      Global.appSettings.token.isEmpty
          ? setSendCountry(countries.first)
          : setSendCountry(user.country);
    }

    setExchangeRate();
    getCurrencies();
  }

  void setCalculateAmount(CalculateAmountModel amount) {
    _calculateAmount = amount;
    Helper.log("calculate amount $_calculateAmount");
    notifyListeners();
  }

  //**Get receiver countries to add a recipient & setting exchange rates.
  void getReceiveCountries(List<CountryModel> countries) {
    _receiveCountries = countries;
    if (countries.isNotEmpty) setReceiverCountry(countries.first);

    notifyListeners();
  }

  void getCurrencies() {
    final List<CurrencyModel> elements = <CurrencyModel>[];
    List.generate(sendCountries.length, (i) {
      elements.add(sendCountries[i].currency);
    });

    _currencies = elements;
    notifyListeners();
  }

  //**Get receiver city.
  void setReceiveCity(CityModel city) {
    Helper.log("city id ========>>>>>>>${city.id}");
    _receiverCity = city;
    GetProviders(
            cityID: _receiverCity.id,
            paymentMethodID: paymentMethodID,
            sendCountryCode: sendCountry.coCode)
        .request();
    // isLoad=false;
    notifyListeners();
  }

  void clearFields() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sender.clear();
      _receiver.clear();
      senderLoading = false;
      recieverLoading = false;
      borderColor = null;
      notifyListeners();
    });
  }

  void getPayments(List<PaymentMethodModel> elements) {
    _payments = elements;
    notifyListeners();
  }

  void getAgents(List<AgentModel> providers) {
    Helper.log("providers ===> $providers");

    _agents = providers;
    setAgent(providers.first);
    notifyListeners();
  }

  void setProviderFields(List<ProviderFieldModel> fields) {
    _providerFields = fields;
    notifyListeners();
  }

  CountryModel setSendCountry(country) {
    _sendCountry = country;
    _minFee = country.minimumSendsFees;

    setExchangeRate();
    Helper.log('minFee: $minFee');
    return country;
  }

  CountryModel setReceiverCountry(CountryModel country) {
    Helper.log("city id ========>>>>>>>${_receiverCity.id}");
    Helper.log("paymentMethodID ========>>>>>>>$paymentMethodID");
    Helper.log("sendCountryCode: ========>>>>>>>${sendCountry.coCode}");

    _receiverCountry = country;
    _receiverCity = CityModel();
    _receiverAgent = AgentModel();
    // if (country.cities.isNotEmpty) {
    //   _receiverCity = country.cities.first;
    // }

    // GetProviders(
    //         cityID: _receiverCity.id,
    //         paymentMethodID: paymentMethodID,
    //         sendCountryCode: sendCountry.coCode)
    //     .request();

    Helper.log(
        "myyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy   ${_receiverCity.id}    $paymentMethodID    ${sendCountry.coCode}");
    setExchangeRate();
    return country;
  }

  void setExchangeRate() {
    final rate = receiverAgent.rate / 1;
    sendUSD ? _exchangeRate = usdRate : _exchangeRate = rate;
    _percentFee = sendCountry.sendFees;
    notifyListeners();
  }

  void setAgent(AgentModel agent) {
    clearProviderFieldValues();
    _receiverAgent = agent;
    getFielsProvider();
    Global.snackKey.currentState?.hideCurrentSnackBar();
    setPrice(sender.text);
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setPrice(String value, {bool? usd}) {
    if (usd == null) {
      // if [usdAvailability] is mandatory which is equal 2.
      _sendUSD = receiverAgent.usdAvailability == 2;
    } else {
      _sendUSD = usd;
    }
    if (sendUSD) {
      _minUSD = receiverAgent.minAmount / receiverAgent.rate;
      _maxUSD = receiverAgent.maxAmount / receiverAgent.rate;
    }

    if (value.isNotEmpty) {
      bool isSender = value ==
          sender
              .text; // true: how nuch you will send , false :how much you will recieve

      calculate(value, isSender);
    } else {
      senderLoading = false;
      recieverLoading = false;
      // clearFields();
      setCalculateAmount(CalculateAmountModel());
    }

    notifyListeners();
  }

  void calculate(String controller, bool isSender) async {
    final double amount = double.tryParse(controller) ?? 0;
    String sendCountryCode = "";
    Helper.log("provider id =====>>> ${receiverAgent.id}");
    if (Global.appSettings.token.isEmpty) {
      sendCountryCode = sendCountry.coCode;
    } else {
      sendCountryCode = Database().getUser.country.coCode;
    }

    await CalculateTransferMoney(Global.key.currentContext!,
            coCode: receiverCountry.coCode,
            sendCountryCode: sendCountryCode,
            providerId: receiverAgent.id,
            isReceiveInUSD: receiverAgent.usdAvailability == 2,
            sendAmount: isSender ? amount : null,
            recipientAmount: isSender ? null : amount,
            paymentMethodId: paymentMethodID)
        .request()
        .then((result) {
      if (result) {
        if (isSender) {
          _receiver = TextEditingController(
            text: _calculateAmount.recipientAmount.toStringAsFixed(
              _receiverCountry.currency.code == 'SYP' ? 0 : 2,
            ),
          );
          Helper.log("amount=====> sender $_calculateAmount ");
        } else {
          _sender = TextEditingController(
              text: _calculateAmount.sendAmount.toStringAsFixed(2));
          Helper.log("amount=====> receiver $_calculateAmount ");
        }
      } else {
        if (isSender) {
          _receiver = TextEditingController(
            text: _calculateAmount.recipientAmount.toStringAsFixed(
              _receiverCountry.currency.code == 'SYP' ? 0 : 2,
            ),
          );
        } else {
          _sender = TextEditingController(
              text: _calculateAmount.sendAmount.toStringAsFixed(2));
        }
        // _sender.text = "";
        // _receiver.text = "";
        // setCalculateAmount(CalculateAmountModel());
      }
    });
    recieverLoading = senderLoading = false;
    notifyListeners();
  }

  void agentsVisibility(bool show) {
    _showAgents = show;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  bool checkRecipientAvailability(
    RecipientModel recipient, {
    bool isResend = false,
  }) {
    bool check = true;

    // Check if selected recipient country is available:
    final recipients =
        Provider.of<RecipientsState>(Global.key.currentContext!, listen: false);

    // When re-sending from a transfer, the recipient data is embedded in the
    // transfer object and comes directly from the server. Bypass the local
    // recipients list check to avoid a false-positive "modified or deleted"
    // error caused by the list not being loaded yet (pagination race condition)
    // or the recipient not being present in the current paginated view.
    final bool recipientExists =
        isResend || recipients.all.any((e) => e.id == recipient.id);

    if (recipientExists) {
      // Check if selected recipient country is still available:
      if (receiveCountries.any((e) => e.coCode == recipient.country.coCode)) {
        selectRecipient(recipient);
        if (receiver.text.isNotEmpty) {
          if (double.parse(receiver.text) < receiverAgent.minAmount) {
            Helper.bannerWarning(
              '${_arb!.minimumReceivingLimitToThisPickUpPointIs} ${receiverAgent.minAmount} ${sendUSD ? 'USD' : recipient.country.currency.code}',
            );
            return check = false;
          }
        }
      } else {
        Helper.toast(_arb!.recipientCountryUnavailableAtTheMoment);
        return check = false;
      }
    } else {
      Helper.bannerWarning(
        '\n${_arb!.cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer}\n',
      );
      return check = false;
    }
    return check;
  }

  Future<bool> recipientSend(
    RecipientModel recipient, {
    bool navigate = false,
    TransferModel? transfer,
  }) async {
    _arb = AppLocalizations.of(Global.key.currentContext!);
    bool canSend = true;

    final bool isResend = transfer != null;
    canSend = checkRecipientAvailability(recipient, isResend: isResend);

    if (transfer != null) {
      isLoad = true;
      notifyListeners();
      _sender.text = '${transfer.sendAmount}';
      _receiver.text = '${transfer.recipientAmount}';
      _providerFieldsTransfer = transfer.providerFields;
      Helper.log("provider fields transfer $_providerFieldsTransfer",
          color: DebugColor.yellow);
      // setAgent(transfer.provider);
      setReceiverCountry(transfer.recipient.country);
      if (transfer.provider.usdAvailability == 2) {
        _sendUSD = true;
      } else {
        _sendUSD = transfer.isReceiveInUsd;
      }

      // setAgent(transfer.provider);
      _sender.text = '${transfer.sendAmount}';
      Future.delayed(const Duration(seconds: 2), () {
        Helper.log("city           =========>>>>>>>>>> ${transfer.city}");

        setReceiveCity(transfer.city);

        notifyListeners();
      });
      Future.delayed(const Duration(seconds: 3), () {
        setAgent(transfer.provider);

        notifyListeners();
      });
      Future.delayed(const Duration(seconds: 4), () {
        isLoad = false;
        notifyListeners();
      });
    } else if (receiverCountry.id == 0) {
      setReceiverCountry(recipient.country);
    }
    // Check if user wants to send from recipient/recipients page.
    // if (showAgents) setReceiverCountry(recipient.country);
    if (canSend && navigate) {
      Global.key.currentContext!.pushNamed(
        AppRoute.sendHub,
        pathParameters: <String, String>{'recipient': 'true'},
      );
    }

    return canSend;
  }

  updateUi() {
    notifyListeners();
  }

  getSliders(int type) async {
    sliders = await GetSliders.request(type) ?? [];
    notifyListeners();
  }

  moveSlider() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        if (currentSlider + 1 < sliders.length) {
          currentSlider++;
          pageController.animateToPage(currentSlider,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut);
          Helper.log("current sliders $currentSlider");
        } else {
          currentSlider = 0;
          pageController.jumpTo(50);
          Helper.log("current sliders  = 0 $currentSlider");
        }
      }
    });
// notifyListeners();
  }

  set calculateAmount(CalculateAmountModel value) {
    _calculateAmount = value;
    notifyListeners();
  }

  setShowAgent(bool value) {
    _showAgents = value;
    notifyListeners();
  }

  setIsLoad(bool val) {
    isLoad = val;
    notifyListeners();
  }

  clearAgents() {
    _agents = [];
    notifyListeners();
  }

  setBorderColor(Color? color) {
    borderColor = color;
    notifyListeners();
  }

  getFielsProvider() async {
    await GetProviderFields(providerId: _receiverAgent.id).request();
    notifyListeners();
  }
  // filterByCities(String text){
  //     Helper.log("search for city with text $text");
  //   if (text.isEmpty) {
  //     foundCities = states[i].cities;
  //     Helper.log("cites length ${foundCities.length}");
  //   } else {
  //     foundCities = states[i]
  //         .cities
  //         .where((city) => city.name.toLowerCase().contains(text.toLowerCase()))
  //         .toList();
  //     Helper.log("cites length ${foundCities.length}");
  //   }
  // }
}
