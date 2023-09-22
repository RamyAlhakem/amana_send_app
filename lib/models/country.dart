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
    this.minAmount = 0,
    this.maxAmount = 0,
    this.sendFees = 0,
    this.minimumSendsFees = 0,
    this.cities = const <CityModel>[],
  });

  int id = 0;
  String coCode = '', enName = '', arName = '', phoneCode = '0';
  double minAmount = 0, maxAmount = 0, sendFees = 0, minimumSendsFees = 0;
  CurrencyModel currency = CurrencyModel();
  List<CityModel> cities = const <CityModel>[];

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    coCode = stringFromJson(json, 'coCode');
    enName = stringFromJson(json, 'enName');
    arName = stringFromJson(json, 'arName');
    phoneCode = stringFromJson(json, 'phoneCode', defaultValue: '0');
    minAmount = doubleFromJson(json, 'minAmount');
    maxAmount = doubleFromJson(json, 'maxAmount');
    sendFees = doubleFromJson(json, 'sendsFees');
    minimumSendsFees = doubleFromJson(json, 'minimumSendsFees');
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
        'minAmount': minAmount,
        'maxAmount': maxAmount,
        'sendsFees': sendFees,
        'minimumSendsFees': minimumSendsFees,
        'currency': currency,
        'cities': cities,
      };
}
