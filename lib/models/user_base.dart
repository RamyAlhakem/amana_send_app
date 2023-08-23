import '/models/firebase.dart';

class UserBase {
  UserBase({
    this.lang,
    this.theme = 'system',
    this.isFreshUser,
    this.acceptTerms = false,
    // this.firebase,
  });

  String? lang;
  String theme = 'system';
  bool? isFreshUser;
  FirebaseModel firebase = FirebaseModel();
  bool acceptTerms = false;

  UserBase.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    theme = json['theme'] ?? 'system';
    isFreshUser = json['isFreshUser'];
    firebase = FirebaseModel.fromJson(json['firebase']);
    acceptTerms = json['acceptTerms'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'lang': lang,
        'theme': theme,
        'isFreshUser': isFreshUser,
        'firebase': firebase,
        'acceptTerms': acceptTerms,
      };
}
