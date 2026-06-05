import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/global/variables.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/provider_field.dart';

class GetProviderFields {
  GetProviderFields({required this.providerId});
  int providerId;
  static late Calculator _pr;

  Future<void> request() async {
    final BuildContext context = Global.key.currentContext!;
    _pr = Provider.of<Calculator>(context, listen: false);
    Map<String, dynamic> variables = {
      'providerId': providerId,
    };
    Helper.debugger('providerFields');

    GraphQL.client()
        .query(QueryOptions(
            document: gql(Queries.providerFields), variables: variables))
        .then((result) {
      if (result.data != null) {
        Helper.debug('providerFields', '${result.data}');

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
    if (data.isNotEmpty && data.containsKey('providerFields')) {
      if (data['providerFields'] is List && data['providerFields'].isNotEmpty) {
        List<ProviderFieldModel> fields = [];
        for (var item in data['providerFields']) {
          fields.add(ProviderFieldModel.fromJson(item));
        }
        _pr.setProviderFields(fields);
      } else {
        _pr.setProviderFields([]);
      }
    }
  }

  static void _error(List<GraphQLError> errors) {
    // Handle errors if necessary
  }
}
