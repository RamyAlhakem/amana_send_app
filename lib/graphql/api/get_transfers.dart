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

class GetTransfers {
  GetTransfers(this.context);

  final BuildContext context;

  static late TransfersState _pr;
  static late AppLocalizations? _arb;

  Future<void> request() async {
    _pr = Provider.of<TransfersState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context);
    });

    if (_pr.transfers.isEmpty) _pr.isRequestLoading(true);

    Helper.debugger('transactions');
    await GraphQL.client()
        .query(QueryOptions(document: gql(Queries.transactions())))
        .then((result) {
      if (result.data != null) {
        Helper.debug('transactions', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    }).whenComplete(() => _pr.isRequestLoading(false));
  }

  void _result(Map<String, dynamic> data) async {
    if (data.containsKey('transactions')) {
      if (data['transactions'] is List) {
        List<TransferModel> transactions = List<TransferModel>.from(
          data['transactions'].map((x) => TransferModel.fromJson(x)),
        );
        _pr.getTransfers(transactions);
      }
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
