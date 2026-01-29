import '/helper/safety_model.dart';
import 'city.dart';

class StateModel extends SafetyModel {
  StateModel({
    this.id = 0,
    this.name = '',
    this.coCode = '',
    this.status = 0,
    this.cities = const <CityModel>[],
  });

  int id = 0;
  String name = '';
  String coCode = '';
  int status = 0;
  List<CityModel> cities = const <CityModel>[];

  StateModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    coCode = stringFromJson(json, 'coCode');
    status = intFromJson(json, 'status');
    cities = listFromJson(json, 'cities', (v) => CityModel.fromJson(v));
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'coCode': coCode,
        'status': status,
        'cities': cities.map((v) => v.toJson()).toList(),
      };
}
