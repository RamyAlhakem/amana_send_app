import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/captcha.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/vertical_fade.dart';
import '/global/variables.dart';
import '/graphql/api/resend_otp.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
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

  final TextStyle formInputStyle = const TextStyle(color: Colors.white);

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.65),
          appBar: AutoAppBar(
            title: arb!.forgotPassword.substring(0, 15),
            titleStyle: formInputStyle,
            flexibleSpace: const SizedBox(),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Global.brightnessLight(),
              statusBarIconBrightness: Global.brightnessLight(),
            ),
          ),
          body: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 20),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  GeneralWidgets.loginLogo(context),
                  TextX(arb!.weWillSendResetPassword, style: formInputStyle),
                  const SizedBox(height: 40),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextFieldX(
                      controller: _pr.email,
                      hint: arb!.email,
                      type: TextInputType.emailAddress,
                      labelStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white38,
                              ),
                      style: formInputStyle,
                      onSubmitted: (_) => _submit(),
                      isValidateEmail: true,
                    ),
                  ),
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

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    buttonCtrl.start();
    if (AppMetadata.get.appForgetPasswordCaptcha) {
      return CaptchaDialog(
        onSubmit: (value) => ResendOTP(
          email: _pr.email.text,
          buttonCtrl: buttonCtrl,
        ).request(),
      ).show();
    } else {
      ResendOTP(email: _pr.email.text, buttonCtrl: buttonCtrl).request();
    }
  }
}
