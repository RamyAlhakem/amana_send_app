import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/global/variables.dart';
import 'package:amana_send/graphql/explorer/mutations.dart';
import 'package:amana_send/graphql/graphql.dart';
import 'package:amana_send/helper/debug_colors.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/models/currency.dart';
import 'package:amana_send/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CalculateTransferMoney {
  final BuildContext context;
  final String coCode;
  final String sendCountryCode;
  final int providerId;
  final bool isReceiveInUSD;
  final double? sendAmount;
  final double? recipientAmount;
  final int paymentMethodId;

  CalculateTransferMoney(this.context,
      {required this.coCode,
      required this.sendCountryCode,
      required this.providerId,
      required this.isReceiveInUSD,
      this.sendAmount,
      this.recipientAmount,
      required this.paymentMethodId});
  late Calculator _p;
  late AppLocalizations? arb;
  Future<bool> request() async {
    _p = Provider.of<Calculator>(context, listen: false);
    Map<String, dynamic> variables = {
      "coCode": coCode,
      "sendCountryCode": sendCountryCode,
      "providerId": providerId,
      "isReceiveInUSD": isReceiveInUSD,
      "sendAmount": sendAmount,
      "paymentMethodId": paymentMethodId,
      "recipientAmount": recipientAmount
    };
    Helper.debugger('calculateAmount');
    Helper.log('PARAMETERS: $variables', color: DebugColor.white);
    // LoadingDialog().show();
    bool result = false;
    await GraphQL.client().mutate(MutationOptions(
        variables: variables,
        document: gql(Mutations.calculateAmount),
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
          // LoadingDialog.dismiss();
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
        _p.setBorderColor(null);
        // Future.delayed(const Duration(seconds: 1), () {
        //   context.pushNamed(
        //     AppRoute.sendHub,
        //     pathParameters: <String, String>{'recipient': 'false'},
        //   );
        // });
      }
      return true;
      // Helper.banner('Email successfully changed');
    }
    return false;
  }

  void _error(OperationException error) async {
    arb = AppLocalizations.of(context);
    // _p.receiver.text = "";
    // _p.sender.text = "";
    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 401:
          Helper.toast(arb!.pleaseloginToContinue);
          context.push('/${AppRoute.logIn}');
        case 476:
          Helper.toast(arb!.pleaseChooseTheCity);
          _p.setBorderColor(Colors.red);
          Helper.snack(arb!.pleaseChooseTheCity);
        default:

          // Helper.toast(arb!.pleaseChooseTheCity);
          // _p.setBorderColor(Colors.red);
          Helper.toast('${error.graphqlErrors.first.extensions?['message']}');
          CalculateAmountModel calculateAmount = CalculateAmountModel.fromJson(
              error.graphqlErrors.first.extensions!);
          _p.setCalculateAmount(calculateAmount);
        // Helper.snack(arb!.pleaseChooseTheCity);
      }

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 2500));
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    }
  }
}
