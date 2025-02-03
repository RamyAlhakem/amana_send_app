import '/helper/safety_model.dart';

class PaymentMethodModel extends SafetyModel {
  PaymentMethodModel({
    this.id = 0,
    this.name = '',
    this.className = '',
    this.displayName = '',
    this.displayDescription = '',
    this.iconUrl = '',
    this.status = 0,
    this.selected = false,
  });

  int id = 0 ,status = 0;
  String name = '', displayName = '', displayDescription = '',className='',iconUrl='';
  bool selected = false;

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    className = stringFromJson(json, 'className');
    iconUrl = stringFromJson(json, 'iconUrl');
    displayName = stringFromJson(json, 'displayName');
    displayDescription = stringFromJson(json, 'displayDescription');
    status = intFromJson(json, 'status');
    selected = boolFromJson(json, 'x');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'className': className,
        'displayName': displayName,
        'displayDescription': displayDescription,
        'status': status,
        'x': selected,
      };
}
