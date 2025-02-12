import '/helper/safety_model.dart';
import 'agent.dart';

class CityModel extends SafetyModel {
  CityModel({
    this.id = 0,
    this.name = '',
    this.defaultMessage = '',
    this.agents = const <AgentModel>[],
  });

  int id = 0;
  String name = '';
  String defaultMessage = '';
  List<AgentModel> agents = const <AgentModel>[];

  CityModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    defaultMessage = stringFromJson(json, 'defaultMessage');
    agents = listFromJson(json, 'providers', (v) => AgentModel.fromJson(v));
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'defaultMessage': defaultMessage,
        'providers': agents,
      };
}
