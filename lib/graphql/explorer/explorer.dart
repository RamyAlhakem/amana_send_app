class Explorer {
  static const String user = '''
      id
      session
      firstName
      lastName
      mobile
      email
      verified
      fullName
      city
      postCode
      street
      building
      flat
      addressPic
      birthday
      mainIdPic
      idNumber
      idIssuedDate
      idExpireDate
      selfiePic
      userNote
      allowedSendAmount
      level {
        id
        iconUrl
        title
        duration
        status
        minAmount
        maxAmount
      }
      ''';

  static const String paymentMethod = '''
      id
      name
      isManual
      displayName
      status
      displayDescription
      ''';

  static const String provider = '''
      id
      name
      status
      iconUrl
      ''';

  static const String city = '''
      id
      areaNote
      coCode
      name
      defaultMessage
      providers {
        $provider
      }
      ''';

  static const String country = '''
    country {
      id
      enName
      arName
      coCode
      phoneCode
      minAmount
      maxAmount
      usdAvailability
      recipientEnglishMandatory
      recipientArabicMandatory
      receiveBank
      receiveCash
      receiveMobileWallet
      defaultMessage
      currency {
        code
        name
        profitRatio
        rate
        symbol
      }
      cities {
        $city
      }
    }
      ''';

  static const String recipient = '''
      id
      firstName
      arFirstName
      fatherName
      arFatherName
      lastName
      arLastName
      mobile
      relativeRelation
      status
      city {
        $city
        providers {
          $provider
        }
      }
      area
      dateAdded
      $country
      ''';

  static const String transfer = '''
      id
      totalAmount
      addedAt
      adminCancelReason
      branchId
      completedAt
      completedMessage
      convertedTotalAmount
      fees
      isReceiveInUsd
      orderBy
      paymentData
      paymentReference
      paymentMethod {
        $paymentMethod
      }
      provider {
        $provider
      }
      walletAddress {
        id
        address
      }
      sendAmount
      status
      receiptPic
      receiveType
      recipientAmount
      recipient {
        $recipient
      }
      ''';
}
