import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';

import 'components/nav_button.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Container(
      height: 78,
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).highlightColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NavButton(title: arb!.home, icon: HeroIcons.home, page: 0, index: i),
          NavButton(
            title: arb.transfers,
            icon: HeroIcons.creditCard,
            page: 1,
            index: i,
          ),
          NavButton(
            title: arb.recipients,
            icon: HeroIcons.users,
            page: 2,
            index: i,
          ),
          NavButton(
            title: arb.settings,
            icon: Platform.isIOS ? HeroIcons.cog : HeroIcons.cog6Tooth,
            page: 3,
            index: i,
          ),
        ],
      ),
    );
  }
}
