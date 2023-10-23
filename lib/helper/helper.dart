import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/dark_colors.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/dialogs/message.dart';
import '/app/widgets/text/text_x.dart';
import '/configs/configs.dart';
import '/global/variables.dart';
import '/models/recipient.dart';
import '/models/server_app_version.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import 'debug_colors.dart';

class Helper {
  static AppLocalizations? _arb;
  static ServerAppVersion serverAppVersion = ServerAppVersion();

  static void log(dynamic text, {DebugColor color = DebugColor.white}) {
    if (kDebugMode) {
      switch (color) {
        case DebugColor.black:
          print('\x1B[30m$text\x1B[0m');
          break;
        case DebugColor.green:
          print('\x1B[32m$text\x1B[0m');
          break;
        case DebugColor.yellow:
          print('\x1B[33m$text\x1B[0m');
          break;
        case DebugColor.blue:
          print('\x1B[34m$text\x1B[0m');
          break;
        case DebugColor.magenta:
          print('\x1B[35m$text\x1B[0m');
          break;
        case DebugColor.cyan:
          print('\x1B[36m$text\x1B[0m');
          break;
        case DebugColor.white:
          print('\x1B[37m$text\x1B[0m');
          break;
        case DebugColor.red: // bright red
          print('\x1B[91m$text\x1B[0m');
          break;
        case DebugColor.brightGreen:
          print('\x1B[92m$text\x1B[0m');
          break;
        case DebugColor.brightYellow:
          print('\x1B[93m$text\x1B[0m');
          break;
        case DebugColor.brightBlue:
          print('\x1B[94m$text\x1B[0m');
          break;
        default:
          print('\x1B[35m$text\x1B[0m');
      }
    }
  }

  static void debugger(dynamic text) {
    if (kDebugMode) print('\x1B[37mREQUEST: ${Configs.graphql}/$text\x1B[0m');
  }

  static void debug(String title, dynamic text) {
    if (kDebugMode) print('\x1B[37m$title:\x1B[0m \x1B[92m$text\x1B[0m');
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static ImageProvider image(String url) => CachedNetworkImageProvider(url);
  static ImageProvider file(String path) => FileImage(File(path));

  static void unFocusCursor(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  static String priced(
    double amount, {
    bool currency = true,
    String currencyCode = 'USDT',
  }) {
    final double fraction = (amount % 1);
    final int fixed = fraction != 0 ? 2 : 0;
    final String price = currency
        ? '$currencyCode ${amount.toStringAsFixed(fixed)}'
        : amount.toStringAsFixed(fixed);
    return price;
  }

  static void snack(
    String text, {
    Color? background,
    Color? statusColor,
    TextStyle? textStyle,
    int seconds = 15,
    EdgeInsets? margin,
    double? elevation,
    Widget? action,
  }) {
    final BuildContext _ = Global.key.currentContext!;
    Global.snackKey.currentState?.removeCurrentSnackBar();
    Global.snackKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status border.
            Container(
              height: 12,
              width: MediaQuery.of(_).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _.isDarkMode ? DarkColors.third : MainColors.color2,
                    statusColor ??
                        (_.isDarkMode ? DarkColors.sec : MainColors.color6),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),

            // Draggable divider.
            Center(
              child: Container(
                height: 6,
                width: 30,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  color: Theme.of(_).dividerColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Content message.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              child: TextX(
                text,
                style: textStyle ?? Theme.of(_).textTheme.bodyMedium,
              ),
            ),
            if (action != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: action,
              )
          ],
        ),
        padding: EdgeInsets.zero,
        margin: margin,
        elevation: elevation,
        backgroundColor: background,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static void banner(
    String text, {
    Color? background,
    Color? textColor,
    HeroIcons? leadingIcon,
    Color? leadingIconColor,
    HeroIcons? actionIcon,
    Color? actionIconColor,
    int duration = 99,
  }) {
    Global.snackKey.currentState?.removeCurrentMaterialBanner();
    Global.snackKey.currentState?.showMaterialBanner(
      MaterialBanner(
        leading: HeroIcon(
          leadingIcon ?? HeroIcons.chatBubbleOvalLeftEllipsis,
          color: leadingIconColor,
          size: 30,
        ),
        onVisible: () => Future.delayed(Duration(seconds: duration), () {
          Global.snackKey.currentState?.hideCurrentMaterialBanner();
        }),
        content: TextX(
          text,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: background,
        // forceActionsBelow: true,

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Global.snackKey.currentState?.hideCurrentMaterialBanner();
            },
            child: HeroIcon(
              actionIcon ?? HeroIcons.xMark,
              size: 20,
              color: actionIconColor,
            ),
          )
        ],
      ),
    );
  }

