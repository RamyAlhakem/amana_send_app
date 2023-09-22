import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/country.dart';

class GetCountriesAPI {
  static late Calculator _p;
  static late AppLocalizations _arb;

  static final BuildContext context = Global.key.currentContext!;
  static Future<void> request() async {
    _p = Provider.of<Calculator>(context, listen: false);
    _arb = AppLocalizations.of(context)!;

    if (_p.sendCountries.isEmpty) _p.isRequestLoading(true);

    Helper.debugger('countries');
    await GraphQL.client()
        .query(QueryOptions(document: gql(Queries.countries)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('countries', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    }).whenComplete(() => _p.isRequestLoading(false));
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.containsKey('send') && data.containsKey('receive')) {
      if (data['send'] is List && data['send'].isNotEmpty) {
        List<CountryModel> sendCountries = List<CountryModel>.from(
          data['send'].map((x) => CountryModel.fromJson(x)),
        );
        _p.getSendCountries(sendCountries);
      }
      if (data['receive'] is List && data['receive'].isNotEmpty) {
        List<CountryModel> receiveCountries = List<CountryModel>.from(
          data['receive'].map((x) => CountryModel.fromJson(x)),
        );

        _p.getReceiveCountries(receiveCountries);
      }
      Helper.toast(
        _arb.currenciesPricesUpToDate,
        bgColor: Colors.white.withOpacity(0.95),
        textColor: Colors.black54,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
      );
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
