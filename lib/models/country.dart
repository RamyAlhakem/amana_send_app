import '/helper/safety_model.dart';
import 'currency.dart';
import 'city.dart';

class CountryModel extends SafetyModel {
  CountryModel({
    this.id = 0,
    this.coCode = '',
    this.phoneCode = '0',
    this.enName = '',
    this.arName = '',
    this.recipientArabicMandatory = false,
    this.recipientEnglishMandatory = false,
    this.receiveCash = false,
    this.receiveMobileWallet = false,
    this.receiveBank = false,
    this.usdAvailability = 0,
    this.minAmount = 0.0,
    this.maxAmount = 0.0,
    this.cities = const <CityModel>[],
  });

  int id = 0;
  String coCode = '';
  String enName = '';
  String arName = '';
  String phoneCode = '0';
  bool recipientArabicMandatory = false;
  bool recipientEnglishMandatory = false;
  bool receiveBank = false;
  bool receiveCash = false;
  bool receiveMobileWallet = false;
  int usdAvailability = 0;
  double minAmount = 0;
  double maxAmount = 0;
  CurrencyModel currency = CurrencyModel();
  List<CityModel> cities = const <CityModel>[];

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    coCode = stringFromJson(json, 'coCode');
    enName = stringFromJson(json, 'enName');
    arName = stringFromJson(json, 'arName');
    phoneCode = stringFromJson(json, 'phoneCode', defaultValue: '0');
    recipientArabicMandatory = boolFromJson(json, 'recipientArabicMandatory');
    recipientEnglishMandatory = boolFromJson(json, 'recipientEnglishMandatory');
    receiveCash = boolFromJson(json, 'receiveCash');
    receiveMobileWallet = boolFromJson(json, 'receiveMobileWallet');
    receiveBank = boolFromJson(json, 'receiveBank');
    usdAvailability = intFromJson(json, 'usdAvailability');
    minAmount = doubleFromJson(json, 'minAmount');
    maxAmount = doubleFromJson(json, 'maxAmount');
    currency = objectFromJson(
        json, 'currency', (v) => CurrencyModel.fromJson(v),
        defaultValue: CurrencyModel());
    cities = listFromJson(json, 'cities', (v) => CityModel.fromJson(v));
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'coCode': coCode,
        'enName': enName,
        'arName': arName,
        'phoneCode': phoneCode,
        'recipientArabicMandatory': recipientArabicMandatory,
        'recipientEnglishMandatory': recipientEnglishMandatory,
        'receiveCash': receiveCash,
        'receiveMobileWallet': receiveMobileWallet,
        'receiveBank': receiveBank,
        'usdAvailability': usdAvailability,
        'minAmount': minAmount,
        'maxAmount': maxAmount,
        'currency': currency,
        'cities': cities,
      };
}
