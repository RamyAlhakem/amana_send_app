import '/models/firebase.dart';

class UserBase {
  UserBase({
    this.lang,
    this.theme = 'system',
    this.isFreshUser,
    // this.firebase,
    this.transfersSent = 0,
  });

  String? lang;
  String theme = 'system';
  bool? isFreshUser;
  FirebaseModel firebase = FirebaseModel();
  int transfersSent = 0;

  UserBase.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    theme = json['theme'] ?? 'system';
    isFreshUser = json['isFreshUser'];
    firebase = FirebaseModel.fromJson(json['firebase']);
    transfersSent = int.tryParse('${json['transfersSent']}') ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'lang': lang,
        'theme': theme,
        'isFreshUser': isFreshUser,
        'firebase': firebase,
        'transfersSent': transfersSent,
      };
}
