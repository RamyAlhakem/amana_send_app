import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import '/services/user_service.dart';

class GetUserMeta {
  static final BuildContext context = Global.key.currentContext!;
  static Future<void> request() async {
    Helper.debugger('user');
    await GraphQL.client()
        .query(QueryOptions(document: gql(Queries.user)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('user', '${result.data}');

        return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  static void _result(Map<String, dynamic> data) {
    if (data.isNotEmpty && data.containsKey('user')) {
      UserModel.get = UserModel.fromJson(data['user']);
      Global.appSettings.loadSettings(rebuild: false);
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        case 401:
          UserService.clearUser(context);
          break;
      }
    }
  }
}
