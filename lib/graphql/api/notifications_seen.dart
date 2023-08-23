import 'package:graphql/client.dart';

import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';

class NotificationsSeen {
  static Future<void> request() async {
    Helper.debugger('notificationsSeen');

    await GraphQL.client()
        .query(QueryOptions(document: gql(Mutations.notificationsSeen)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('notificationsSeen', '${result.data}');

        return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('notificationsSeen')) {}
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        // case 404:
        //   break;

        // default:
        //   Helper.toast(
        //       '${arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
