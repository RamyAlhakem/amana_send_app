import 'package:flutter/material.dart';

import '/models/transfer.dart';

class TransfersState extends ChangeNotifier {
  bool _isLoading = true;

  final List<TransferModel> _pendingTransfers = <TransferModel>[];
  final List<TransferModel> _newTransfers = <TransferModel>[];
  final List<TransferModel> _processingTransfers = <TransferModel>[];
  final List<TransferModel> _completedTransfers = <TransferModel>[];
  final List<TransferModel> _canceledTransfers = <TransferModel>[];

  // List<TransferModel> _filteredTransfers = <TransferModel>[];
  TransferModel _transfer = TransferModel();

  bool get isLoading => _isLoading;

  List<TransferModel> get pendingTransfers => _pendingTransfers;
  List<TransferModel> get newTransfers => _newTransfers;
  List<TransferModel> get processingTransfers => _processingTransfers;
  List<TransferModel> get completedTransfers => _completedTransfers;
  List<TransferModel> get canceledTransfers => _canceledTransfers;

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
      case 'processing':
        _processingTransfers.addAll(elements);
        break;
      case 'completed':
        _completedTransfers.addAll(elements);
        break;
      case 'canceled':
        _canceledTransfers.addAll(elements);
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
  }
}
