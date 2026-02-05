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
  GetProviders(
      {required this.cityID,
      required this.paymentMethodID,
      required this.sendCountryCode});
  int cityID;
  int paymentMethodID;
  String sendCountryCode;
  static final BuildContext context = Global.key.currentContext!;
  static late Calculator _pr;

  Future<void> request() async {
    _pr = Provider.of<Calculator>(context, listen: false);
    Map<String, dynamic> variables = {
      'cityId': cityID,
      'paymentMethodId': paymentMethodID,
      'sendCountryCode': sendCountryCode
    };
    Helper.log("variables for providers ====> $variables");
    Helper.debugger('providers');

    GraphQL.client()
        .query(QueryOptions(
            document: gql(Queries.providers), variables: variables))
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

  static void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('providers')) {
      if (data['providers'] is List && data['providers'].isNotEmpty) {
        Helper.log("providers data ====> ${data['providers']}");
        List<AgentModel> providers = List<AgentModel>.from(
          data['providers'].map((x) => AgentModel.fromJson(x)),
        );
        _pr.providersNew = providers;
        Helper.log("providers data leangth ====> ${providers.length}");
        _pr.getAgents(providers);
      }
    }
  }

  static void _error(List<GraphQLError> errors) async {
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
