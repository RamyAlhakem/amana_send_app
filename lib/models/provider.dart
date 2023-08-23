import '/helper/safety_model.dart';

class ProviderModel extends SafetyModel {
  ProviderModel({
    this.id = 0,
    this.name = '',
    this.iconUrl = '',
    this.status = 0,
    this.selected = false,
  });

  int id = 0, status = 0;
  String name = '', iconUrl = '';
  bool selected = false;

  ProviderModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    iconUrl = stringFromJson(json, 'iconUrl');
    status = intFromJson(json, 'status');
    selected = boolFromJson(json, 'x');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
        'status': status,
        'x': selected,
      };
}
