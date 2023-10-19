import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/loading_button.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/user.dart';

class VerifyAccountAPI {
  VerifyAccountAPI(
    this.buttonCtrl, {
    required this.arFirstName,
    required this.arFatherName,
    required this.arLastName,
    required this.city,
    required this.postCode,
    required this.fullAddress,
    this.mainIdPicId,
    this.selfiePicId,
  });

  final String arFirstName, arFatherName, arLastName, postCode, fullAddress;
  final String city;
  final int? mainIdPicId, selfiePicId;
  final LoadingButtonController buttonCtrl;

  static late AppLocalizations _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  static final BuildContext _context = Global.key.currentContext!;
  Future<void> request() async {
    _arb = AppLocalizations.of(_context)!;

    final UserModel user = Database().getUser;

    if (arFirstName.isEmpty) return Helper.bannerWarning(_arb.enterFullName);
    if (arFatherName.isEmpty) return Helper.bannerWarning(_arb.enterFullName);
    if (arLastName.isEmpty) return Helper.bannerWarning(_arb.enterFullName);
    if (city.isEmpty) return Helper.bannerWarning(_arb.enterCity);
    if (postCode.isEmpty) return Helper.bannerWarning(_arb.enterPostCode);
    if (fullAddress.isEmpty) return Helper.bannerWarning(_arb.enterFullAddress);

    if (user.mainIdPic.isEmpty && mainIdPicId == null) {
      return Helper.bannerWarning(_arb.pleaseUploadIdentityImage);
    }
    if (user.selfiePic.isEmpty && selfiePicId == null) {
      return Helper.bannerWarning(_arb.pleaseUploadSelfie);
    }

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    FocusScope.of(_context).unfocus();

    buttonCtrl.start();

    _variables = <String, dynamic>{
      'arFirstName': arFirstName,
      'arFatherName': arFatherName,
      'arLastName': arLastName,
      'city': city,
      'postCode': postCode,
      'fullAddress': fullAddress,
      'mainIdPicId': mainIdPicId ?? 0,
      'selfPicId': selfiePicId ?? 0,
    };
    Helper.debugger('userVerifyAccount');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userVerifyAccount),
        variables: _variables,
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
    if (data.isNotEmpty && data.containsKey('userVerifyAccount')) {
      buttonCtrl.success();

      UserModel.get = UserModel.fromJson(data['userVerifyAccount']);
      await Future.delayed(
        const Duration(milliseconds: 800),
        () => _context.pop(),
      ).whenComplete(() {
        // Show verify in process message
        Helper.userVerify(0, returnSnack: true);
      });

      await Future.delayed(const Duration(milliseconds: 200));
      Global.appSettings.loadSettings();
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(_context)!;

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.bannerError(_arb.iDExpireDateAlreadyExpired);
          break;

        case 453:
          Helper.bannerError(_arb.iDIssuedDateIsInvalid);
          break;

        case 455:
          Helper.bannerError(_arb.accountDeactivated);
          break;

        case 456:
          Helper.bannerError(_arb.accountIsUnderReview);
          break;

        case 457:
          Helper.bannerError(_arb.accountIsAlreadyVerified);
          break;

        default:
          Helper.toast(
              '${_arb.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
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
