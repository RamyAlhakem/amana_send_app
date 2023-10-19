import '/helper/safety_model.dart';

class AgentModel extends SafetyModel {
  AgentModel({
    this.id = 0,
    this.name = '',
    this.iconUrl = '',
    this.status = 0,
    this.rate = 0,
    this.receiveFees = 0,
    this.usdAvailability = 0,
    this.minAmount = 0,
    this.maxAmount = 0,
    this.defaultMessage = '',
    this.description = '',
    this.selected = false,
  });

  int id = 0, status = 0, usdAvailability = 0;
  String name = '', iconUrl = '', defaultMessage = '', description = '';
  double receiveFees = 0, rate = 0, minAmount = 0, maxAmount = 0;
  bool selected = false;

  AgentModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    iconUrl = stringFromJson(json, 'iconUrl');
    status = intFromJson(json, 'status');
    rate = doubleFromJson(json, 'rate', decimal: 10);
    receiveFees = doubleFromJson(json, 'receiveFees');
    usdAvailability = intFromJson(json, 'usdAvailability');
    minAmount = doubleFromJson(json, 'minAmount');
    maxAmount = doubleFromJson(json, 'maxAmount');
    defaultMessage = stringFromJson(json, 'defaultmessage');
    description = stringFromJson(json, 'description');
    selected = boolFromJson(json, 'x');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
        'status': status,
        'rate': rate,
        'receiveFees': receiveFees,
        'usdAvailability': usdAvailability,
        'minAmount': minAmount,
        'maxAmount': maxAmount,
        'defaultmessage': defaultMessage,
        'description': description,
        'x': selected,
      };
}
