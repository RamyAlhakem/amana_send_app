import '/helper/safety_model.dart';

class AppMetadata extends SafetyModel {
  AppMetadata({
    this.address = '',
    this.androidUrl = '',
    this.appGalleryUrl = '',
    this.appStoreUrl = '',
    this.companyHouseNumber = '',
    this.contactEmail = '',
    this.facebookUrl = '',
    this.maintenanceMessage = '',
    this.maintenanceMode = false,
    this.minimumSendFee = 0,
    this.sendsFees = 0,
    this.usdRate = 0,
    this.walletAddressValidTime = 0,
    this.phoneNumber = '',
    this.whatsapp = '',
    this.xUrl = '',
    this.registerAddress = '',
    this.registrationNumber = '',
    this.appSignInCaptcha = false,
    this.appSignUpCaptcha = false,
    this.appForgetPasswordCaptcha = false,
  });

  String address = '', androidUrl = '', appGalleryUrl = '', appStoreUrl = '';
  String companyHouseNumber = '', contactEmail = '', facebookUrl = '';
  String maintenanceMessage = '';
  bool maintenanceMode = false;
  double minimumSendFee = 0;
  double sendsFees = 0;
  double usdRate = 0;
  double usdRatio = 0;
  int walletAddressValidTime = 0;
  String phoneNumber = '';
  String whatsapp = '';
  String xUrl = '';
  String registerAddress = '';
  String registrationNumber = '';
  bool appSignInCaptcha = false, appSignUpCaptcha = false;
  bool appForgetPasswordCaptcha = false;

  static AppMetadata get = AppMetadata();
  AppMetadata.fromJson(Map<String, dynamic> json) {
    address = stringFromJson(json, 'address');
    androidUrl = stringFromJson(json, 'androidUrl');
    appGalleryUrl = stringFromJson(json, 'appGalleryUrl');
    appStoreUrl = stringFromJson(json, 'appStoreUrl');
    companyHouseNumber = stringFromJson(json, 'companyHouseNumber');
    contactEmail = stringFromJson(json, 'contactEmail');
    facebookUrl = stringFromJson(json, 'facebookUrl');
    maintenanceMessage = stringFromJson(json, 'maintenanceMessage');
    maintenanceMode = boolFromJson(json, 'maintenanceMode');
    minimumSendFee = doubleFromJson(json, 'minimumSendFee', decimal: 10);
    sendsFees = doubleFromJson(json, 'sendsFees', decimal: 10);
    usdRate = doubleFromJson(json, 'usdRate', decimal: 10);
    usdRatio = doubleFromJson(json, 'usdRatio', decimal: 10);
    walletAddressValidTime = intFromJson(json, 'walletAddressValidTime');
    phoneNumber = stringFromJson(json, 'phoneNumber');
    whatsapp = stringFromJson(json, 'whatsapp');
    xUrl = stringFromJson(json, 'xUrl');
    registerAddress = stringFromJson(json, 'registerAddress');
    registrationNumber = stringFromJson(json, 'registrationNumber');
    appSignInCaptcha = boolFromJson(json, 'appSignInCaptcha');
    appSignUpCaptcha = boolFromJson(json, 'appSignUpCaptcha');
    appForgetPasswordCaptcha = boolFromJson(json, 'appForgetPasswordCaptcha');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'androidUrl': androidUrl,
        'appGalleryUrl': appGalleryUrl,
        'appStoreUrl': appStoreUrl,
        'companyHouseNumber': companyHouseNumber,
        'contactEmail': contactEmail,
        'facebookUrl': facebookUrl,
        'maintenanceMessage': maintenanceMessage,
        'maintenanceMode': maintenanceMode,
        'minimumSendFee': minimumSendFee,
        'sendsFees': sendsFees,
        'usdRate': usdRate,
        'usdRatio': usdRatio,
        'walletAddressValidTime': walletAddressValidTime,
        'phoneNumber': phoneNumber,
        'whatsapp': whatsapp,
        'xUrl': xUrl,
        'registerAddress': registerAddress,
        'registrationNumber': registrationNumber,
        'appSignInCaptcha': appSignInCaptcha,
        'appSignUpCaptcha': appSignUpCaptcha,
        'appForgetPasswordCaptcha': appForgetPasswordCaptcha,
      };
}
