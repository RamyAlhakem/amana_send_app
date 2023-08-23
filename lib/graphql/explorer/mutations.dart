import 'explorer.dart';

class Mutations {
  static String userSignIn(String captcha) => '''
    mutation userSignIn(\$email: NonEmptyString!, \$password: NonEmptyString!, \$firebaseToken: String!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      userSignIn(email: \$email, password: \$password, firebaseToken: \$firebaseToken${captcha.isNotEmpty ? ', captchaResponse: \$captchaResponse' : ''}) {
        ${Explorer.user}
        ${Explorer.country}
      }
    }
      ''';

  static String userSignUp(String captcha) => '''
    mutation userSignUp(\$firstName: NonEmptyString!, \$fatherName: String!, \$lastName: NonEmptyString!, \$countryCode: NonEmptyString!, \$mobile: NonEmptyString!, \$email: NonEmptyString!, \$password: NonEmptyString!, \$passwordConfirm: NonEmptyString!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      userSignUp(
        firstName: \$firstName
        fatherName: \$fatherName
        lastName: \$lastName
        countryCode: \$countryCode
        mobile: \$mobile
        email: \$email
        password: \$password
        passwordConfirm: \$passwordConfirm
        ${captcha.isNotEmpty ? 'captchaResponse: \$captchaResponse' : ''}  
      ) {
        message
      }
    }
      ''';

  static const String editUser = '''
    mutation editUser(\$email: NonEmptyString!) {
      editUser(email: \$email) {
        message
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

  static const String deleteUser = '''
    mutation deleteUser(\$password: NonEmptyString!) {
      deleteUser(password: \$password) {
        message
      }
    }
      ''';

  static const String notificationsSeen = '''
      mutation notificationsSeen {
        notificationsSeen
      }
      ''';

  static String recipientAdd(int id) {
    return '''
    mutation recipient${id == 0 ? 'Add' : 'Edit'}(${id != 0 ? '\$id: Int!, ' : ''}\$firstName: String!, \$lastName: String!, \$fatherName: String!, \$arFirstName: String!, \$arLastName: String!, \$arFatherName: String!, \$relativeRelation: NonEmptyString!, \$countryCode: NonEmptyString!, \$mobile: NonEmptyString!, \$cityId: NonEmptyInteger!, \$area: String!, \$bankAccountNumber: String!, \$bankAccountHolder: String!) {
      recipient${id == 0 ? 'Add' : 'Edit'}(
        ${id != 0 ? 'id: \$id' : ''}
        firstName: \$firstName
        lastName: \$lastName
        fatherName: \$fatherName
        arFirstName: \$arFirstName
        arLastName: \$arLastName
        arFatherName: \$arFatherName
        relativeRelation: \$relativeRelation
        countryCode: \$countryCode
        mobile: \$mobile
        cityId: \$cityId
        area: \$area
        bankAccountNumber: \$bankAccountNumber
        bankAccountHolder: \$bankAccountHolder
      ) {
        message
      }
    }
      ''';
  }

  static const String transfer = '''
      mutation transfer(\$isReceiveInUSD: Boolean!, \$paymentMethodId: Int!, \$providerId: Int!, \$recipientAmount: Float!, \$recipientId: Int!, \$sendAmount: Float!) {
        transfer(
          isReceiveInUSD: \$isReceiveInUSD
          paymentMethodId: \$paymentMethodId
          providerId: \$providerId
          recipientAmount: \$recipientAmount
          recipientId: \$recipientId
          sendAmount: \$sendAmount
        ) {
          ${Explorer.transfer}
        }
      }
      ''';

  static const String userVerifyAccount = '''
    mutation userVerifyAccount(\$fullName: String!, \$city: NonEmptyString!, \$postCode: NonEmptyString!, \$street: NonEmptyString!, \$building: String!, \$flat: NonEmptyString!, \$addressPicId: Int!, \$birthday: NonEmptyString!, \$idNumber: NonEmptyString!, \$idIssuedDate: NonEmptyString!, \$idExpireDate: NonEmptyString!, \$mainIdPicId: Int!, \$selfPicId: Int!) {
      userVerifyAccount(
        fullName: \$fullName
        city: \$city
        postCode: \$postCode
        street: \$street
        building: \$building
        flat: \$flat
        addressPicId: \$addressPicId
        birthday: \$birthday
        idNumber: \$idNumber
        idIssuedDate: \$idIssuedDate
        idExpireDate: \$idExpireDate
        mainIdPicId: \$mainIdPicId
        selfPicId: \$selfPicId
      ) {
        ${Explorer.user}
      }
    }
      ''';

  static const String userAuthenticateAccount = '''
    mutation userAuthenticateAccount(\$OTPKey: String!, \$email: NonEmptyString!) {
      userAuthenticateAccount(OTPKey: \$OTPKey, email: \$email) {
        ${Explorer.user}
        ${Explorer.country}
      }
    }
      ''';

  static String requestNewOTP(String captcha) => '''
    mutation requestNewOTP(\$email: NonEmptyString!${captcha.isNotEmpty ? ', \$captchaResponse: NonEmptyString!' : ''}) {
      requestNewOTP(email: \$email${captcha.isNotEmpty ? ', captchaResponse: \$captchaResponse' : ''}) {
        message
      }
    }
      ''';

  static const String userResetPassword = '''
    mutation userResetPassword(\$email: NonEmptyString!, \$OTPKey: String!, \$newPassword: NonEmptyString!, \$confirmNewPassword: NonEmptyString!) {
      userResetPassword(
        email: \$email
        OTPKey: \$OTPKey
        newPassword: \$newPassword
        confirmNewPassword: \$confirmNewPassword
      ) {
        message
      }
    }
      ''';

  static const String deleteRecipient = '''
    mutation deleteRecipient(\$id: Int!) {
      deleteRecipient(id: \$id) {
        message
      }
    }
      ''';
}
