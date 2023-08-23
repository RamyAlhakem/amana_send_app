class FirebaseModel {
  FirebaseModel({this.token = '', this.topics = const <String>[]});

  String token = '';
  List<String> topics = <String>[];

  FirebaseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    topics = List<String>.from(json['topics'].map((x) => x));
  }

  Map<String, dynamic> toJson() => {'token': token, 'topics': topics};
}
