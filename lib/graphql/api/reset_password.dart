import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/loading_button.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';

class ResetPasswordAPI {
  ResetPasswordAPI(
    this.context,
    this.buttonCtrl, {
    required this.mobile,
    required this.pinNode,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  final BuildContext context;
  final FocusNode pinNode;
  final TextEditingController code;
  final String mobile, newPassword, confirmPassword;
  final LoadingButtonController buttonCtrl;

  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _variables = <String, dynamic>{
      'mobile': mobile,
      'OTPKey': int.parse(code.text),
      'newPassword': newPassword,
      'confirmNewPassword': confirmPassword,
    };

    Helper.debugger('resetPassword');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userResetPassword),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
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
    if (data.isNotEmpty && data.containsKey('resetPassword')) {
      buttonCtrl.success();

      Helper.banner(
          'Password successfully changed, Please sign in with the new password');

      await Future.delayed(const Duration(milliseconds: 700), () {
        context.pop();
      });
    }
  }

  void _error(OperationException? error) async {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (error != null && error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 453:
          code.clear();
          FocusScope.of(context).requestFocus(pinNode);
          Helper.bannerError('Wrong OTP');
          break;

        default:
          Helper.toast(
              '${arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }
      buttonCtrl.error();

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 2500));
      buttonCtrl.reset();
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    } else {
      buttonCtrl.reset();
    }
  }
}
