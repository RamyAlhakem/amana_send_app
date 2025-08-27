import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import '/app/widgets/dialogs/loading.dart';
import '/global/variables.dart';
import '/graphql/api/get_recipients.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';

class AddEditRecipientAPI {
  AddEditRecipientAPI({
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.countryCode,
    required this.mobile,
    required this.whatsApp,
    required this.arFatherName,
    required this.arFirstName,
    required this.arLastName,
    required this.note,
    this.id = 0,
  });

  final String firstName, lastName, fatherName,arFatherName,arFirstName,arLastName;
  final String countryCode, mobile, whatsApp,note;
  final int id;

  static Map<String, dynamic> _variables = const <String, dynamic>{};

  static final BuildContext _context = Global.key.currentContext!;
  Future<void> request() async {
    final String json = id != 0 ? 'recipientEdit' : 'recipientAdd';
    LoadingDialog().show();

    _variables = <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'countryCode': countryCode,
      'mobile': mobile,
      'whatsappNumber': whatsApp,
      'arFatherName':arFatherName,
      'arFirstName':arFirstName,
      'arLastName':arLastName,
      'note':note

      
    };

    Helper.debugger(json);
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.recipientAdd(id)),
        variables: _variables,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();

          Helper.debug(json, '$data');

          if (data != null) return _result(data, json);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error);
        },
      ),
    );
  }

  void _result(Map<String, dynamic> data, String json) async {
    if (data.isNotEmpty && data.containsKey(json)) {
      LoadingDialog().show();

      await GetRecipients.request().whenComplete(() {
        LoadingDialog.dismiss();
        _context.pop();
      });
    }
  }

  void _error(OperationException error) async {
    final AppLocalizations? arb = AppLocalizations.of(_context);

    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        // case 404:
        //   Helper.bannerError('Invalid mobile number');
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
