import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:share_plus/share_plus.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/dialogs/language.dart';
import '/app/widgets/dialogs/submit.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/user_avatar.dart';
import '/configs/configs.dart';
import '/database/injector.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import '/services/user_service.dart';
import 'components/account_setting.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late AppLocalizations? _arb;

  UserModel user = UserModel();

  bool notify = false;
  String verifyStatus = '';
  Color verifyColor = MainColors.red;

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    user = Database().getUser;

    verifyStatus = Helper.userVerify(context, user.verified)['status'];
    verifyColor = Helper.userVerify(context, user.verified)['color'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: UserAvatar(size: 40, code: user.country.coCode),
            ),
            TextX(
              user.firstName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextX(user.mobile, textDirection: TextDirection.ltr),
                if (user.country.cities.isNotEmpty)
                  TextX(' / ${user.country.cities.first.name}'),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            color: Theme.of(context).cardColor,
            child: ListView(
              children: [
                const HDivider(),
                AccountSetting(
                  onTap: () => Helper.userVerify(
                    context,
                    user.verified,
                    returnSnack: true,
                    navigate: true,
                  ),
                  icon: HeroIcons.shieldExclamation,
                  title: _arb!.verifyAccount,
                ),
                AccountSetting(
                  onTap: () => context.push('/${AppRoute.editAccount}'),
                  icon: HeroIcons.pencil,
                  title: _arb!.editProfile,
                ),
                AccountSetting(
                  onTap: () => LanguageDialog.change(),
                  icon: HeroIcons.language,
                  title: _arb!.language,
                ),
                const HDivider(),
                // AccountSetting(
                //   onTap: null,
                //   icon: HeroIcons.moon,
                //   title: _arb!.themeMode,
                //   trailing: const ThemePicker(),
                // ),
                AccountSetting(
                  onTap: () => context.push('/${AppRoute.support}'),
                  icon: HeroIcons.questionMarkCircle,
                  title: _arb!.contactSupportTeam,
                ),
                AccountSetting(
                  onTap: () {
                    if (Platform.isAndroid) {
                      Share.share(Configs.googleStore);
                    } else {
                      final box = context.findRenderObject() as RenderBox?;
                      Share.share(
                        Configs.appleStore,
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                    }
                  },
                  icon: HeroIcons.share,
                  title: _arb!.inviteFriends,
                ),
                AccountSetting(
                  onTap: () => SubmitDialog(
                    () => UserService.clearUser(context),
                    content: _arb!.proceedWithLoggingOut,
                  ).show(context),
                  icon: HeroIcons.arrowRightOnRectangle,
                  title: _arb!.logout,
                  trailing: const SizedBox(),
                  iconColor: MainColors.red,
                  textColor: MainColors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
