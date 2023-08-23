import 'dart:async';

import '/app/widgets/general/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/vertical_fade.dart';
import '/global/variables.dart';
import '/graphql/api/authenticate_account.dart';
import '/graphql/api/resend_otp.dart';
import '/helper/helper.dart';
import 'components/count_down.dart';
import 'components/pin_form.dart';

class AccountActivation extends StatefulWidget {
  const AccountActivation(
    this.email, {
    super.key,
    this.q = const <String, String>{'reSendOTP': 'false'},
  });

  final String email;
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

  final TextStyle formInputStyle = const TextStyle(color: Colors.white);

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
      ResendOTP(email: widget.email).request();
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.65),
          appBar: AutoAppBar(
            title: arb!.verifyEmail,
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
              margin: const EdgeInsets.fromLTRB(12, 20, 12, 20),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white12,
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
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Center(
                    child: TextX(
                      arb!.enterOTPcodeSentToTheEmail,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: TextC(
                      widget.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
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
    ctrl.reset();
    resendTimer?.cancel();

    if (duration == 0) {
      setState(() => duration = 170);

      ctrl.forward();
      isTimeOut();

      Helper.toast(arb!.codeSuccessfullySentKindlyPatience);
      await ResendOTP(email: widget.email).request().then((status) {
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
      email: widget.email,
    ).request();
  }
}
