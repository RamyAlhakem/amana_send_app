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
import 'widgets/send_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppLocalizations? _arb;
  late UserModel user;

  Future<void> getResources() async {
    GetMetadata.request();
    if (Global.appSettings.token.isNotEmpty) {
      GetNotifications.request();
      GetRecipients.request();
      await GetUserMeta.request();
    }
    await GetCountriesAPI.request().whenComplete(
      () => ServerAppVersion.isUpdate(),
    );
  }

  @override
  void initState() {
    super.initState();
    user = Database().getUser;
    WidgetsBinding.instance.addPostFrameCallback((_) => LoadingDialog().show());
    getResources().whenComplete(() => LoadingDialog.dismiss());
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    user = Database().getUser;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Calculator>(builder: (_, state, child) {
      child = Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: Visibility(
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
            replacement: const HomeLoader(),
            child: RefreshIndicator(
              onRefresh: () async {
                await getResources();
                state.setPrice(state.sender.text, state.receiverCountry);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Visibility(
                  //       visible: Global.appSettings.token.isEmpty &&
                  //           state.sendCountries.isNotEmpty,
                  //       child: CountryRoller(title: _arb!.sendCountries),
                  //     ),
                  //     if (Global.appSettings.token.isEmpty)
                  //       const SizedBox(width: 8),
                  //     Visibility(
                  //       visible: state.receiveCountries.isNotEmpty,
                  //       child: CountryRoller(
                  //         title: _arb!.receiverCountries,
                  //         send: false,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // "You send", "Receiver gets"
                  const SendFormFields(),

                  Button(
                    () {
                      if (Global.appSettings.token.isEmpty) {
                        context.pushNamed('/${AppRoute.logIn}');
                        return;
                      }

                      if (state.sender.text.isEmpty) {
                        return Helper.snack(_arb!.pleaseEnterSendingAmount);
                      }

                      if (user.level.maxAmount < 0 &&
                          user.level.maxAmount <
                              double.parse(state.sender.text)) {
                        return Helper.snack(
                          "Your max level sending amount is ${user.level.maxAmount} ${user.country.currency.code}\n To increase your max level amount, Kindly contact our support team",
                          action: SnackBarAction(
                            label: _arb!.contactSupportTeam,
                            onPressed: () => Helper.launchURL(
                              'https://api.whatsapp.com/send/?phone=+442622&text&app_absent=0',
                            ),
                          ),
                        );
                      }

                      if (double.parse(state.receiver.text) <
                          state.receiverCountry.minAmount) {
                        return Helper.snack(
                          '${_arb!.minimumReceivingLimitToThisCountryIs} ${state.receiverCountry.minAmount} ${state.receiverCountry.currency.code}',
                        );
                      }
                      if (double.parse(state.receiver.text) >
                          state.receiverCountry.maxAmount) {
                        return Helper.snack(
                          '${_arb!.maximumReceivingLimitToThisCountryIs} ${state.receiverCountry.maxAmount} ${state.receiverCountry.currency.code}',
                        );
                      }

                      if (state.receiveType == 0) {
                        return Helper.snack(_arb!.pleaseSelectReceiveType);
                      }

                      Global.snackKey.currentState?.hideCurrentSnackBar();

                      context.pushNamed(
                        AppRoute.sendHub,
                        pathParameters: <String, String>{'recipient': 'false'},
                      );
                    },
                    height: 50,
                    TextX(
                      _arb!.startSendingMoney.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      return child;
    });
  }
}
