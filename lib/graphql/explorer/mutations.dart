import 'explorer.dart';

class Mutations {
  static String userSignIn(String captcha) => '''
    mutation userSignIn(\$mobile: NonEmptyString!, \$password: NonEmptyString!, \$firebaseToken: String!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      userSignIn(mobile: \$mobile, password: \$password, firebaseToken: \$firebaseToken${captcha.isNotEmpty ? ', captchaResponse: \$captchaResponse' : ''}) {
        ${Explorer.user}
        ${Explorer.country}
      }
    }
      ''';

  static String userSignUp(String captcha) => '''
    mutation userSignUp(\$firstName: NonEmptyString!, \$fatherName: String!, \$lastName: NonEmptyString!, \$countryCode: NonEmptyString!, \$mobile: NonEmptyString!, \$email: NonEmptyString!, \$password: NonEmptyString!, \$passwordConfirm: NonEmptyString!, \$firebaseToken: String!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      userSignUp(
        firstName: \$firstName
        fatherName: \$fatherName
        lastName: \$lastName
        countryCode: \$countryCode
        mobile: \$mobile
        email: \$email
        password: \$password
        passwordConfirm: \$passwordConfirm
        firebaseToken: \$firebaseToken
        ${captcha.isNotEmpty ? 'captchaResponse: \$captchaResponse' : ''}  
      ) {
        message
      }
    }
      ''';

  static const String userEdit = '''
    mutation userEdit(\$email: NonEmptyString!) {
      userEdit(email: \$email) {
        message
      }
    }
      ''';

  static const String calculateAmount = '''
mutation calculateAmount(\$coCode: String!,\$sendCountryCode: String!, \$isReceiveInUSD: Boolean!, \$paymentMethodId: Int!, \$providerId: Int!, \$sendAmount: Float ,\$recipientAmount: Float) {
  calculateAmount(
    coCode: \$coCode
    sendCountryCode: \$sendCountryCode
    isReceiveInUSD: \$isReceiveInUSD
    paymentMethodId: \$paymentMethodId
    providerId: \$providerId
    sendAmount: \$sendAmount
    recipientAmount: \$recipientAmount
  ) {
    
    recipientAmount
    sendAmount
    sendFees
    totalAmount
    receiveFees
  }
}
''';

  static const String userChangePassword = '''
    mutation userChangePassword(\$currentPassword: NonEmptyString!, \$newPassword: NonEmptyString!, \$confirmNewPassword: NonEmptyString!) {
      userChangePassword(
        currentPassword: \$currentPassword
        newPassword: \$newPassword
        confirmNewPassword: \$confirmNewPassword
      ) {
        message
      }
    }
      ''';

  static const String userSignOut = '''
    mutation userSignOut {
      userSignOut {
        message
      }
    }
      ''';

  static const String userDelete = '''
    mutation userDelete(\$password: NonEmptyString!) {
      userDelete(password: \$password) {
        message
      }
    }
      ''';

  static const String notificationsSeen = '''
      mutation notificationsSeen {
        notificationsSeen
      }
      ''';

//   static String recipientAdd(int id) {
//     return '''
//    mutation recipient {
//   recipientAdd(
//     arFatherName: \$arFatherName
//     arFirstName: \$arFirstName
//     arLastName: \$arLastName
//   firstName: \$firstName
//   lastName: \$lastName
//   fatherName: \$fatherName
//   countryCode: \$countryCode
//    mobile: \$mobile
//    whatsappNumber: \$whatsappNumber
//     note: \$note
//   ) {
//     code
//     message
//   }
// }
//       ''';
//   }
  static String recipientAdd(int id) {
    return '''
    mutation recipient${id == 0 ? 'Add' : 'Edit'}(${id != 0 ? '\$id: Int!, ' : ''}\$arFatherName: String!, \$arFirstName: String!, \$arLastName: String!, \$countryCode: NonEmptyString!, \$mobile: NonEmptyString!, \$whatsappNumber: NonEmptyString!,\$firstName:String!,\$lastName:String!,\$fatherName:String!,\$note:String!,) {
      recipient${id == 0 ? 'Add' : 'Edit'}(
        ${id != 0 ? 'id: \$id' : ''}
      arFatherName: \$arFatherName
    arFirstName: \$arFirstName
    arLastName: \$arLastName
  firstName: \$firstName
  lastName: \$lastName
  fatherName: \$fatherName
  countryCode: \$countryCode
   mobile: \$mobile
   whatsappNumber: \$whatsappNumber
    note: \$note
      ) {
        message
      }
    }
      ''';
  }

  static const String transfer = '''
      mutation transfer(\$isReceiveInUSD: Boolean!, \$paymentMethodId: Int!, \$providerId: Int!, \$receivingCityId: Int!, \$recipientAmount: Float!, \$recipientId: Int!, \$sendAmount: Float!,\$providerFields:[ProviderFieldInput]) {
        transfer(
          isReceiveInUSD: \$isReceiveInUSD
          paymentMethodId: \$paymentMethodId
          receivingCityId: \$receivingCityId
          providerId: \$providerId
          recipientAmount: \$recipientAmount
          recipientId: \$recipientId
          sendAmount: \$sendAmount
          providerFields: \$providerFields
        ) {
          ${Explorer.transfer}
        }
      }
      ''';

  static const String userVerifyAccount = '''
    mutation userVerifyAccount(\$arFirstName: String!, \$arFatherName: String!, \$arLastName: String!, \$city: String!, \$postCode: NonEmptyString!, \$fullAddress: NonEmptyString!, \$mainIdPicId: Int!, \$selfPicId: Int!) {
      userVerifyAccount(
        arFirstName: \$arFirstName
        arFatherName: \$arFatherName
        arLastName: \$arLastName
        city: \$city
        postCode: \$postCode
        fullAddress: \$fullAddress
        mainIdPicId: \$mainIdPicId
        selfPicId: \$selfPicId
      ) {
        ${Explorer.user}
      }
    }
      ''';

  static const String userAuthenticateAccount = '''
   mutation userAuthenticateAccount(\$OTPKey: String!, \$mobile: NonEmptyString!) {
      userAuthenticateAccount(OTPKey: \$OTPKey, mobile: \$mobile) {
        ${Explorer.user}
      }
    }
      ''';

  static String requestNewOTP(String captcha) => '''
    mutation requestNewOTP(\$mobile: NonEmptyString!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      requestNewOTP(mobile: \$mobile${captcha.isNotEmpty ? ', captchaResponse: \$captchaResponse' : ''}) {
        message
      }
    }
      ''';

  static const String userResetPassword = '''
    mutation userResetPassword(\$mobile: NonEmptyString!, \$OTPKey: String!, \$newPassword: NonEmptyString!, \$confirmNewPassword: NonEmptyString!) {
      userResetPassword(
        mobile: \$mobile
        OTPKey: \$OTPKey
        newPassword: \$newPassword
        confirmNewPassword: \$confirmNewPassword
      ) {
        message
      }
    }
      ''';

  static const String recipientDelete = '''
    mutation recipientDelete(\$id: Int!) {
      recipientDelete(id: \$id) {
        message
      }
    }
      ''';
}
