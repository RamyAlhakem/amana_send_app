import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/recipient.dart';

class GetRecipients {
  static final BuildContext context = Global.key.currentContext!;
  static late RecipientsState _recipients;
  static late AppLocalizations? _arb;

  static Future<void> request() async {
    _recipients = Provider.of<RecipientsState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context);
    });

    if (_recipients.all.isEmpty) _recipients.isRequestLoading(true);

    Helper.debugger('recipients');
    await GraphQL.client()
        .query(QueryOptions(document: gql(Queries.recipients)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('recipients', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    }).whenComplete(() => _recipients.isRequestLoading(false));
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.containsKey('recipients')) {
      if (data['recipients'] is List && data['recipients'].isNotEmpty) {
        List<RecipientModel> recipients = List<RecipientModel>.from(
          data['recipients'].map((x) => RecipientModel.fromJson(x)),
        );
        _recipients.getAll(recipients);
      } else {
        _recipients.getAll(<RecipientModel>[]);
      }
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        case 422:
          Helper.bannerWarning(_arb!.userNotFound);
          break;

        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
