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
import '/router/app_route.dart';

class RegisterAPI {
  RegisterAPI(
    this.context,
    this.buttonCtrl, {
    required this.aName,
    required this.bName,
    required this.cName,
    required this.coCode,
    required this.mob,
    required this.email,
    required this.pass,
    required this.coPass,
    this.captcha = '',
  });

  final BuildContext context;
  final String aName, bName, cName, coCode, mob, email, pass, coPass, captcha;
  final LoadingButtonController buttonCtrl;

  late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _variables = <String, dynamic>{
      'firstName': aName,
      'fatherName': bName,
      'lastName': cName,
      'countryCode': coCode,
      'mobile': mob,
      'email': email,
      'password': pass,
      'passwordConfirm': coPass,
      'captchaResponse': captcha,
    };

    Helper.debugger('userSignUp');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userSignUp(captcha)),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) {
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
    if (data.containsKey('userSignUp')) {
      buttonCtrl.success();

      await Future.delayed(const Duration(milliseconds: 700), () {
        context.pushReplacementNamed(
          '/${AppRoute.accountActivation}',
          pathParameters: <String, String>{'mobile': mob},
          queryParameters: <String, String>{'reSendOTP': 'false'},
        );
      });
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.bannerWarning(_arb!.passwordMustContainAtLeast8Characters);
          break;

        case 454:
          Helper.bannerWarning(_arb!.mobileAlreadyExist);
          break;

        case 455:
          Helper.bannerWarning(
            'Error sending OTP key message (Fail to send SMS)',
          );
          break;

        case 453:
          Helper.bannerWarning(_arb!.emailAlreadyExist);
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }
      buttonCtrl.error();

      // auto close banner message & rest button
      await Future.delayed(const Duration(milliseconds: 3500));
      buttonCtrl.reset();
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    } else {
      buttonCtrl.reset();
    }
  }
}
