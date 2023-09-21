import '/helper/safety_model.dart';
import '/models/city.dart';
import 'country.dart';
import 'level.dart';

class UserModel extends SafetyModel {
  UserModel({
    this.id = 0,
    this.token = '',
    this.firstName = '',
    this.lastName = '',
    this.arFirstName = '',
    this.arFatherName = '',
    this.arLastName = '',
    this.mobile = '',
    this.email = '',
    this.verified = -1,
    this.fullAddress = '',
    this.postCode = '',
    this.birthday = '1997-01-01',
    this.mainIdPic = '',
    this.selfiePic = '',
    this.userNote = '',
    this.remainingSendLimit = 10,
  });

  int id = 0;
  String token = '';
  String firstName = '';
  String lastName = '';
  String arFirstName = '';
  String arFatherName = '';
  String arLastName = '';
  String fullAddress = '';
  String mobile = '';
  String email = '';
  int verified = -1;
  String postCode = '';
  String mainIdPic = '';
  String selfiePic = '';
  String birthday = '1997-01-01';
  CityModel city = CityModel();
  CountryModel country = CountryModel();
  String userNote = '';
  double remainingSendLimit = 10;
  LevelModel level = LevelModel();

  static UserModel get = UserModel();
  UserModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    token = stringFromJson(json, 'session');
    firstName = stringFromJson(json, 'firstName');
    lastName = stringFromJson(json, 'lastName');
    arFirstName = stringFromJson(json, 'arFirstName');
    arFatherName = stringFromJson(json, 'arFatherName');
    arLastName = stringFromJson(json, 'arLastName');
    mobile = stringFromJson(json, 'mobile');
    email = stringFromJson(json, 'email');
    verified = intFromJson(json, 'verified', defaultValue: -1);
    fullAddress = stringFromJson(json, 'fullAddress');
    city = objectFromJson(json, 'city', (v) => CityModel.fromJson(v),
        defaultValue: CityModel());
    postCode = stringFromJson(json, 'postCode');
    birthday = dateFromJson(json, 'birthday', defaultValue: '1997-01-01');
    mainIdPic = stringFromJson(json, 'mainIdPic');
    selfiePic = stringFromJson(json, 'selfiePic');
    country = objectFromJson(json, 'country', (v) => CountryModel.fromJson(v),
        defaultValue: CountryModel());
    remainingSendLimit = doubleFromJson(json, 'allowedSendAmount');
    level = objectFromJson(json, 'level', (v) => LevelModel.fromJson(v),
        defaultValue: LevelModel());
    userNote = stringFromJson(json, 'userNote');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'session': token,
        'firstName': firstName,
        'lastName': lastName,
        'arFirstName': arFirstName,
        'arFatherName': arFatherName,
        'arLastName': arLastName,
        'mobile': mobile,
        'email': email,
        'verified': verified,
        'fullAddress': fullAddress,
        'city': city.toJson(),
        'postCode': postCode,
        'birthday': birthday,
        'mainIdPic': mainIdPic,
        'selfiePic': selfiePic,
        'country': country.toJson(),
        'allowedSendAmount': remainingSendLimit,
        'level': level.toJson(),
        'userNote': userNote,
      };
}
