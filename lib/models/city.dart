import '/helper/safety_model.dart';
import 'agent.dart';

class CityModel extends SafetyModel {
  CityModel({
    this.id = 0,
    this.name = '',
    this.defaultMessage = ''
  });

  int id = 0;
  String name = '';
  String defaultMessage = '';
  List<AgentModel> agents = const <AgentModel>[];

  CityModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    defaultMessage = stringFromJson(json, 'defaultMessage');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'defaultMessage': defaultMessage,
      };
}
