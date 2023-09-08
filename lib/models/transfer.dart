import '/helper/safety_model.dart';
import 'agent.dart';
import '/models/recipient.dart';
import '/models/wallet.dart';

enum TransferStatus { pending, isNew, processing, completed, canceled }

class TransferModel extends SafetyModel {
  TransferModel({
    this.id = 0,
    this.sendAmount = 0,
    this.recipientAmount = 0,
    this.totalAmount = 0,
    this.reason = 0,
    this.fees = 0,
    this.isReceiveInUsd = false,
    this.cashToPay = false,
    this.status = TransferStatus.pending,
    this.convertedTotalAmount = 0,
    this.branchId = 0,
    this.completedMessage = '',
    this.completedAt = '0000-00-00',
    this.adminCancelReason = '',
    this.receiptPic = '',
    this.receiveType = 0,
    this.source = 0,
    this.paymentReference = '',
    this.paymentData = '',
    this.addedAt = '0000-00-00',
  });

  int id = 0, reason = 0, branchId = 0;
  bool isReceiveInUsd = false, cashToPay = false;
  double sendAmount = 0, recipientAmount = 0, totalAmount = 0, fees = 0;
  double convertedTotalAmount = 0;
  String completedMessage = '', adminCancelReason = '', receiptPic = '';
  String completedAt = '';
  int receiveType = 0, source = 0;
  String paymentReference = '', paymentData = '', addedAt = '';
  RecipientModel recipient = RecipientModel();
  AgentModel provider = AgentModel();
  WalletModel wallet = WalletModel();
  TransferStatus status = TransferStatus.pending;

  TransferStatus parseStatus(String status) {
    switch (status) {
      case 'pending':
        return TransferStatus.pending;
      case 'new':
        return TransferStatus.isNew;
      case 'processing':
        return TransferStatus.processing;
      case 'completed':
        return TransferStatus.completed;
      case 'canceled':
        return TransferStatus.canceled;
      default:
        return TransferStatus.pending;
    }
  }

  TransferModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    sendAmount = doubleFromJson(json, 'sendAmount');
    recipientAmount = doubleFromJson(json, 'recipientAmount');
    totalAmount = doubleFromJson(json, 'totalAmount');
    reason = intFromJson(json, 'reason');
    fees = doubleFromJson(json, 'fees');
    isReceiveInUsd = boolFromJson(json, 'isReceiveInUsd');
    cashToPay = boolFromJson(json, 'cashToPay');
    status = parseStatus('${json['status']}');
    convertedTotalAmount = doubleFromJson(json, 'convertedTotalAmount');
    branchId = intFromJson(json, 'branchId');
    completedMessage = stringFromJson(json, 'completedMessage');
    completedAt =
        stringFromJson(json, 'completedAt', defaultValue: '0000-00-00');
    adminCancelReason = stringFromJson(json, 'adminCancelReason');
    addedAt = stringFromJson(json, 'addedAt', defaultValue: '0000-00-00');
    receiptPic = stringFromJson(json, 'receiptPic');
    receiveType = intFromJson(json, 'receiveType');
    source = intFromJson(json, 'source');
    paymentReference = stringFromJson(json, 'paymentReference');
    paymentData = stringFromJson(json, 'paymentData');
    recipient = objectFromJson(
        json, 'recipient', (x) => RecipientModel.fromJson(x),
        defaultValue: RecipientModel());
    provider = objectFromJson(json, 'provider', (x) => AgentModel.fromJson(x),
        defaultValue: AgentModel());
    wallet = objectFromJson(
        json, 'walletAddress', (x) => WalletModel.fromJson(x),
        defaultValue: WalletModel());
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sendAmount': sendAmount,
        'recipientAmount': recipientAmount,
        'totalAmount': totalAmount,
        'reason': reason,
        'fees': fees,
        'isReceiveInUsd': isReceiveInUsd,
        'cashToPay': cashToPay,
        'status': status.toString(),
        'convertedTotalAmount': convertedTotalAmount,
        'branchId': branchId,
        'completedMessage': completedMessage,
        'completedAt': completedAt,
        'adminCancelReason': adminCancelReason,
        'addedAt': addedAt,
        'receiptPic': receiptPic,
        'receiveType': receiveType,
        'source': source,
        'paymentReference': paymentReference,
        'paymentData': paymentData,
        'recipient': recipient.toJson(),
        'provider': provider.toJson(),
        'walletAddress': wallet.toJson(),
      };

  bool isNull() {
    bool isNull = false;

    if (id == 0) isNull = true;
    if (sendAmount == 0) isNull = true;
    if (recipientAmount == 0) isNull = true;
    if (totalAmount == 0) isNull = true;

    return isNull;
  }
}
