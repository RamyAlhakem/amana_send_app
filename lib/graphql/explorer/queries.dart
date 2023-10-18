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
        appGalleryUrl
        appStoreUrl
        apiAppleVersion
        apiAndroidVersion
        companyHouseNumber
        contactEmail
        facebookUrl
        maintenanceMessage
        maintenanceMode
        minimumSendFee
        sendsFees
        usdRate
        usdRatio
        phoneNumber
        walletAddressValidTime
        whatsapp
        xUrl
        registerAddress
        registrationNumber
        whoWeAre
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

  static String paymentMethods = '''
    query paymentMethods {
      paymentMethods {
        ${Explorer.paymentMethod}
      }
    }
      ''';

  static String providers = '''
    query providers {
      providers {
        ${Explorer.provider}
      }
    }
      ''';

  static String transaction = '''
    query MyQuery(\$id: ID!) {
      transaction(id: \$id) {
         ${Explorer.transfer}
      }
    }
      ''';

  static String transactions = '''
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
    }
      ''';
}
