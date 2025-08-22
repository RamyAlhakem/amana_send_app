import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/loading_button.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/router/app_route.dart';

class ResendOTP {
  ResendOTP({required this.mobile, this.buttonCtrl, this.captcha = ''});

  final String mobile, captcha;
  final LoadingButtonController? buttonCtrl;

  late AppLocalizations? _arb;
  static final BuildContext _context = Global.key.currentContext!;
  static int _status = 0;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<int> request() async {
    _variables = <String, dynamic>{
      'mobile': mobile,
      'captchaResponse': captcha,
    };

    Helper.debugger('requestNewOTP');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.requestNewOTP(captcha)),
        variables: _variables,
        update: (GraphQLDataProxy cache, QueryResult<Object?>? result) => cache,
        onCompleted: (Map<String, dynamic>? data) async {
          if (data != null) {
            if (data.isNotEmpty && data.containsKey('requestNewOTP')) {
              _status = 200;

              // user calling this request from forgot password page:
              if (buttonCtrl != null) {
                buttonCtrl?.success();

                await Future.delayed(const Duration(milliseconds: 700), () {
                  _context.pushReplacementNamed('/${AppRoute.resetPassword}',
                      pathParameters: <String, String>{'mobile': mobile});
                });
              }
            }
          }
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error);
        },
      ),
    );
    return _status;
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(_context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 404:
          Helper.bannerWarning(_arb!.userNotFound);
          break;

        case 452:
          Helper.bannerWarning(_arb!.accountDeactivated);
          break;

        case 453:
          Helper.bannerWarning(
            _arb!.youHaveTriedThreeWrongAttemptsYouCanTryAgainNext24h,
          );
          break;

        case 454:
          Helper.bannerWarning(
            'Error sending OTP key message (Fail to send SMS)',
          );
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }

      if (buttonCtrl != null) buttonCtrl?.error();
      // auto close banner message
      await Future.delayed(const Duration(milliseconds: 2500));
      if (buttonCtrl != null) buttonCtrl?.reset();
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    } else {
      if (buttonCtrl != null) buttonCtrl?.reset();
    }
  }
}
