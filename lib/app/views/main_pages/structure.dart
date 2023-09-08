import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/nav_bar/nav_bar.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/router/app_route.dart';
import 'account/account.dart';
import 'account/support/widget/support_body.dart';
import 'handler/structure_handler.dart';
import 'home/home.dart';
import 'provider/calculator.dart';
import 'recipients/recipients.dart';
import 'settings/structure_kit.dart';
import 'transfers/transfers.dart';

/// Structure pages [Pages]
enum Pages { home, transfers, recipients, settings, support }

class Structure extends StatefulWidget {
  const Structure({this.query = const <String, String>{}, super.key});

  final Map<String, String> query;

  @override
  State<Structure> createState() => _StructureState();
}

class _StructureState extends State<Structure> {
  late AppLocalizations arb;
  late int _index;

  @override
  void initState() {
    super.initState();

    _index = int.parse(widget.query['i'] ?? '0');
    Global.pageCtrl = PageController(initialPage: _index);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => StructureHandler.onWillPop(),
      child: GestureDetector(
        onTap: () => Helper.unFocusCursor(context),
        child: Scaffold(
          appBar: AutoAppBar(
            bGColor: Theme.of(context).cardColor,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            titleReplacement: StructureKit(pageIndex: _index).title(context),
            actions: StructureKit(pageIndex: _index).actions(context),
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: Global.pageCtrl,
            onPageChanged: (int page) => setState(() => _index = page),
            children: const <Widget>[
              Home(),
              Transfers(),
              Recipients(),
              Account(),
              SupportBody(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Visibility(
            visible: !context.select((Calculator c) => c.isLoading),
            child: StructureKit(pageIndex: _index).floatingBottom(context),
          ),
          bottomNavigationBar: NavBar(
            selectedIndex: _index,
            showElevation: false,
            onItemSelected: (int i) {
              if (Global.appSettings.token.isEmpty &&
                  i >= Pages.transfers.index) {
                context.push('/${AppRoute.logIn}');
                return;
              } else {
                if (i == _index) return;

                _index = i;
                Global.pageCtrl.jumpToPage(i);
              }
            },
            items: <NavBarItem>[
              NavBarItem(
                icon: const HeroIcon(HeroIcons.home),
                title: arb.home,
              ),
              NavBarItem(
                icon: const HeroIcon(HeroIcons.creditCard),
                title: arb.transfers,
              ),
              NavBarItem(
                icon: const HeroIcon(HeroIcons.users),
                title: arb.recipients,
              ),
              NavBarItem(
                icon: const HeroIcon(HeroIcons.cog6Tooth),
                title: arb.settings,
              ),
              NavBarItem(
                icon: const Icon(LineIcons.headset),
                title: arb.support,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
