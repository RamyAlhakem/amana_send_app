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
      city
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
      displayName
      status
      displayDescription
      className
      iconUrl
      ''';

  static const String provider = '''
      id
      displayName
      iconUrl
      rate
      receiveFees
      usdAvailability
      minAmount
      maxAmount
      defaultMessage
      description
      tab
      ''';

  static const String city = '''
      id
      coCode
      name
      defaultMessage
     
      ''';

  static const String country = '''
    country {
      id
      enName
      arName
      coCode
      phoneCode
      sendsFees
      minimumSendsFees
      currency {
        id
        ceil
        code
        rate
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
      whatsappNumber
      note
      arFatherName
      arFirstName
      arLastName
      enFatherName
      enFirstName
      enLastName
      $country
      ''';

  static const String transfer = '''
      askedAmount
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
      className
      displayDescription
      displayName
      iconUrl
      id
      name
      status
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
