import 'package:flutter/material.dart';

import '/models/transfer.dart';

class TransfersState extends ChangeNotifier {
  bool _isLoading = true;

  List<TransferModel> _transfers = <TransferModel>[];
  TransferModel _transfer = TransferModel();

  bool get isLoading => _isLoading;

  List<TransferModel> get transfers => _transfers;
  TransferModel get transfer => _transfer;

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  void getTransfers(List<TransferModel> transfers) {
    _transfers = transfers;
    notifyListeners();
  }

  void getTransfer(TransferModel transfer) {
    _transfer = transfer;
    notifyListeners();
  }

  void clearTransfers() {
    _transfers.clear();
    notifyListeners();
  }
}
