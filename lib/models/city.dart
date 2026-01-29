import '/helper/safety_model.dart';
import 'agent.dart';

class CityModel extends SafetyModel {
  CityModel({
    this.id = 0,
    this.name = '',
    this.defaultMessage = '',
    this.areaNote = '',
    this.coCode = '',
    this.status = 0,
  });

  int id = 0;
  String name = '';
  String defaultMessage = '';
  String areaNote = '';
  String coCode = '';
  int status = 0;
  List<AgentModel> agents = const <AgentModel>[];

  CityModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    defaultMessage = stringFromJson(json, 'defaultMessage');
    areaNote = stringFromJson(json, 'areaNote');
    coCode = stringFromJson(json, 'coCode');
    status = intFromJson(json, 'status');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'defaultMessage': defaultMessage,
        'areaNote': areaNote,
        'coCode': coCode,
        'status': status,
      };
}
