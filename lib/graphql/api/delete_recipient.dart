import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/dialogs/loading.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import 'get_recipients.dart';

class DeleteRecipient {
  DeleteRecipient(this.context, {required this.id});

  final BuildContext context;
  final int id;

  late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    LoadingDialog().show();

    _variables = <String, dynamic>{'id': id};

    Helper.debugger('recipientDelete');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.recipientDelete),
        variables: _variables,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();

          Helper.debug('recipientDelete', '$data');

          if (data != null) return _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error);
        },
      ),
    );
  }

  void _result(Map<String, dynamic> data) async {
    _arb = AppLocalizations.of(context);

    if (data.isNotEmpty && data.containsKey('recipientDelete')) {
      Helper.toast(
        _arb!.recipientHasBeenDeletedSuccessfully,
        bgColor: Colors.green,
      );

      LoadingDialog().show();

      await GetRecipients.request().whenComplete(() {
        LoadingDialog.dismiss();
        context.pop();
      });
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        // case 401:
        //   Helper.bannerError(arb!.wrongLogin);
        //   break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }
    }
  }
}
