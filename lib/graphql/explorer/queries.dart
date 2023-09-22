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

  static String exchangeCurrencies(String countryCoCode) => '''
    query exchangeCurrencies {
      exchangeCurrencies(countryCoCode: "$countryCoCode") {
        code
        rate
      }
    }
      ''';

  static String transactions({int id = 0}) {
    return '''
    query ${id > 0 ? 'transaction(\$id: ID!)' : 'transactions'} {
      ${id > 0 ? 'transaction(id: \$id)' : 'transactions'} {
        ${Explorer.transfer}
      }
    }
      ''';
  }
}
