import 'package:amana_send/configs/configs.dart';
import 'package:amana_send/graphql/explorer/queries.dart';
import 'package:amana_send/helper/debug_colors.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/models/slider_model.dart';
import 'package:graphql/client.dart';

class GetSliders {
  static Future<List<SlidersModel>?> request(int type) async {
    final HttpLink httpLink = HttpLink(
      Configs.graphql,
    );
    GraphQLClient client = GraphQLClient(link: httpLink, cache: GraphQLCache());
    final QueryOptions options = QueryOptions(
      document: gql(Queries.sliders),
      variables: {'type': type},
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      Helper.log("Erorr sliders ${result.exception}", color: DebugColor.red);
    } else {
      List data = result.data!["sliders"];
      List<SlidersModel> sliders =
          data.map((e) => SlidersModel.fromJson(e)).toList();
      Helper.log("successfully sliders data ${result.data}",
          color: DebugColor.green);
      Helper.log("successfully sliders model $sliders",
          color: DebugColor.yellow);
      return sliders;
    }
    return null;
  }
}
