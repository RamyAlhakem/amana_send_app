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
      iconUrl
      rate
      receiveFees
      usdAvailability
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
      defaultMessage
      currency {
        id
        ceil
        code
        name
        status
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
      fatherName
      lastName
      mobile
      status
      city {
        $city
        providers {
          $provider
        }
      }
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
