import 'package:amana_send/app/widgets/dialogs/loading.dart';
import 'package:amana_send/database/injector.dart';
import 'package:amana_send/global/variables.dart';
import 'package:amana_send/graphql/api/get_countries.dart';
import 'package:amana_send/graphql/api/get_metadata.dart';
import 'package:amana_send/graphql/api/get_notifications.dart';
import 'package:amana_send/graphql/api/get_payments.dart';
import 'package:amana_send/graphql/api/get_recipients.dart';
import 'package:amana_send/graphql/api/get_user.dart';
import 'package:amana_send/helper/helper.dart';
import 'package:amana_send/models/payment_method.dart';
import 'package:amana_send/models/user.dart';
import 'package:amana_send/services/popup_services.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/dialogs/settings.dart';
import '/app/widgets/picker_form.dart';
import '/services/lang_service.dart';

class DigitalCurrencyRoller extends StatelessWidget {
  const DigitalCurrencyRoller({
    super.key,
    this.send = false,
    this.width,
    this.borderRadius = 8,
  });

  final bool send;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    return Consumer<Calculator>(builder: (_, state, child) {
      var pickerForm = PickerForm(
        () => showDigitalCurrencies(context),
        hint: arb!.typeOfCurrency,
        value: state.paymentMethodName,
        width: width,
        borderRadius: borderRadius,
        hintIcon: HeroIcon(
          send ? HeroIcons.arrowUpRight : HeroIcons.arrowDownRight,
          size: 15,
        ),
        valueIcon: state.icon.isNotEmpty
            ? Image.network(
                state.icon,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              )
            : null,
        color: Theme.of(context).cardColor,
      );
      child = pickerForm;
      return child;
    });
  }
}

Future<void> showDigitalCurrencies(BuildContext context) {
  final bool isAr = LangService.isAR();
  final AppLocalizations? arb = AppLocalizations.of(context);
  final Calculator state = Provider.of<Calculator>(context, listen: false);
  return SettingsDialog(
    backgroundColor: Colors.grey.withValues(alpha: kIsWeb ? 0.9 : 0),
    onSubmit: null,
    // title: arb?.typeOfCurrency ?? '',
    title: "",
    subTitle: arb?.pleaseChooseCurrency ?? "",
    subTitleStyle: const TextStyle(color: Colors.white, fontSize: 14),
    horizontalPadding: 0,
    content: (_) => Scrollbar(
      interactive: true,
      thumbVisibility: true,
      thickness: 5,
      radius: const Radius.circular(100),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.fromLTRB(isAr ? 30 : 10, 20, isAr ? 10 : 30, 15),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < state.payments.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    PaymentMethodModel payment = state.payments[i];
                    Database().setCurrency = payment;
                    state.setPaymentMethodID(payment);
                    state.setPrice(state.sender.text);
                    SettingsDialog.dismiss();
                    getResources(context);
                  },
                  child: Row(children: [
                    Image.network(
                      state.payments[i].iconUrl,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      state.payments[i].name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
            ],
          ),
        ],
      ),
    ),
  ).show();
}

Future<void> getResources(BuildContext context) async {
  WidgetsBinding.instance.addPostFrameCallback((_) => LoadingDialog().show());

  // call data:---------------------------------------------------------------
  GetPaymentMethods.request();
  GetMetadata.request();
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
