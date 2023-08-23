import '/helper/safety_model.dart';

class CurrencyModel extends SafetyModel {
  CurrencyModel({
    this.code = '',
    this.name = '',
    this.profitRatio = 0,
    this.rate = 0,
    this.symbol = '',
  });

  String code = '';
  String name = '';
  double profitRatio = 0;
  double rate = 0;
  String symbol = '';

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    code = stringFromJson(json, 'code');
    name = stringFromJson(json, 'name');
    profitRatio = doubleFromJson(json, 'profitRatio', decimal: 10);
    rate = doubleFromJson(json, 'rate', decimal: 10);
    symbol = stringFromJson(json, 'symbol');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'profitRatio': profitRatio,
        'rate': rate,
        'symbol': symbol,
      };
}
