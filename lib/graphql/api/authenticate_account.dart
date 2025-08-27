import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/loading_button.dart';
import '/firebase/firebase.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/user.dart';

class AuthenticateAccount {
  AuthenticateAccount(
    this.context,
    this.buttonCtrl, {
    required this.pinNode,
    required this.pin,
    required this.mobile,
  });

  final BuildContext context;
  final TextEditingController pin;
  final String mobile;
  final FocusNode pinNode;
  final LoadingButtonController buttonCtrl;

  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    buttonCtrl.start();

    _variables = <String, dynamic>{'OTPKey': pin.text, 'mobile': mobile};

    Helper.debugger('userAuthenticateAccount');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userAuthenticateAccount),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
          Helper.debug('userAuthenticateAccount', '$data');

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
    if (data.isNotEmpty && data.containsKey('userAuthenticateAccount')) {
      buttonCtrl.success();
      UserModel.get = UserModel.fromJson(data['userAuthenticateAccount']);

      await Future.delayed(const Duration(milliseconds: 700), () {
        Global.snackKey.currentState?.hideCurrentMaterialBanner();
        context.go('/');
      });

      // save user in device local storage
      await Global.appSettings.loadSettings();

      FirebaseTool.getFirebaseToken().whenComplete(
        () => FirebaseTool.setFirebaseTopics(),
      );
    }
  }

  void _error(OperationException error) async {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.bannerWarning('Account already authenticated');
          break;

        case 453:
          Helper.bannerError(
              "You've tried three wrong attempts. You can try again next 24h");
          break;

        case 454:
          pin.clear();
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
