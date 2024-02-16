import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/home/widgets/loader.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/loading.dart';
import '/app/widgets/dotted_border/dotted_border.dart';
import '/app/widgets/text/text_x.dart';
import '/database/injector.dart';
import '/global/variables.dart';
import '/graphql/api/get_countries.dart';
import '/graphql/api/get_metadata.dart';
import '/graphql/api/get_notifications.dart';
import '/graphql/api/get_recipients.dart';
import '/graphql/api/get_user.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/models/server_app_version.dart';
import '/models/user.dart';
import '/router/app_route.dart';
import '/services/lang_service.dart';
import '/services/popup_services.dart';
import '/services/tutorial_service.dart';
import '/tools/tools.dart';
import 'widgets/send_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppLocalizations arb;
  late UserModel user;
  String selection = '';
  late bool isAr;

  final EdgeInsets padding = const EdgeInsets.fromLTRB(8, 0, 8, 0);

  Future<void> getResources() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => LoadingDialog().show());

    // call data:---------------------------------------------------------------
    GetMetadata.request();
    if (Global.appSettings.token.isNotEmpty) {
      GetNotifications.request();
      GetRecipients.request();
      await GetUserMeta.request();
    }
    await GetCountriesAPI.request().whenComplete(
      () => ServerAppVersion.isUpdate(),
    );
    // -------------------------------------------------------------------------

    if (context.mounted && Global.isAnyDialogOpen(context)) {
      LoadingDialog.dismiss();
    }

    PopupService.show();

    // Check user verification status
    Helper.userVerify(
      UserModel.get.verified,
      showDialog: true,
      returnSnack: UserModel.get.verified == 0,
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Calculator>(context, listen: false).agentsVisibility(true);
    getResources().whenComplete(() => user = Database().getUser);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    user = Database().getUser;
    isAr = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(builder: (_, state, child) {
      child = Visibility(
        visible: !AppMetadata.get.maintenanceMode,
        replacement: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, kToolbarHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeroIcon(HeroIcons.wrenchScrewdriver, size: 40),
                const SizedBox(height: 10),
                DottedBorder(
                  borderType: BorderType.rRect,
                  radius: const Radius.circular(8),
                  padding: const EdgeInsets.all(8),
                  dashPattern: const [8, 8],
                  color: Theme.of(context).dividerColor,
                  child: Container(
                    decoration: Decorations.note(context),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    width: MediaQuery.of(context).size.width,
                    child: TextX(AppMetadata.get.maintenanceMessage),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Visibility(
          visible: !state.isLoading,
          replacement: Padding(padding: padding, child: const HomeLoader()),
          child: RefreshIndicator(
            onRefresh: () async {
              await getResources();
              state.setPrice(state.sender.text, usd: state.sendUSD);
            },
            child: ListView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.zero,
              children: [
                // Currencies exchange rate price
                // if (state.currencies.isNotEmpty)
                //   CurrenciesNews(currencies: state.currencies),

                // "You send", "Receiver gets"
                Padding(padding: padding, child: const SendFormFields()),

                Padding(
                  key: Tutorial.key7,
                  padding: padding,
                  child: Button(
                    () {
                      if (Global.appSettings.token.isEmpty) {
                        context.pushNamed('/${AppRoute.logIn}');
                        return;
                      }

                      if (state.sender.text.isEmpty) {
                        return Helper.snack(arb.pleaseEnterSendingAmount);
                      }

                      if (user.level.maxAmount <
                          double.parse(state.sender.text)) {
                        return Helper.snack(
                          '${arb.yourMaxLevelSendingAmountIs} ${Tools.nicePrice(user.level.maxAmount)} USDT.\n${arb.toIncreaseYourMaxLevelAmountKindlyContactOurSupportTeam}',
                          action: Button(
                            () => Helper.launchURL('https://t.me/AMANA_CS'),
                            width: MediaQuery.of(context).size.width,
                            TextX(arb.contactSupportTeam),
                          ),
                        );
                      }

                      if (double.parse(state.receiver.text) <
                          state.receiverAgent.minAmount) {
                        return Helper.snack(
                          '${arb.minimumReceivingLimitToThisPickUpPointIs} ${Tools.nicePrice(state.receiverAgent.minAmount)} ${state.receiverCountry.currency.code}',
                        );
                      }
                      if (double.parse(state.receiver.text) >
                          state.receiverAgent.maxAmount) {
                        return Helper.snack(
                          '${arb.maximumReceivingLimitToThisPickUpPointIs} ${Tools.nicePrice(state.receiverAgent.maxAmount)} ${state.receiverCountry.currency.code}',
                        );
                      }

                      if (state.receiverCity.id == 0) {
                        return Helper.snack(arb.selectCity);
                      }

                      Global.snackKey.currentState?.hideCurrentSnackBar();
                      state.roundReceiverAmount();
                      Helper.unFocusCursor(context);
                      context.pushNamed(
                        AppRoute.sendHub,
                        pathParameters: <String, String>{'recipient': 'false'},
                      );
                    },
                    height: 50,
                    TextX(
                      arb.startSendingMoney.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return child;
    });
  }
}
