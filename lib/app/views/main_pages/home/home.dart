import 'dart:async';
import 'package:amana_send/app/views/main_pages/home/widgets/install_app_banner.dart';
import 'package:universal_html/html.dart' as html;
import 'package:amana_send/app/views/main_pages/home/widgets/sliders.dart';
import 'package:amana_send/app/widgets/dialogs/settings.dart';
import 'package:amana_send/graphql/api/get_payments.dart';
import 'package:amana_send/models/currency.dart';
import 'package:amana_send/models/payment_method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
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
  late bool showInstall;
  late Calculator calculator;
  PaymentMethodModel getPaymentMethod = PaymentMethodModel();
  String selection = '';
  late bool isAr;

  /// Listener attached to GoRouter's delegate so we can react to route
  /// changes (e.g. user popping back to Home) and re-enable the install banner.
  late final VoidCallback _routeListener;

  final EdgeInsets padding = const EdgeInsets.fromLTRB(8, 0, 8, 0);

  /// Returns true only when running on the web **and** the browser is Safari.
  bool get _isSafari {
    if (!kIsWeb) return false;
    final ua = html.window.navigator.userAgent ?? '';
    return ua.contains('Safari') &&
        !ua.contains('Chrome') &&
        !ua.contains('Chromium');
  }

  Future<void> getResources() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => LoadingDialog().show());
    final calculater = Provider.of<Calculator>(context, listen: false);
    // call data:---------------------------------------------------------------
    GetPaymentMethods.request();
    GetMetadata.request();
    calculater.getSliders(0);
    calculater.moveSlider();
    if (Global.appSettings.token.isNotEmpty) {
      GetNotifications.request();
      GetRecipients.request();
      await GetUserMeta.request();
    }
    await GetCountriesAPI.request();
    // -------------------------------------------------------------------------

    if (context.mounted && Global.isAnyDialogOpen(context)) {
      LoadingDialog.dismiss();
    }

    // Check user verification status
    Helper.userVerify(
      UserModel.get.verified,
      showDialog: true,
      returnSnack: UserModel.get.verified == 0,
    );

    PopupService.show();
  }

  Timer? debounceTimer;
  @override
  void initState() {
    super.initState();
    calculator = Provider.of<Calculator>(context, listen: false);
    calculator.agentsVisibility(true);

    // Listen to route changes: whenever the user navigates back to the home
    // route ('/'), re-enable the install banner. This covers the case where
    // the user pushes a child route (e.g. SendHub) and then pops back.
    final goRouter = GoRouter.of(context);
    _routeListener = () {
      final uri =
          goRouter.routerDelegate.currentConfiguration?.uri.toString() ?? '';
      if (uri == '/' || uri.isEmpty) {
        calculator.changeInstall(true);
      }
    };
    goRouter.routerDelegate.addListener(_routeListener);

    getResources().whenComplete(() {
      user = Database().getUser;
      // showInstall = Database().getInstall;
      // calculator.changeInstall(true);

      if (mounted) {
        getPaymentMethod = Database().getPaymentMethod;
        calculator.setPaymentMethodID(getPaymentMethod);
      }
    });
    // Future.delayed( const Duration(seconds: 2),()async{
    //  await getResources();
    //  Helper.log("timmmmmmmmmmming =======>>>>>>>>>> 5 secounds");
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   final calculate=Provider.of<Calculator>(context,listen: false);
    //   calculate.getAgents(calculate.providersNew);
    // });
    // });
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    user = Database().getUser;
    isAr = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the router listener and any active debounce timers.
    try {
      final goRouter = GoRouter.of(context);
      goRouter.routerDelegate.removeListener(_routeListener);
    } catch (_) {
      // Widget was already unmounted — ignore.
    }
    debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(builder: (context, state, child) {
      if (state.paymentMethodName == "") {
        return Column(
          children: [
            // if (state.showInstall && _isSafari)
            //   InstallAppBanner(arb: arb, state: state),
            // if (state.showInstall && _isSafari) const SizedBox(height: 20),
            CurrencyWidget(arb: arb, controller: state),
          ],
        );
      }
      // else if(Global.appSettings.token.isNotEmpty){
      //   return Container();
      // }
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
              // Future.delayed(const Duration(seconds: 2),(){
              //   state.getAgents(state.providersNew);
              // });
              state.clearFields();
              state.setCalculateAmount(CalculateAmountModel());
              state.clearAgents();
              // state.setReceiveCity(CityModel());
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
                //  const Sliders(),
//  const SizedBox(height: 20,),
                Padding(
                  key: Tutorial.key7,
                  padding: padding,
                  child: Button(
                    () {
                      state.clearProviderFieldTransfer();
                      state.clearProviderFieldValues();
                      if (Global.appSettings.token.isEmpty) {
                        context.pushNamed('/${AppRoute.logIn}');
                        return;
                      }
                      if (state.sender.text.isNotEmpty &&
                          state.receiver.text.isNotEmpty) {
                        // context.pushNamed(
                        //   AppRoute.sendHub,
                        //   pathParameters: <String, String>{
                        //     'recipient': 'false'
                        //   },
                        // );
                      } else {
                        if (state.sender.text.isNotEmpty) {
                          state.receiver.clear();
                          state.recieverLoading = true;
                          if (debounceTimer?.isActive ?? false) {
                            debounceTimer?.cancel();
                          }
                          debounceTimer = Timer(
                              const Duration(milliseconds: 1000), () async {
                            state.setPrice(state.sender.text);
                            FocusScope.of(context).unfocus();
                          });
                        }
                        if (state.receiver.text.isNotEmpty) {
                          state.senderLoading = true;
                          state.sender.clear();
                          if (debounceTimer?.isActive ?? false) {
                            debounceTimer?.cancel();
                          }
                          debounceTimer = Timer(
                              const Duration(milliseconds: 1000), () async {
                            state.setPrice(state.receiver.text);
                            FocusScope.of(context).unfocus();
                          });
                        }
                      }

                      if (state.sender.text.isEmpty &&
                          state.receiver.text.isEmpty) {
                        return Helper.snack(arb.pleaseEnterSendingAmount);
                      }

                      if (state.paymentMethodName == "") {
                        return Helper.snack(arb.pleaseChooseCurrency);
                      }

                      if (user.level.maxAmount <
                          double.parse(state.sender.text)) {
                        return Helper.snack(
                          '${arb.yourMaxLevelSendingAmountIs} ${Tools.nicePrice(user.level.maxAmount)} ${state.paymentMethodName}.\n${arb.toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount}',
                          action: Button(
                            () => Helper.launchURL('https://t.me/AMANA_SEND'),
                            width: MediaQuery.of(context).size.width,
                            TextX(arb.contactSupportTeam),
                          ),
                        );
                      }

                      if (double.parse(state.receiver.text) <
                          state.receiverAgent.minAmount) {
                        return Helper.snack(
                          '${arb.minimumReceivingLimitToThisPickUpPointIs} ${Tools.nicePrice(state.receiverAgent.minAmount)} ${state.sendUSD ? 'USD' : state.receiverCountry.currency.code}',
                        );
                      }
                      if (double.parse(state.receiver.text) >
                          state.receiverAgent.maxAmount) {
                        return Helper.snack(
                          '${arb.maximumReceivingLimitToThisPickUpPointIs} ${Tools.nicePrice(state.receiverAgent.maxAmount)} ${state.sendUSD ? 'USD' : state.receiverCountry.currency.code}',
                        );
                      }

                      if (state.receiverCity.id == 0) {
                        return Helper.snack(arb.selectCity);
                      }

                      Global.snackKey.currentState?.hideCurrentSnackBar();
                      // state.roundReceiverAmount();
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
                const SizedBox(
                  height: 7,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Sliders(),
                ),
                const SizedBox(
                  height: 20,
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
