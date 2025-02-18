import '/helper/safety_model.dart';

class PaymentMethodModel extends SafetyModel {
  PaymentMethodModel({
    this.id = 0,
    this.name = '',
    this.iconUrl = '',
  });

  int id = 0;
  String name = '', iconUrl = '';

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    iconUrl = stringFromJson(json, 'iconUrl');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'iconUrl': iconUrl};
}
