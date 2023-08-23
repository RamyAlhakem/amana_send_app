import '/helper/safety_model.dart';

class WalletModel extends SafetyModel {
  WalletModel({this.id = 0, this.address = ''});

  int id = 0;
  String address = '';

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    address = stringFromJson(json, 'address');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'address': address};
}
