import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/currency.dart';

class GetExchangeCurrenciesAPI {
  const GetExchangeCurrenciesAPI({required this.countryCoCode});
  final String countryCoCode;

  static late Calculator _p;
  static late AppLocalizations _arb;

  static final BuildContext context = Global.key.currentContext!;
  Future<void> request() async {
    _p = Provider.of<Calculator>(context, listen: false);
    _arb = AppLocalizations.of(context)!;

    Helper.debugger('exchangeCurrencies');
    await GraphQL.client()
        .query(QueryOptions(
            document: gql(Queries.exchangeCurrencies(countryCoCode))))
        .then((result) {
      if (result.data != null) {
        Helper.debug('exchangeCurrencies', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.containsKey('exchangeCurrencies')) {
      if (data['exchangeCurrencies'] is List) {
        List<CurrencyModel> currencies = List<CurrencyModel>.from(
          data['exchangeCurrencies'].map((x) => CurrencyModel.fromJson(x)),
        );
        _p.getCurrencies(currencies);
      }
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        // case 422:
        //   break;

        default:
          Helper.toast(
              '${_arb.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
