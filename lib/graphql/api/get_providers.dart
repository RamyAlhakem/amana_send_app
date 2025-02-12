import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/agent.dart';

class GetProviders {
  static final BuildContext context = Global.key.currentContext!;
  static late Calculator _pr;

  Future<void> request() async {
    _pr = Provider.of<Calculator>(context, listen: false);

    Helper.debugger('providers');

    GraphQL.client()
        .query(QueryOptions(document: gql(Queries.providers)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('providers', '${result.data}');

        return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('providers')) {
      if (data['providers'] is List && data['providers'].isNotEmpty) {
        List<AgentModel> providers = List<AgentModel>.from(
          data['providers'].map((x) => AgentModel.fromJson(x)),
        );
        _pr.getAgents(providers);
      }
    }
  }

  void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        // case 422:
        //   break;

        // default:
        //   Helper.toast(
        //       '${_arb!.somethingWentWrong} [${errors.first.extensions?['code']}]');
      }
    }
  }
}
