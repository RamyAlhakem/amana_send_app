class Explorer {
  static const String user = '''
      id
      session
      firstName
      lastName
      arFirstName
      arFatherName
      arLastName
      mobile
      email
      verified
      city {
        $city
      }
      postCode
      mainIdPic
      selfiePic
      userNote
      allowedSendAmount
      fullAddress
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
      sendsFees
      minimumSendsFees
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
      city {
        $city
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
