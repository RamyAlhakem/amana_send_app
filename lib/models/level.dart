import '/helper/safety_model.dart';

class LevelModel extends SafetyModel {
  LevelModel({
    this.id = 0,
    this.iconUrl = '',
    this.status = 0,
    this.title = '',
    this.duration = 0,
    this.minAmount = 0,
    this.maxAmount = 0,
  });

  int id = 0;
  String iconUrl = '';
  String title = '';
  double duration = 0;
  int status = 0;
  double minAmount = 0;
  double maxAmount = 0;

  LevelModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    iconUrl = stringFromJson(json, 'iconUrl');
    title = stringFromJson(json, 'title');
    duration = doubleFromJson(json, 'duration');
    status = intFromJson(json, 'status');
    minAmount = doubleFromJson(json, 'minAmount');
    maxAmount = doubleFromJson(json, 'maxAmount');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'iconUrl': iconUrl,
        'title': title,
        'duration': duration,
        'status': status,
        'minAmount': minAmount,
        'maxAmount': maxAmount,
      };
}
