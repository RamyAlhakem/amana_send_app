import '/helper/safety_model.dart';
import 'currency.dart';
import 'state.dart';

class CountryModel extends SafetyModel {
  CountryModel({
    this.id = 0,
    this.coCode = '',
    this.phoneCode = '0',
    this.enName = '',
    this.arName = '',
    this.sendFees = 0,
    this.minimumSendsFees = 0,
    this.alpha3 = '',
    this.currencyId = 0,
    this.status = 0,
    this.type = '',
    this.states = const <StateModel>[],
  });

  int id = 0;
  String coCode = '', enName = '', arName = '', phoneCode = '0';
  String alpha3 = '', type = '';
  int currencyId = 0, status = 0;
  double sendFees = 0, minimumSendsFees = 0;
  CurrencyModel currency = CurrencyModel();
  List<StateModel> states = const <StateModel>[];

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    coCode = stringFromJson(json, 'coCode');
    enName = stringFromJson(json, 'enName');
    arName = stringFromJson(json, 'arName');
    phoneCode = stringFromJson(json, 'phoneCode', defaultValue: '0');
    alpha3 = stringFromJson(json, 'alpha3');
    type = stringFromJson(json, 'type');
    currencyId = intFromJson(json, 'currencyId');
    status = intFromJson(json, 'status');
    sendFees = doubleFromJson(json, 'sendsFees');
    minimumSendsFees = doubleFromJson(json, 'minimumSendsFees');
    currency = objectFromJson(
        json, 'currency', (v) => CurrencyModel.fromJson(v),
        defaultValue: CurrencyModel());
    states = listFromJson(json, 'states', (v) => StateModel.fromJson(v));
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'coCode': coCode,
        'enName': enName,
        'arName': arName,
        'phoneCode': phoneCode,
        'alpha3': alpha3,
        'type': type,
        'currencyId': currencyId,
        'status': status,
        'sendsFees': sendFees,
        'minimumSendsFees': minimumSendsFees,
        'currency': currency,
        'states': states,
      };
}
