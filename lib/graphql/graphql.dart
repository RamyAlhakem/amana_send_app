import 'package:graphql/client.dart';

import '/configs/configs.dart';
import '/global/variables.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/services/lang_service.dart';

class GraphQL {
  static AuthLink _authLink() {
    final String token = Global.appSettings.token;
    Helper.log('Bearer $token', color: DebugColor.yellow);
    return AuthLink(getToken: () async => 'Bearer $token');
  }

  static GraphQLClient client({Store? store}) {
    return GraphQLClient(
      link: _authLink().concat(
        HttpLink(
          Configs.graphql,
          defaultHeaders: {'Accept-Language': '${LangService.locale}'},
        ),
      ),
      cache: GraphQLCache(store: store ?? InMemoryStore()),
    );
  }
}
