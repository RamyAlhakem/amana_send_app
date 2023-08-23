import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql/client.dart';

import '/app/widgets/dialogs/loading.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/services/user_service.dart';

class DeleteUser {
  DeleteUser(this.context, {required this.password});

  final BuildContext context;
  final String password;

  late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    LoadingDialog().show();

    _variables = <String, dynamic>{'password': password};

    Helper.debugger('deleteUser');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.deleteUser),
        variables: _variables,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();

          Helper.debug('deleteUser', '$data');

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

    if (data.isNotEmpty && data.containsKey('deleteUser')) {
      Helper.banner(_arb!.accountHasBeenDeletedSuccessfully);

      UserService.clearUser(context);
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.toast(_arb!.incorrectPassword, bgColor: Colors.red);
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }
    }
  }
}
