import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';

class GetTransfer {
  GetTransfer(this.context, this.id);

  final BuildContext context;
  final int id;

  static late TransfersState _pr;
  static late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _pr = Provider.of<TransfersState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context);
    });

    _variables = <String, dynamic>{'id': id};

    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);
    Helper.debugger('transaction');
    await GraphQL.client()
        .query(QueryOptions(
            document: gql(Queries.transaction), variables: _variables))
        .then((result) {
      if (result.data != null) {
        Helper.debug('transaction', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('transaction')) {
      TransferModel transfer = TransferModel.fromJson(data['transaction']);

      _pr.getTransfer(transfer);
    }
  }

  void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        // case 422:
        //   break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
