import '/helper/safety_model.dart';

class CurrencyModel extends SafetyModel {
  CurrencyModel({
    this.code = '',
    this.name = '',
    this.ceil = 0,
    this.rate = 0,
    this.symbol = '',
  });

  String code = '';
  String name = '';
  double ceil = 0, rate = 0;
  String symbol = '';

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    code = stringFromJson(json, 'code');
    name = stringFromJson(json, 'name');
    ceil = doubleFromJson(json, 'ceil', decimal: 10);
    rate = doubleFromJson(json, 'rate');
    symbol = stringFromJson(json, 'symbol');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'ceil': ceil,
        'rate': rate,
        'symbol': symbol,
      };
}

class CalculateAmountModel extends SafetyModel {
  CalculateAmountModel({
    this.receiveFees = 0,
    this.recipientAmount = 0,
    this.sendAmount = 0,
    this.sendFees = 0,
    this.totalAmount = 0,
  });

  double receiveFees = 0;
  double recipientAmount = 0;
  double sendAmount = 0;
  double sendFees = 0;
  double  totalAmount =0;
  CalculateAmountModel.fromJson(Map<String, dynamic> json) {
    receiveFees = doubleFromJson(json, 'receiveFees');
    recipientAmount = doubleFromJson(json, 'recipientAmount');
    sendAmount = doubleFromJson(json, 'sendAmount');
    sendFees = doubleFromJson(json, 'sendFees');
    totalAmount = doubleFromJson(json, 'totalAmount');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'receiveFees': receiveFees,
        'recipientAmount': recipientAmount,
        'sendAmount': sendAmount,
        'sendFees': sendFees,
      };
}
