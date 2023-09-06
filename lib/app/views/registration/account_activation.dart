import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/vertical_fade.dart';
import '/graphql/api/authenticate_account.dart';
import '/graphql/api/resend_otp.dart';
import '/helper/helper.dart';
import 'components/count_down.dart';
import 'components/pin_form.dart';

class AccountActivation extends StatefulWidget {
  const AccountActivation(
    this.mobile, {
    super.key,
    this.q = const <String, String>{'reSendOTP': 'false'},
  });

  final String mobile;
  final Map<String, String> q;

  @override
  State<AccountActivation> createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation>
    with TickerProviderStateMixin {
  late AppLocalizations? arb;

  final TextEditingController pin = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode pinNode = FocusNode();

  final LoadingButtonController buttonCtrl = LoadingButtonController();

  int duration = 170;
  late AnimationController ctrl;

  Timer? resendTimer;
  void isTimeOut() {
    if (duration != 0) {
      resendTimer = Timer.periodic(Duration(seconds: duration), (Timer timer) {
        setState(() => duration = 0);
      });
    }
  }

  void message() => Helper.banner(arb!.codeSuccessfullySentKindlyPatience);

  @override
  void initState() {
    super.initState();
    if (widget.q['reSendOTP'] == 'true') {
      ResendOTP(mobile: widget.mobile).request();
    }

    ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );

    ctrl.forward();
    isTimeOut();

    WidgetsBinding.instance.addPostFrameCallback((_) => message());
  }

  @override
  void dispose() {
    pin.dispose();
    pinNode.dispose();
    ctrl.dispose();
    super.dispose();
    resendTimer?.cancel();
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
          appBar: AutoAppBar(title: arb!.verifyMobileNumber),
          body: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 20, 12, 20),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: TextX(
                        arb!.verification,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Center(
                    child: TextX(
                      arb!.enterOTPcodeSentToTheNumber,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextC(
                      widget.mobile,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PinForm(
                    onSubmit: () => _submit(),
                    focusNode: pinNode,
                    pin: pin,
                  ), // OTP form
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: RoundedLoadingButton(
                      controller: buttonCtrl,
                      animateOnTap: false,
                      onPressed: () => _submit(),
                      color: Colors.white70,
                      elevation: 0,
                      child: VerticalFade(
                        child: TextX(
                          arb!.validate,
                          style: const TextStyle(color: MainColors.color1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: TextX(
                      "Didn't receive code?",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: duration != 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: TextX(
                          arb!.youCanRequestAnotherOTPagainWithin,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: duration == 0,
                      replacement: Countdown(
                        animation:
                            StepTween(begin: duration, end: 0).animate(ctrl),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(3),
                        onTap: () => _reSend(),
                        child: Padding(
                          padding: EdgeInsets.only(top: duration != 0 ? 2 : 15),
                          child: TextX(
                            arb!.resendCode,
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _reSend() async {
    ctrl.dispose();
    resendTimer?.cancel();

    if (duration == 0) {
      setState(() => duration = 170);
      ctrl = AnimationController(
        vsync: this,
        duration: Duration(seconds: duration),
      );

      ctrl.forward();
      isTimeOut();

      Helper.toast(arb!.codeSuccessfullySentKindlyPatience);
      await ResendOTP(mobile: widget.mobile).request().then((status) {
        if (status == 200) message();
      });
    }
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    AuthenticateAccount(
      context,
      buttonCtrl,
      pinNode: pinNode,
      pin: pin,
      mobile: widget.mobile,
    ).request();
  }
}
