import '/helper/safety_model.dart';

class CurrencyModel extends SafetyModel {
  CurrencyModel({
    this.code = '',
    this.name = '',
    this.ceil = 0,
    this.symbol = '',
  });

  String code = '';
  String name = '';
  double ceil = 0;
  String symbol = '';

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    code = stringFromJson(json, 'code');
    name = stringFromJson(json, 'name');
    ceil = doubleFromJson(json, 'ceil', decimal: 10);
    symbol = stringFromJson(json, 'symbol');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'ceil': ceil,
        'symbol': symbol,
      };
}
