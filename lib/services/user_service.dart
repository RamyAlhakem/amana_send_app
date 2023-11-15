import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/views/notifications/provider/notifications_state.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/graphql/api/log_out.dart';
import '/models/user.dart';
import '/models/user_base.dart';

class UserService {
  //
  // Check user's freshness from local storage.
  static Future<bool> isFresh() async {
    final UserBase user = Database().getUserBase;

    final bool isFreshUser = user.isFreshUser == null;

    if (isFreshUser) {
      user.isFreshUser = false;
      Database().setUserBase = user;
    }

    return isFreshUser;
  }

  static int countTransfers({int count = 0}) {
    final UserBase user = Database().getUserBase;
    user.transfersSent = user.transfersSent + count;

    Database().setUserBase = user;
    return user.transfersSent;
  }

  // Saves user's information by loaded data from server
  static Future<String> saveUser() async {
    UserModel data = UserModel.get; // user data on server side.

    if (data.token.isNotEmpty) Database().setUser = data;

    return Database().getUser.token;
  }

  static Future<void> clearUser(BuildContext context, {int page = 0}) async {
    Global.snackKey.currentState?.hideCurrentMaterialBanner();

    LogOutAPI.request();
    context.read<NotificationsState>().clearNotifications();
    context.read<RecipientsState>().clearRecipients();
    context.read<TransfersState>().clearTransfers();

    // clear user cached loaded data from server and device local storage.
    UserModel.get = UserModel();
    await Database.clearUser();

    // refresh app settings to fresh user
    await Global.appSettings.loadSettings().whenComplete(() {
      // take user back to main page (home)
      if (Global.pageCtrl.hasClients) Global.pageCtrl.jumpToPage(page);
    });
  }
}
