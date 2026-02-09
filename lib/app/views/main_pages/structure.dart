import 'package:amana_send/database/injector.dart';
import 'package:amana_send/models/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
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
import 'home/home.dart';
import 'provider/calculator.dart';
import 'recipients/recipients.dart';
import 'settings/structure_kit.dart';
import 'transfers/transfers.dart';

/// Structure pages [Pages]
enum Pages { home, transfers, recipients, settings, support }

class Structure extends StatefulWidget {
  const Structure({super.key});

  @override
  State<Structure> createState() => _StructureState();
}

class _StructureState extends State<Structure> {
  late AppLocalizations arb;
  late int _index;
  //    Future<void> getResources() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) => LoadingDialog().show());

  //   // call data:---------------------------------------------------------------
  //   GetPaymentMethods.request();
  //   GetMetadata.request();
  //   if (Global.appSettings.token.isNotEmpty) {
  //     GetNotifications.request();
  //     GetRecipients.request();
  //     await GetUserMeta.request();
  //   }
  //   await GetCountriesAPI.request();
  //   // -------------------------------------------------------------------------

  //   if (context.mounted && Global.isAnyDialogOpen(context)) {
  //     LoadingDialog.dismiss();
  //   }

  //   // Check user verification status
  //   Helper.userVerify(
  //     UserModel.get.verified,
  //     showDialog: true,
  //     returnSnack: UserModel.get.verified == 0,
  //   );

  //   PopupService.show();
  // }
  PaymentMethodModel getPaymentMethod = PaymentMethodModel();

  @override
  void initState() {
    super.initState();

    _index = Pages.home.index;
    Global.pageCtrl = PageController(initialPage: _index);
    // getResources();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getPaymentMethod = Database().getPaymentMethod;
        Provider.of<Calculator>(context, listen: false)
            .setPaymentMethodID(getPaymentMethod);
      }
    });
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (_index == Pages.home.index) {
        //   final state = Provider.of<Calculator>(context, listen: false);
        //   state.roundReceiverAmount();
        // }
        Helper.unFocusCursor(context);
      },
      child: Scaffold(
        appBar: _index != 1
            ? AutoAppBar(
                bGColor: Theme.of(context).cardColor,
                leading: const SizedBox.shrink(),
                leadingWidth: 0,
                titleReplacement:
                    StructureKit(pageIndex: _index).title(context),
                actions: StructureKit(pageIndex: _index).actions(context),
              )
            : null,
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
        bottomNavigationBar: SafeArea(
          child: NavBar(
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
