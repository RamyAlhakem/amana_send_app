import '/helper/safety_model.dart';

class PaymentMethodModel extends SafetyModel {
  PaymentMethodModel({
    this.id = 0,
    this.isManual = 0,
    this.name = '',
    this.displayName = '',
    this.displayDescription = '',
    this.status = 0,
    this.selected = false,
  });

  int id = 0, isManual = 0, status = 0;
  String name = '', displayName = '', displayDescription = '';
  bool selected = false;

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    isManual = intFromJson(json, 'isManual'); // 0 = online, 1 = cash.
    name = stringFromJson(json, 'name');
    displayName = stringFromJson(json, 'displayName');
    displayDescription = stringFromJson(json, 'displayDescription');
    status = intFromJson(json, 'status');
    selected = boolFromJson(json, 'x');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'isManual': isManual,
        'name': name,
        'displayName': displayName,
        'displayDescription': displayDescription,
        'status': status,
        'x': selected,
      };
}
