import 'explorer.dart';

class Queries {
  static String countries = '''
    query countries {
      send: countries(type: send) ${Explorer.country.trim().substring('country '.length)}
      receive: countries(type: receive) ${Explorer.country.trim().substring('country '.length)}
    }
      ''';

  static const String metadata = '''
    query metaData {
      metaData {
        address
        androidUrl
        apiAndroidVersion
        apiAppleVersion
        appForgetPasswordCaptcha
        appGalleryUrl
        appSignInCaptcha
        appSignUpCaptcha
        appStoreUrl
        companyHouseNumber
        contactEmail
        facebookUrl
        fca
        headOffice
        headOfficeLink
        mainCurrency
        mainPic
        maintenanceMessage
        maintenanceMode
        metaDesc
        minimumSendFee
        paymentTutorialUrl
        phoneNumber
        popupMessage
        popupStatus
        processedNote
        registerAddress
        registerAddressLink
        registrationNumber
        sendsFees
        siteTitle
        timezone
        usdRate
        usdRatio
        walletAddressValidTime
        whatsapp
        whoWeAre
        xUrl
      }
    }
      ''';

  static const String user = '''
    query user {
      user {
        ${Explorer.user}
        ${Explorer.country}
      }
    }
      ''';

  static const String notifications = '''
    query notifications {
      notifications {
        id
        addedAt
        status
        title
        message
        transactionId
        transactionStatus
      }
    }
      ''';

  static const String recipients = '''
    query recipients {
      recipients {
        ${Explorer.recipient}
      }
    }
      ''';

  static const String paymentMethods = '''
    query paymentMethods {
      paymentMethods {
        ${Explorer.paymentMethod}
      }
    }
      ''';

  static const String providers = '''
  query providers(\$cityId: Int, \$paymentMethodId: Int, \$sendCountryCode: String) {
    providers(cityId: \$cityId, paymentMethodId: \$paymentMethodId, sendCountryCode: \$sendCountryCode) {
      ${Explorer.provider}
    }
  }
''';

  static const String transaction = '''
    query MyQuery(\$id: ID!) {
      transaction(id: \$id) {
         ${Explorer.transfer}
      }
    }
      ''';

  static const String transactions = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
      pending: transactions(limit: \$limit, page: \$page, status: pending) {
        ${Explorer.transfer}
      }
      new: transactions(limit: \$limit, page: \$page, status: new) {
        ${Explorer.transfer}
      }
      processed: transactions(limit: \$limit, page: \$page, status: processed) {
        ${Explorer.transfer}
      }
      completed: transactions(limit: \$limit, page: \$page, status: completed) {
        ${Explorer.transfer}
      }
      canceled: transactions(limit: \$limit, page: \$page, status: canceled) {
        ${Explorer.transfer}
      }
      dispute: transactions(limit: \$limit, page: \$page, status: dispute) {
        ${Explorer.transfer}
      }
    }
      ''';
  static const String sliders = '''
  
  query MyQuery(\$type: Int = 10) {
  sliders(type: \$type) {
    id
    picUrl
    sortId
    status
    title
    type
  }
}
  
  
  ''';

  static const String providerFields = '''
    query providerFields(\$providerId: Int!) {
      providerFields(providerId: \$providerId) {
        ${Explorer.providerField}
      }
    }
  ''';
}
