import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/loading_button.dart';
import '/database/injector.dart';
import '/firebase/firebase.dart';
import '/global/variables.dart';
import '/graphql/api/get_countries.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import 'get_notifications.dart';

class LogInAPI {
  LogInAPI(
    this.buttonCtrl, {
    required this.mobile,
    required this.password,
    this.captcha = '',
  });

  final String mobile, password, captcha;
  final LoadingButtonController buttonCtrl;

  late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _variables = <String, dynamic>{
      'mobile': mobile,
      'password': password,
      'firebaseToken': Database().getUserBase.firebase.token,
      'captchaResponse': captcha,
    };

    Helper.debugger('userSignIn');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userSignIn(captcha)),
        variables: _variables,
        onCompleted: (Map<String, dynamic>? data) {
          Helper.debug('userSignIn', '$data');

          if (data != null) return _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error.graphqlErrors);
        },
      ),
    );
  }

  void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('userSignIn')) {
      // Clear country after registration complete.
      Global.key.currentContext!.read<RegistrationState>().setCountry(null);

      UserModel.get = UserModel.fromJson(data['userSignIn']);

      buttonCtrl.success();
      await Future.delayed(const Duration(milliseconds: 600), () {
        // await 600 milliseconds to show success button animation.
        // Then pop login page to dispose keys.
        Global.key.currentContext!.pop();
      });

      await Future.delayed(const Duration(milliseconds: 100), () async {
        // save user in device local storage
        await Global.appSettings.loadSettings().whenComplete(() {
          GetNotifications.request();
          GetCountriesAPI.request();
        });
        Helper.userVerify(
          UserModel.get.verified,
          showDialog: true,
          returnSnack: UserModel.get.verified == 0,
        );
      });

      FirebaseTool.getFirebaseToken().whenComplete(
        () => FirebaseTool.setFirebaseTopics(),
      );
    }
  }

  void _error(List<GraphQLError> errors) async {
    _arb = AppLocalizations.of(Global.key.currentContext!);

    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        case 401:
          Helper.bannerError(_arb!.wrongLogin);
          break;

        case 404:
          Helper.bannerError(_arb!.invalidMobileNumber);
          break;

        case 422:
          Global.key.currentContext!.pushReplacementNamed(
            '/${AppRoute.accountActivation}',
            pathParameters: <String, String>{'mobile': mobile},
            queryParameters: <String, String>{'reSendOTP': 'true'},
          );
          break;

        case 453:
          Helper.bannerError(_arb!.captchaVerificationFailed);
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
      buttonCtrl.error();

      // auto close banner message & rest button
      await Future.delayed(const Duration(seconds: 3));
      buttonCtrl.reset();
      Global.snackKey.currentState?.hideCurrentMaterialBanner();
    } else {
      buttonCtrl.reset();
    }
  }
}
