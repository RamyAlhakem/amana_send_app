import '/helper/safety_model.dart';
import '/models/country.dart';

class RecipientModel extends SafetyModel {
  RecipientModel({
    this.id = 0,
    this.firstName = '',
    this.fatherName = '',
    this.lastName = '',
    this.mobile = 0,
    this.status = 0,
    this.cityId = 0,
    this.dateAdded = '',
    this.whatsappNumber = '',
  });

  int id = 0;
  String firstName = '', fatherName = '', lastName = '', dateAdded = '';
  String whatsappNumber = '';
  int mobile = 0, cityId = 0, status = 0;
  CountryModel country = CountryModel();

  RecipientModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    firstName = stringFromJson(json, 'firstName');
    fatherName = stringFromJson(json, 'fatherName');
    lastName = stringFromJson(json, 'lastName');
    mobile = intFromJson(json, 'mobile');
    status = intFromJson(json, 'status');
    cityId = intFromJson(json, 'cityId');
    dateAdded = stringFromJson(json, 'dateAdded');
    country = objectFromJson(json, 'country', (x) => CountryModel.fromJson(x),
        defaultValue: CountryModel());
    whatsappNumber = stringFromJson(json, 'whatsappNumber');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'fatherName': fatherName,
        'lastName': lastName,
        'mobile': mobile,
        'status': status,
        'cityId': cityId,
        'dateAdded': dateAdded,
        'country': country,
        'whatsappNumber': whatsappNumber,
      };
}
