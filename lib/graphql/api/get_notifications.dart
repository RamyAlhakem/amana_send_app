import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/notifications/provider/notifications_state.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/notification.dart';

class GetNotifications {
  static final BuildContext context = Global.key.currentContext!;
  static late NotificationsState _state;
  static late AppLocalizations? _arb;

  static Future<void> request() async {
    _state = Provider.of<NotificationsState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context);
    });

    if (_state.notifications.isEmpty) _state.isRequestLoading(true);

    Helper.debugger('notifications');

    GraphQL.client()
        .query(QueryOptions(document: gql(Queries.notifications)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('notifications', '${result.data}');

        if (result.data!.isNotEmpty) return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    }).whenComplete(() => _state.isRequestLoading(false));
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.containsKey('notifications')) {
      if (data['notifications'] is List) {
        List<NotificationModel> notifications = List<NotificationModel>.from(
          data['notifications'].map((x) => NotificationModel.fromJson(x)),
        );
        _state.getNotifications(notifications);
      }
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        default:
          Helper.toast(
              '${_arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
