import 'package:graphql/client.dart';

import '/firebase/firebase.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';

class LogOutAPI {
  static Future<void> request() async {
    Helper.debugger('signOut');

    GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.userSignOut),
        onCompleted: (Map<String, dynamic>? data) {
          Helper.debug('signOut', '$data');

          if (data != null) return _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) return _error(error.graphqlErrors);
        },
      ),
    );
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('signOut')) {
      FirebaseTool.getFirebaseToken().whenComplete(
        () => FirebaseTool.setFirebaseTopics(),
      );
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        default:
        // Helper.toast(
        //     '${arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
