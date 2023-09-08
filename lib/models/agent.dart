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
    this.selected = false,
  });

  int id = 0, status = 0, usdAvailability = 0;
  String name = '', iconUrl = '';
  double receiveFees = 0, rate = 0;
  bool selected = false;

  AgentModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    iconUrl = stringFromJson(json, 'iconUrl');
    status = intFromJson(json, 'status');
    rate = doubleFromJson(json, 'rate');
    receiveFees = doubleFromJson(json, 'receiveFees');
    usdAvailability = intFromJson(json, 'usdAvailability');
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
        'x': selected,
      };
}
