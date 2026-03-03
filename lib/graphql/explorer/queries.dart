import 'explorer.dart';

class Queries {
  static String countries = '''
    query countries {
      send: countries(type: send) {
        ${Explorer.countryFields}
      }
      receive: countries(type: receive) {
        ${Explorer.countryFields}
      }
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
    query recipients(\$page:NonEmptyInteger,\$limit:NonEmptyInteger,\$search:String) {
      recipients(page:\$page,limit:\$limit,search:\$search) {
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
  static const String transactionsDispute = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
      dispute: transactions(limit: \$limit, page: \$page, status: dispute) {
        ${Explorer.transfer}
      }
    }
      ''';
  static const String transactionsCompleted = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
     
      completed: transactions(limit: \$limit, page: \$page, status: completed) {
        ${Explorer.transfer}
      }
     
    }
      ''';
  static const String transactionsCanceled = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
     
      canceled: transactions(limit: \$limit, page: \$page, status: canceled) {
        ${Explorer.transfer}
      }
    
    }
      ''';
  static const String transactionsPending = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
      pending: transactions(limit: \$limit, page: \$page, status: pending) {
        ${Explorer.transfer}
      }
    
    }
      ''';
  static const String transactionsNew = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
     
      new: transactions(limit: \$limit, page: \$page, status: new) {
        ${Explorer.transfer}
      }
 
    }
      ''';
  static const String transactionsProcessed = '''
    query transactions(\$limit: NonEmptyInteger!, \$page: NonEmptyInteger!) {
     
      processed: transactions(limit: \$limit, page: \$page, status: processed) {
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
