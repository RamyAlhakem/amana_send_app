import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:graphql/client.dart';

import '/app/widgets/dialogs/loading.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import 'get_user.dart';

class ChangeEmail {
  ChangeEmail(this.context, {required this.email});

  final BuildContext context;
  final String email;

  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _variables = <String, dynamic>{'email': email};

    Helper.debugger('userEdit');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    LoadingDialog().show();

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userEdit),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();
          Helper.debug('userEdit', '$data');

          if (data != null && data.isNotEmpty) return _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error);
        },
      ),
    );
  }

  void _result(Map<String, dynamic> data) async {
    if (data.containsKey('userEdit')) {
      LoadingDialog().show();
      GetUserMeta.request().whenComplete(() => LoadingDialog.dismiss());

      Helper.banner('Email successfully changed');
    }
  }

  void _error(OperationException error) async {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        // case 454:
        //   Helper.bannerWarning('Invalid email');
        //   break;

        default:
          Helper.toast(
              '${arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 2500));
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    }
  }
}
