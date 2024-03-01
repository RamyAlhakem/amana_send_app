import 'package:graphql/client.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/configs/configs.dart';
import '/graphql/explorer/queries.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/models/server_app_version.dart';

class GetMetadata {
  static Future<void> request() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      Configs.appName = packageInfo.appName;
      Configs.packageName = packageInfo.packageName;
      Configs.version = packageInfo.version;
      Configs.buildNumber = packageInfo.buildNumber;
    });

    Helper.debugger('metaData');

    GraphQL.client()
        .query(QueryOptions(document: gql(Queries.metadata)))
        .then((result) {
      if (result.data != null) {
        Helper.debug('metaData', '${result.data}');

        return _result(result.data!);
      } else {
        if (result.exception != null) {
          Helper.log(result.exception!.graphqlErrors, color: DebugColor.red);

          if (result.exception!.graphqlErrors.isEmpty) {
            Helper.toast('Error, Something went wrong, Please try again later');
          }

          return _error(result.exception!.graphqlErrors);
        }
      }
    });
  }

  static void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('metaData')) {
      AppMetadata.get = AppMetadata.fromJson(data['metaData']);
      ServerAppVersion.get = ServerAppVersion.fromJson(data['metaData']);
      ServerAppVersion.isUpdate();
      if (AppMetadata.get.androidUrl.isNotEmpty) {
        Configs.googleStore = AppMetadata.get.androidUrl;
      }
      if (AppMetadata.get.appStoreUrl.isNotEmpty) {
        Configs.appleStore = AppMetadata.get.appStoreUrl;
      }
      // Helper.log('google play: ====>>${Configs.googleStore}');
      // Helper.log('appleStore: ====>>${Configs.appleStore}');
    }
  }

  static void _error(List<GraphQLError> errors) async {
    if (errors.isNotEmpty) {
      switch (errors.first.extensions?['code']) {
        // case 422:
        //   break;
      }
    }
  }
}
