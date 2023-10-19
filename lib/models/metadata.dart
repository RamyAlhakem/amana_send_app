import '/helper/safety_model.dart';

class AppMetadata extends SafetyModel {
  AppMetadata({
    this.address = '',
    this.androidUrl = '',
    this.apiAndroidVersion = '',
    this.apiAppleVersion = '',
    this.appGalleryUrl = '',
    this.appStoreUrl = '',
    this.companyHouseNumber = '',
    this.contactEmail = '',
    this.fca = '',
    this.facebookUrl = '',
    this.headOffice = '',
    this.headOfficeLink = '',
    this.mainCurrency = '',
    this.mainPic = '',
    this.metaDesc = '',
    this.paymentTutorialUrl = '',
    this.popupMessage = '',
    this.processedNote = '',
    this.maintenanceMessage = '',
    this.maintenanceMode = false,
    this.popupStatus = false,
    this.minimumSendFee = 0,
    this.sendsFees = 0,
    this.usdRate = 0,
    this.walletAddressValidTime = 0,
    this.phoneNumber = '',
    this.whatsapp = '',
    this.xUrl = '',
    this.registerAddress = '',
    this.registerAddressLink = '',
    this.registrationNumber = '',
    this.appSignInCaptcha = false,
    this.appSignUpCaptcha = false,
    this.appForgetPasswordCaptcha = false,
  });

  String address = '', androidUrl = '', appGalleryUrl = '', appStoreUrl = '';
  String companyHouseNumber = '', contactEmail = '', facebookUrl = '', fca = '';
  String maintenanceMessage = '', apiAndroidVersion = '', apiAppleVersion = '';
  String headOffice = '', headOfficeLink = '', mainCurrency = '', mainPic = '';
  String metaDesc = '', paymentTutorialUrl = '', popupMessage = '';
  String processedNote = '', whoWeAre = '';
  bool maintenanceMode = false, popupStatus = false;
  double minimumSendFee = 0;
  double sendsFees = 0;
  double usdRate = 0;
  double usdRatio = 0;
  int walletAddressValidTime = 0;
  String phoneNumber = '';
  String whatsapp = '';
  String xUrl = '';
  String registerAddress = '', registerAddressLink = '';
  String registrationNumber = '';
  bool appSignInCaptcha = false, appSignUpCaptcha = false;
  bool appForgetPasswordCaptcha = false;

  static AppMetadata get = AppMetadata();
  AppMetadata.fromJson(Map<String, dynamic> json) {
    address = stringFromJson(json, 'address');
    androidUrl = stringFromJson(json, 'androidUrl');
    apiAndroidVersion = stringFromJson(json, 'apiAndroidVersion');
    apiAppleVersion = stringFromJson(json, 'apiAppleVersion');
    appGalleryUrl = stringFromJson(json, 'appGalleryUrl');
    appStoreUrl = stringFromJson(json, 'appStoreUrl');
    companyHouseNumber = stringFromJson(json, 'companyHouseNumber');
    contactEmail = stringFromJson(json, 'contactEmail');
    fca = stringFromJson(json, 'fca');
    facebookUrl = stringFromJson(json, 'facebookUrl');
    headOffice = stringFromJson(json, 'headOffice');
    headOfficeLink = stringFromJson(json, 'headOfficeLink');
    mainCurrency = stringFromJson(json, 'mainCurrency');
    mainPic = stringFromJson(json, 'mainPic');
    metaDesc = stringFromJson(json, 'metaDesc');
    paymentTutorialUrl = stringFromJson(json, 'paymentTutorialUrl');
    popupMessage = stringFromJson(json, 'popupMessage');
    processedNote = stringFromJson(json, 'processedNote');
    popupStatus = boolFromJson(json, 'popupStatus');
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
    registerAddressLink = stringFromJson(json, 'registerAddressLink');
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
        'apiAndroidVersion': apiAndroidVersion,
        'apiAppleVersion': apiAppleVersion,
        'appStoreUrl': appStoreUrl,
        'companyHouseNumber': companyHouseNumber,
        'contactEmail': contactEmail,
        'fca': fca,
        'facebookUrl': facebookUrl,
        'headOffice': headOffice,
        'headOfficeLink': headOfficeLink,
        'mainCurrency': mainCurrency,
        'mainPic': mainPic,
        'metaDesc': metaDesc,
        'paymentTutorialUrl': paymentTutorialUrl,
        'popupMessage': popupMessage,
        'popupStatus': popupStatus,
        'processedNote': processedNote,
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
        'registerAddressLink': registerAddressLink,
        'registrationNumber': registrationNumber,
        'appSignInCaptcha': appSignInCaptcha,
        'appSignUpCaptcha': appSignUpCaptcha,
        'appForgetPasswordCaptcha': appForgetPasswordCaptcha,
      };
}
