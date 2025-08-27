import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amana_send/localization/app_localizations.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/app/widgets/vertical_fade.dart';
import '/graphql/api/reset_password.dart';
import '/helper/helper.dart';
import 'components/pin_form.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.mobile});

  final String mobile;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late AppLocalizations? arb;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode pinNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  final TextEditingController pin = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final LoadingButtonController buttonCtrl = LoadingButtonController();

  void message() => Helper.banner(arb!.codeSuccessfullySentKindlyWait);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => message());
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    pin.dispose();
    super.dispose();
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
          appBar: AutoAppBar(title: arb!.resetPassword),
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
                  TextX(
                    arb!.enterOTPVerificationCodeToResetYourPassword,
                  ),
                  const SizedBox(height: 25),
                  PinForm(
                    focusNode: pinNode,
                    pin: pin,
                    nextFiledNode: passwordNode,
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextFieldX(
                      focusNode: passwordNode,
                      controller: password,
                      hint: arb!.password,
                      type: TextInputType.visiblePassword,
                      padding: const EdgeInsets.only(top: 8),
                      maxLines: 1,
                      input: [LengthLimitingTextInputFormatter(50)],
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      onChanged: (String? v) =>
                          TextFieldValidator.latin(context, password),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextFieldX(
                      onSubmitted: (String? v) => _submit(),
                      controller: confirmPassword,
                      hint: arb!.confirmPassword,
                      type: TextInputType.visiblePassword,
                      padding: const EdgeInsets.only(top: 8),
                      maxLines: 1,
                      input: [LengthLimitingTextInputFormatter(50)],
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      onChanged: (String? v) =>
                          TextFieldValidator.latin(context, confirmPassword),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: RoundedLoadingButton(
                      controller: buttonCtrl,
                      animateOnTap: false,
                      onPressed: () => _submit(),
                      child: VerticalFade(
                        child: TextX(
                          arb!.savePassword,
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

    if (password.text.length < 8) {
      Helper.bannerWarning(arb!.newPasswordMustContainAtLeastEightLetters);
      return;
    }

    if (password.text != confirmPassword.text) {
      Helper.bannerWarning(arb!.newPasswordAndConfirmPasswordDoesNotMatch);
      return;
    }

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    buttonCtrl.start();
    ResetPasswordAPI(
      context,
      buttonCtrl,
      mobile: widget.mobile,
      pinNode: pinNode,
      code: pin,
      newPassword: password.text,
      confirmPassword: confirmPassword.text,
    ).request();
  }
}
