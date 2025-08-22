import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/captcha.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/vertical_fade.dart';
import '/graphql/api/resend_otp.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import 'components/phone_country_picker.dart';
import 'provider/registration_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late AppLocalizations? arb;
  late RegistrationState _pr;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoadingButtonController buttonCtrl = LoadingButtonController();

  @override
  void initState() {
    super.initState();
    _pr = Provider.of<RegistrationState>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/splash${context.isDarkMode ? '' : '_light'}.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AutoAppBar(title: arb!.forgotPassword.substring(0, 15)),
          body: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 20),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.white12
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  GeneralWidgets.loginLogo(context),
                  TextX(arb!.weWillSendResetPassword),
                  const SizedBox(height: 40),
                  const PhoneCountryPicker(),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: RoundedLoadingButton(
                      controller: buttonCtrl,
                      animateOnTap: false,
                      onPressed: () => _submit(),
                      child: VerticalFade(
                        child: TextX(
                          arb!.send,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_pr.country == null) return Helper.bannerWarning(arb!.selectCountry);

    if (!formKey.currentState!.validate()) return;

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    buttonCtrl.start();
    if (AppMetadata.get.appForgetPasswordCaptcha) {
      await CaptchaDialog(
        onSubmit: (value) => ResendOTP(
          mobile: '+${_pr.country?.phoneCode}${_pr.mobile.text}',
          buttonCtrl: buttonCtrl,
        ).request().whenComplete(() => buttonCtrl.reset()),
      ).show();
      return;
    } else {
      ResendOTP(
        mobile: '+${_pr.country?.phoneCode}${_pr.mobile.text}',
        buttonCtrl: buttonCtrl,
      ).request();
    }
  }
}
