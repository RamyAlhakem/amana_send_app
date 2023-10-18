import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';

class GetTransfers {
  GetTransfers({this.limit = 20, this.page = 1});
  final int limit, page;

  static late TransfersState _provider;
  static late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<bool> request() async {
    bool isNotEmpty = false;
    BuildContext context = Global.key.currentContext!;
    _provider = Provider.of<TransfersState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context);
    });
    _variables = <String, dynamic>{'limit': limit, 'page': page};
    Helper.debugger('transactions');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);
    await GraphQL.client()
        .query(QueryOptions(
            document: gql(Queries.transactions), variables: _variables))
        .then((result) async {
      if (result.data != null) {
        Helper.debug('transactions', '${result.data}');

        if (result.data!.isNotEmpty) {
          await _result(result.data!).then((value) => isNotEmpty = value);
          return;
        }
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    }).whenComplete(() => _provider.isRequestLoading(false));
    return isNotEmpty;
  }

  bool _set(dynamic data, String type) {
    bool isNotEmpty = false;
    if (data.containsKey(type) && data[type] is List) {
      final List<TransferModel> elements = List<TransferModel>.from(
        data[type].map((x) => TransferModel.fromJson(x)),
      );
      _provider.getTransfers(type, elements);
      isNotEmpty = data[type].isNotEmpty;
    }
    return isNotEmpty;
  }

  Future<bool> _result(Map<String, dynamic> data) async {
    bool isNotEmpty = false;

    isNotEmpty = _set(data, TransferStatus.pending.name);
    isNotEmpty = _set(data, TransferStatus.nEW.name.toLowerCase()); // new.
    isNotEmpty = _set(data, TransferStatus.processed.name);
    isNotEmpty = _set(data, TransferStatus.completed.name);
    isNotEmpty = _set(data, TransferStatus.canceled.name);

    return isNotEmpty;
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