  static void bannerWarning(
    String text, {
    Color? background,
    Color? textColor,
    HeroIcons? leadingIcon,
    HeroIcons? closeIcon,
    Color? leadingIconColor,
    Color? closeIconColor,
    Widget? action,
    int duration = 99,
  }) {
    Global.snackKey.currentState?.removeCurrentMaterialBanner();
    Global.snackKey.currentState?.showMaterialBanner(
      MaterialBanner(
        leading: HeroIcon(
          leadingIcon ?? HeroIcons.exclamationTriangle,
          color: leadingIconColor ?? MainColors.color2,
          size: 30,
        ),
        content: TextX(
          text,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: background,
        // forceActionsBelow: true,

        actions: <Widget>[
          if (action != null) action,
          TextButton(
            onPressed: () {
              Global.snackKey.currentState?.hideCurrentMaterialBanner();
            },
            child: HeroIcon(
              closeIcon ?? HeroIcons.xMark,
              size: 20,
              color: closeIconColor,
            ),
          ),
        ],
      ),
    );
  }

  static void bannerError(String text) {
    Global.snackKey.currentState?.removeCurrentMaterialBanner();
    Global.snackKey.currentState?.showMaterialBanner(
      MaterialBanner(
        leading: const HeroIcon(
          HeroIcons.exclamationTriangle,
          color: MainColors.color2,
          size: 30,
        ),
        content: TextX(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MainColors.red,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Global.snackKey.currentState?.hideCurrentMaterialBanner();
            },
            child: const HeroIcon(
              HeroIcons.xMark,
              size: 20,
              color: Colors.white60,
            ),
          )
        ],
      ),
    );
  }

  static void toast(
    String text, {
    Color bgColor = Colors.blueGrey,
    Color? textColor,
    double? fontSize,
    ToastGravity gravity = ToastGravity.CENTER,
    int timeInSecForIosWeb = 8,
    Toast toastLength = Toast.LENGTH_LONG,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: text,
      gravity: gravity,
      fontSize: fontSize,
      textColor: textColor,
      backgroundColor: bgColor,
      timeInSecForIosWeb: timeInSecForIosWeb,
      toastLength: toastLength,
    );
  }

  static String getRecipientName(RecipientModel recipient) {
    String name = '';

    if (recipient.firstName.isNotEmpty) name = recipient.firstName;
    if (recipient.lastName.isNotEmpty) name += ' ${recipient.lastName}';

    return name;
  }

  static List<String> receiveType(BuildContext context) {
    _arb = AppLocalizations.of(context);
    return <String>[
      _arb!.cashPickUp, // id: 0
      _arb!.mobileWallet, // id: 1
      _arb!.bankTransfer, // id: 2
    ];
  }

  static Map<String, dynamic> userVerify(
    int status, {
    bool returnSnack = false,
    bool navigate = false,
    bool showDialog = false,
  }) {
    final BuildContext context = Global.key.currentContext!;
    _arb = AppLocalizations.of(context);

    String verifyStatus = _arb!.verifyAccount;
    Color verifyColor = MainColors.red;

    Global.snackKey.currentState?.hideCurrentSnackBar();
    switch (status) {
      case -1:
        if (navigate) context.push('/${AppRoute.verifyAccount}');

        verifyStatus = _arb!.verifyAccount;
        verifyColor = MainColors.red;
        break;

      case 0:
        verifyStatus = _arb!.verificationInProcess;
        verifyColor = Colors.orange;

        if (returnSnack) {
          Helper.snack(
            _arb!
                .accountVerificationInProcessOnceAccountIsVerifiedYouWillBeAbleToTransferMoneyWorldwide,
            seconds: 99,
            statusColor: Colors.orange,
          );
        }
        break;

      case 1:
        verifyStatus = _arb!.verified;
        verifyColor = Colors.green;

        if (returnSnack) {
          snack(
            '✅  ${_arb!.verifiedAccount}  🎉',
            statusColor: MainColors.color1,
          );
        }
        break;

      case 2:
        if (navigate) context.push('/${AppRoute.verifyAccount}');

        verifyStatus = _arb!.verificationFailed;
        verifyColor = Colors.orange;

        if (showDialog) {
          MessageDialog(
            UserModel.get.userNote,
            action: () => context.push('/${AppRoute.verifyAccount}'),
            actionTitle: _arb!.verifyAccount,
          ).show();
        }
        break;
    }

    return {'status': verifyStatus, 'color': verifyColor};
  }
}
