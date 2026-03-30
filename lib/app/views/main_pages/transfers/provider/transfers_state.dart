import 'package:amana_send/app/views/main_pages/transfers/transfers.dart';
import 'package:flutter/material.dart';

import '/models/transfer.dart';

class TransfersState extends ChangeNotifier {
  bool _isLoading = true;
  int _page = 1;
  int get page => _page;
  int _index = 0;
  int get index => _index;
  final List<TransferModel> _pendingTransfers = <TransferModel>[];
  final List<TransferModel> _newTransfers = <TransferModel>[];
  final List<TransferModel> _processingTransfers = <TransferModel>[];
  final List<TransferModel> _completedTransfers = <TransferModel>[];
  final List<TransferModel> _canceledTransfers = <TransferModel>[];
  final List<TransferModel> _disputeTransfers = <TransferModel>[];

  // List<TransferModel> _filteredTransfers = <TransferModel>[];
  TransferModel _transfer = TransferModel();

  bool get isLoading => _isLoading;

  List<TransferModel> get pendingTransfers => _pendingTransfers;
  List<TransferModel> get newTransfers => _newTransfers;
  List<TransferModel> get processingTransfers => _processingTransfers;
  List<TransferModel> get completedTransfers => _completedTransfers;
  List<TransferModel> get canceledTransfers => _canceledTransfers;
  List<TransferModel> get disputeTransfers => _disputeTransfers;

  // List<TransferModel> get filteredTransfers => _filteredTransfers;

  TransferModel get transfer => _transfer;

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  void getTransfers(String type, List<TransferModel> elements) {
    switch (type) {
      case 'pending':
        _pendingTransfers.addAll(elements);
        break;
      case 'new':
        _newTransfers.addAll(elements);
        break;
      case 'processed':
        _processingTransfers.addAll(elements);
        break;
      case 'completed':
        _completedTransfers.addAll(elements);
        break;
      case 'canceled':
        _canceledTransfers.addAll(elements);
        break;
      case 'dispute':
        _disputeTransfers.addAll(elements);
        break;
    }

    notifyListeners();
  }

  void getTransfer(TransferModel transfer) {
    _transfer = transfer;
    notifyListeners();
  }

  void clearTransfers() {
    _pendingTransfers.clear();
    _newTransfers.clear();
    _processingTransfers.clear();
    _completedTransfers.clear();
    _canceledTransfers.clear();
    _disputeTransfers.clear();
  }

  incresePage() {
    _page++;
    notifyListeners();
  }

  resetPage() {
    _page = 1;
  }

  int getStatusIndex(Status status) {
    switch (status) {
      case Status.pending:
        return 0;
      case Status.newTransfer:
        return 1;
      case Status.processing:
        return 2;
      case Status.completed:
        return 3;
      case Status.canceled:
        return 4;
      case Status.dispute:
        return 5;
    }
  }

  setIndex(Status status) {
    _index = getStatusIndex(status);
  }

  Status getStatusName() {
    switch (_index) {
      case 0:
        return Status.pending;
      case 1:
        return Status.newTransfer;
      case 2:
        return Status.processing;
      case 3:
        return Status.completed;
      case 4:
        return Status.canceled;
      case 5:
        return Status.dispute;
      default:
        return Status.pending;
    }
  }
}
