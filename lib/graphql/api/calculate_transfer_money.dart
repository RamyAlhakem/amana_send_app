import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/widgets/dialogs/loading.dart';
import 'package:amana_send/global/variables.dart';
import 'package:amana_send/graphql/explorer/mutations.dart';
import 'package:amana_send/graphql/graphql.dart';
import 'package:amana_send/helper/debug_colors.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

class CalculateTransferMoney {
  final BuildContext context;
  final String coCode;
  final int providerId;
  final bool isReceiveInUSD;
  final double? sendAmount;
  final double? recipientAmount;
  final int paymentMethodId;

  CalculateTransferMoney(this.context,
      {required this.coCode,
      required this.providerId,
      required this.isReceiveInUSD,
      this.sendAmount,
      this.recipientAmount,
      required this.paymentMethodId});
  late Calculator _p;
  Future<bool> request() async {
    _p = Provider.of<Calculator>(context, listen: false);
    Map<String, dynamic> variables = {
      "coCode": coCode,
      "providerId": providerId,
      "isReceiveInUSD": isReceiveInUSD,
      "sendAmount": sendAmount,
      "paymentMethodId": paymentMethodId,
      "recipientAmount": recipientAmount
    };
    Helper.debugger('calculateAmount');
    Helper.log('PARAMETERS: $variables', color: DebugColor.white);
    LoadingDialog().show();
    bool result = false;
    await GraphQL.client().mutate(MutationOptions(
        variables: variables,
        document: gql(Mutations.calculateAmount),
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();
          if (data != null && data.isNotEmpty) result = _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);
          if (error != null) _error(error);
        }));
    return result;
  }

  bool _result(Map<String, dynamic> data) {
    Helper.debug('calculateAmount data', '$data');
    if (data.containsKey('calculateAmount')) {
      if (data['calculateAmount'] != null &&
          data['calculateAmount'].isNotEmpty) {
        CalculateAmountModel calculateAmount =
            CalculateAmountModel.fromJson(data['calculateAmount']);
        _p.setCalculateAmount(calculateAmount);
      }
      return true;
      // Helper.banner('Email successfully changed');
    }
    return false;
  }

  void _error(OperationException error) async {
    _p.receiver.text = "";
    _p.sender.text = "";
    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        default:
          Helper.toast('${error.graphqlErrors.first.extensions?['message']}');
      }

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 2500));
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    }
  }
}
