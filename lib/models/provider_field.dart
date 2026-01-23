import '/helper/safety_model.dart';

class ProviderFieldModel extends SafetyModel {
  int id = 0;
  String name = '';
  String description = '';
  int characterCount = 0;
  int providerId = 0;
  int status = 0;

  ProviderFieldModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.characterCount = 0,
    this.providerId = 0,
    this.status = 0,
  });

  ProviderFieldModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    description = stringFromJson(json, 'description');
    characterCount = intFromJson(json, 'characterCount');
    providerId = intFromJson(json, 'providerId');
    status = intFromJson(json, 'status');
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
