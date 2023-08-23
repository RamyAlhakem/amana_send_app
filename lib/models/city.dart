import '/helper/safety_model.dart';
import '/models/provider.dart';

class CityModel extends SafetyModel {
  CityModel({
    this.id = 0,
    this.name = '',
    this.areaNote = '',
    this.defaultMessage = '',
    this.providers = const <ProviderModel>[],
  });

  int id = 0;
  String name = '';
  String areaNote = '';
  String defaultMessage = '';
  List<ProviderModel> providers = const <ProviderModel>[];

  CityModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    areaNote = stringFromJson(json, 'areaNote');
    defaultMessage = stringFromJson(json, 'defaultMessage');
    providers =
        listFromJson(json, 'providers', (v) => ProviderModel.fromJson(v));
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'areaNote': areaNote,
        'defaultMessage': defaultMessage,
        'providers': providers,
      };
}
