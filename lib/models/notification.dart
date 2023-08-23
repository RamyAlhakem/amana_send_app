import '/helper/safety_model.dart';

class NotificationModel extends SafetyModel {
  NotificationModel({
    this.id = 0,
    this.addedAt = '',
    this.status = 0,
    this.title = '',
    this.message = '',
    this.transactionId = 0,
    this.transactionStatus = 0,
  });

  int id = 0;
  String addedAt = '';
  int status = 0;
  String title = '';
  String message = '';
  int transactionId = 0;
  int transactionStatus = 0;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    addedAt = stringFromJson(json, 'addedAt');
    status = intFromJson(json, 'status');
    title = stringFromJson(json, 'title');
    message = stringFromJson(json, 'message');
    transactionId = intFromJson(json, 'transactionId');
    transactionStatus = intFromJson(json, 'transactionStatus');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'addedAt': addedAt,
        'status': status,
        'title': title,
        'message': message,
        'transactionId': transactionId,
        'transactionStatus': transactionStatus,
      };
}
