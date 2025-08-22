import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/dialogs/loading.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/router/app_route.dart';
import '/services/user_service.dart';

class ChangePassword {
  ChangePassword(
    this.context, {
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  final BuildContext context;
  final String currentPassword, newPassword, confirmNewPassword;

  late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _variables = <String, dynamic>{
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };

    Helper.debugger('userChangePassword');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    LoadingDialog().show();

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userChangePassword),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();
          Helper.debug('userChangePassword', '$data');

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
    _arb = AppLocalizations.of(context);

    if (data.containsKey('userChangePassword')) {
      if (Global.isAnyDialogOpen(context)) LoadingDialog.dismiss();
      context.pop();

      UserService.clearUser(context).whenComplete(
        () => context.push('/${AppRoute.logIn}'),
      );

      Helper.banner(_arb!.passwordSuccessfullyChangedPleaseLoginToContinue);
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.bannerError(_arb!.incorrectPassword);
          break;

        case 454:
          Helper.bannerWarning(
            _arb!.newPasswordCannotBeTheSameAsTheCurrentPassword,
          );
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 2500));
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    }
  }
}
