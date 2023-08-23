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
    this.context,
    this.buttonCtrl, {
    this.fullName = '',
    required this.city,
    required this.postCode,
    required this.street,
    required this.building,
    required this.flat,
    this.addressPicId,
    required this.birthday,
    required this.idNumber,
    required this.idIssuedDate,
    required this.idExpireDate,
    this.mainIdPicId,
    this.selfiePicId,
  });

  final BuildContext context;
  final String fullName, city, postCode, street, building, flat, birthday;
  final String idNumber, idIssuedDate, idExpireDate;
  final int? addressPicId, mainIdPicId, selfiePicId;
  final LoadingButtonController buttonCtrl;

  static late AppLocalizations? _arb;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _arb = AppLocalizations.of(context);

    final UserModel user = Database().getUser;

    if (fullName.isEmpty) return Helper.bannerWarning(_arb!.enterFullName);
    if (city.isEmpty) return Helper.bannerWarning(_arb!.enterCity);
    if (postCode.isEmpty) return Helper.bannerWarning(_arb!.enterPostCode);
    if (street.isEmpty) return Helper.bannerWarning(_arb!.enterStreet);
    if (flat.isEmpty) return Helper.bannerWarning(_arb!.enterHouseNumber);

    if (user.addressPic.isEmpty && addressPicId == null) {
      return Helper.bannerWarning(_arb!.pleaseUploadProofOfAddress);
    }

    if (idNumber.isEmpty) {
      return Helper.bannerWarning(_arb!.enterIdentityNumber);
    }

    if (user.mainIdPic.isEmpty && mainIdPicId == null) {
      return Helper.bannerWarning(_arb!.pleaseUploadIdentityImage);
    }
    if (user.selfiePic.isEmpty && selfiePicId == null) {
      return Helper.bannerWarning(_arb!.pleaseUploadSelfie);
    }

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    FocusScope.of(context).unfocus();

    buttonCtrl.start();

    _variables = <String, dynamic>{
      'fullName': fullName,
      'city': city,
      'postCode': postCode,
      'street': street,
      'building': building,
      'flat': flat,
      'addressPicId': addressPicId ?? 0,
      'birthday': birthday,
      'idNumber': idNumber,
      'idIssuedDate': idIssuedDate,
      'idExpireDate': idExpireDate,
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
        () => context.pop(),
      ).whenComplete(() {
        // Show verify in process message
        Helper.userVerify(context, 0, returnSnack: true);
      });

      await Future.delayed(const Duration(milliseconds: 200));
      Global.appSettings.loadSettings();
    }
  }

  void _error(OperationException error) async {
    _arb = AppLocalizations.of(context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 452:
          Helper.bannerError(_arb!.iDExpireDateAlreadyExpired);
          break;

        case 453:
          Helper.bannerError(_arb!.iDIssuedDateIsInvalid);
          break;

        case 455:
          Helper.bannerError(_arb!.accountDeactivated);
          break;

        case 456:
          Helper.bannerError(_arb!.accountIsUnderReview);
          break;

        case 457:
          Helper.bannerError(_arb!.accountIsAlreadyVerified);
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
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
