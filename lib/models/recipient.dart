import '/helper/safety_model.dart';
import '/models/country.dart';

class RecipientModel extends SafetyModel {
  RecipientModel({
    this.id = 0,
    this.firstName = '',
    this.arFirstName = '',
    this.fatherName = '',
    this.arFatherName = '',
    this.lastName = '',
    this.arLastName = '',
    this.mobile = 0,
    this.status = 0,
    this.relative = '',
    this.cityId = 0,
    this.area = '',
    this.dateAdded = '',
  });

  int id = 0;
  String firstName = '', arFirstName = '', fatherName = '', arFatherName = '';
  String lastName = '', arLastName = '', relative = '', area = '';
  String dateAdded = '';
  int mobile = 0, cityId = 0, status = 0;
  CountryModel country = CountryModel();

  RecipientModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    firstName = stringFromJson(json, 'firstName');
    arFirstName = stringFromJson(json, 'arFirstName');
    fatherName = stringFromJson(json, 'fatherName');
    arFatherName = stringFromJson(json, 'arFatherName');
    lastName = stringFromJson(json, 'lastName');
    arLastName = stringFromJson(json, 'arLastName');
    mobile = intFromJson(json, 'mobile');
    status = intFromJson(json, 'status');
    relative = stringFromJson(json, 'relativeRelation');
    cityId = intFromJson(json, 'cityId');
    area = stringFromJson(json, 'area');
    dateAdded = stringFromJson(json, 'dateAdded');

    country = objectFromJson(json, 'country', (x) => CountryModel.fromJson(x),
        defaultValue: CountryModel());
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'arFirstName': arFirstName,
        'fatherName': fatherName,
        'arFatherName': arFatherName,
        'lastName': lastName,
        'arLastName': arLastName,
        'mobile': mobile,
        'status': status,
        'relativeRelation': relative,
        'cityId': cityId,
        'area': area,
        'dateAdded': dateAdded,
        'country': country,
      };
}
