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
    this.minAmount = 0.0,
    this.maxAmount = 0.0,
    this.cities = const <CityModel>[],
  });

  int id = 0;
  String coCode = '', enName = '', arName = '', phoneCode = '0';
  bool recipientArabicMandatory = false, recipientEnglishMandatory = false;
  double minAmount = 0, maxAmount = 0;
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
        'minAmount': minAmount,
        'maxAmount': maxAmount,
        'currency': currency,
        'cities': cities,
      };
}
