import 'package:amana_send/app/views/main_pages/home/widgets/choose_digital_currency_roller.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/tools/language/lang_picker.dart';
import '/app/views/notifications/provider/notifications_state.dart';
import '/app/widgets/blurry_container.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/text/text_x.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import '/services/lang_service.dart';
import '/services/tutorial_service.dart';

class StructureKit {
  StructureKit({required this.pageIndex});

  static AppLocalizations? _arb;

  int pageIndex;

  Widget title(BuildContext context) {
    _arb = AppLocalizations.of(context);
    final UserModel user = Database().getUser;

    Widget title = const SizedBox.shrink();
    switch (pageIndex) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/icon.png', height: 35),
            const SizedBox(
              height: kTextTabBarHeight - 10,
              width: 20,
              child: VDivider(),
            ),
            TextX(
              Global.appSettings.token.isEmpty ? _arb!.welcome : _arb!.hello,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            if (user.firstName.isNotEmpty)
              Flexible(
                child: TextX(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        );

      case 1:
        return title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextX(
              _arb!.transfersHistory,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextX(
              _arb!.allTransfers,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      case 2:
        return title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextX(
            //   _arb!.myRecipients,
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
            TextX(
              _arb!.recipientsList,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        );

      case 3:
        return title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextX(
              _arb!.settings,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextX(
              _arb!.editProfile,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      case 4:
        return title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextX(
              _arb!.support,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextX(
              _arb!.contactSupportTeam,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );

      default:
        title;
    }
    return title;
  }

  List<Widget> actions(BuildContext context) {
    _arb = AppLocalizations.of(context);
    Calculator state = Provider.of<Calculator>(context, listen: true);

    List<Widget> actions = <Widget>[];
    switch (pageIndex) {
      case 0:
        return actions = <Widget>[
          Visibility(
            visible: Global.appSettings.token.isEmpty,
            replacement: Row(children: [
              state.icon != ""
                  ? IconButton(
                      onPressed: () => showDigitalCurrencies(context),
                      icon: Image.network(state.icon,
                          height: 23,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox()))
                  : const SizedBox(),
              IconButton(
                onPressed: () => Tutorial(context, show: true).showTutorial(),
                icon: const HeroIcon(HeroIcons.questionMarkCircle),
              ),
              IconButton(
                onPressed: () => context.push('/${AppRoute.notifications}'),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const HeroIcon(HeroIcons.bell),
                    Positioned(
                      left: LangService.isAR() ? null : -12,
                      right: LangService.isAR() ? -12 : null,
                      top: -10,
                      child: Badge.count(
                        count: context.watch<NotificationsState>().count,
                        isLabelVisible:
                            context.watch<NotificationsState>().count > 0,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            child: Row(
              children: [
                state.icon != ""
                    ? IconButton(
                        onPressed: () => showDigitalCurrencies(context),
                        icon: Image.network(
                          state.icon,
                          height: 23,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ))
                    : const SizedBox(),
                IconButton(
                  onPressed: () => Tutorial(context, show: true).showTutorial(),
                  icon: const HeroIcon(HeroIcons.questionMarkCircle),
                ),
                const LangPicker(),
              ],
            ),
          ),
        ];
      case 1:
        return actions = <Widget>[
          GeneralWidgets.notificationBell(context),
          IconButton(
            onPressed: () => context.push('/${AppRoute.support}'),
            icon: const HeroIcon(HeroIcons.informationCircle),
          ),
        ];
      case 2:
        return actions = <Widget>[
          Button(
            () => context.pushNamed(
              AppRoute.addRecipient,
              pathParameters: <String, String>{'recipient': 'null'},
            ),
            color: Colors.transparent,
            TextX(
              _arb!.addNewRecipient.toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ];
      case 3:
        return actions = <Widget>[GeneralWidgets.notificationBell(context)];
      case 4:
        return actions = <Widget>[GeneralWidgets.notificationBell(context)];

      default:
        actions;
    }
    return actions;
  }

  Widget floatingBottom(BuildContext context) {
    _arb = AppLocalizations.of(context);
    final UserModel user = Database().getUser;

    Widget bottom = const SizedBox.shrink();

    Widget verify({String? title, Color? color}) => BlurryContainer(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: (color ?? MainColors.red).withOpacity(0.2),
          radius: 100,
          child: FloatingActionButton.extended(
            onPressed: () => context.push('/${AppRoute.verifyAccount}'),
            elevation: 0,
            icon: HeroIcon(
              HeroIcons.shieldExclamation,
              color: color ?? Colors.red,
            ),
            label: TextX(
              title ?? _arb!.verifyAccount.toUpperCase(),
              style: TextStyle(color: color ?? Colors.red, fontSize: 12),
            ),
            backgroundColor: Colors.transparent,
          ),
        );

    switch (user.verified) {
      case -1:
        if (Global.appSettings.token.isNotEmpty) bottom = verify();
        break;

      case 2:
        bottom = verify(
          title: _arb!.verificationFailed.toUpperCase(),
          color: Colors.orange,
        );
        break;
    }

    return bottom;
  }
}
