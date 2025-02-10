import 'package:amana_send/global/variables.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/payment_method.dart';

class GetPaymentMethods {
 static final BuildContext context = Global.key.currentContext!;
static late Calculator _pr;
 static Future<void> request() async {
     _pr = Provider.of<Calculator>(context, listen: false);
    Helper.debugger('paymentMethods');
    GraphQL.client()
        .query(QueryOptions(document: gql(Queries.paymentMethods)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('paymentMethods', '${result.data}');
        return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);
          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

 static void _result(Map<String, dynamic> data) async {
  if (data.isNotEmpty && data.containsKey('paymentMethods')) {
    if (data['paymentMethods'] is List && data['paymentMethods'].isNotEmpty) {
      List<PaymentMethodModel> payments = List<PaymentMethodModel>.from(
        data['paymentMethods'].map((x) => PaymentMethodModel.fromJson(x)).toList(),
      );

      _pr.getPayments(payments);
    }
  }
}


 static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        default:
          Helper.toast(
              '${errors.first.extensions?['code']}');
      }
    }
  }
}
