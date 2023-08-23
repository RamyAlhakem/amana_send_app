import '/helper/safety_model.dart';
import 'country.dart';
import 'level.dart';

class UserModel extends SafetyModel {
  UserModel({
    this.id = 0,
    this.token = '',
    this.firstName = '',
    this.lastName = '',
    this.mobile = '',
    this.email = '',
    this.verified = -1,
    this.fullName = '',
    this.city = '',
    this.postCode = '',
    this.street = '',
    this.building = '',
    this.addressPic = '',
    this.birthday = '1997-01-01',
    this.mainIdPic = '',
    this.idNumber = '',
    this.idIssuedDate = '2022-01-01',
    this.idExpireDate = '2026-01-01',
    this.selfiePic = '',
    this.doc1 = '',
    this.doc2 = '',
    this.doc3 = '',
    this.doc4 = '',
    this.userNote = '',
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.remainingSendLimit = 10,
  });

  int id = 0;
  String token = '';
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String email = '';
  int verified = -1;
  String fullName = '';
  String city = '';
  String postCode = '';
  String street = '';
  String building = '';
  String flat = '';
  String addressPic = '';
  String mainIdPic = '';
  String selfiePic = '';
  String birthday = '1997-01-01';
  String idNumber = '';
  String idIssuedDate = '2022-01-01';
  String idExpireDate = '2026-01-01';
  String doc1 = '';
  String doc2 = '';
  String doc3 = '';
  String doc4 = '';
  CountryModel country = CountryModel();
  String userNote = '';
  double remainingSendLimit = 10;
  LevelModel level = LevelModel();

  // **CREDIT CARD DETAILS** locally saved

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  //

  static UserModel get = UserModel();
  UserModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    token = stringFromJson(json, 'session');
    firstName = stringFromJson(json, 'firstName');
    lastName = stringFromJson(json, 'lastName');
    mobile = stringFromJson(json, 'mobile');
    email = stringFromJson(json, 'email');
    verified = intFromJson(json, 'verified', defaultValue: -1);
    fullName = stringFromJson(json, 'fullName');
    city = stringFromJson(json, 'city');
    postCode = stringFromJson(json, 'postCode');
    street = stringFromJson(json, 'street');
    flat = stringFromJson(json, 'flat');
    building = stringFromJson(json, 'building');
    addressPic = stringFromJson(json, 'addressPic');
    birthday = dateFromJson(json, 'birthday', defaultValue: '1997-01-01');
    mainIdPic = stringFromJson(json, 'mainIdPic');
    idNumber = stringFromJson(json, 'idNumber');
    idIssuedDate =
        dateFromJson(json, 'idIssuedDate', defaultValue: '2022-01-01');
    idExpireDate =
        dateFromJson(json, 'idExpireDate', defaultValue: '2026-01-01');
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
        'mobile': mobile,
        'email': email,
        'verified': verified,
        'fullName': fullName,
        'city': city,
        'postCode': postCode,
        'street': street,
        'building': building,
        'flat': flat,
        'addressPic': addressPic,
        'birthday': birthday,
        'mainIdPic': mainIdPic,
        'idNumber': idNumber,
        'idIssuedDate': idIssuedDate,
        'idExpireDate': idExpireDate,
        'selfiePic': selfiePic,
        'country': country,
        'allowedSendAmount': remainingSendLimit,
        'level': level,
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'userNote': userNote,
      };
}
