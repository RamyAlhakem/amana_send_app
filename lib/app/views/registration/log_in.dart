import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/extensions/keyboard.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/fade_switcher.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/vertical_fade.dart';
import '/helper/helper.dart';
import '/router/app_route.dart';
import '/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/app/views/main_pages/home/widgets/install_app_banner.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'components/footer.dart';
import 'components/form.dart';
import 'components/log_in_button.dart';
import 'provider/registration_state.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with TickerProviderStateMixin {
  late AppLocalizations? arb;

  final LoadingButtonController buttonCtrl = LoadingButtonController();

  late Animation<double> animate;
  late RegistrationState _pr;

  @override
  void initState() {
    super.initState();
    _pr = Provider.of<RegistrationState>(context, listen: false);

    _pr.initializeExpanderF(AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    ));

    animate =
        CurvedAnimation(parent: _pr.expanderF, curve: Curves.fastOutSlowIn);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pr.password.clear();
      _pr.confirmPassword.clear();
      _pr.loginForm.currentState?.dispose();
      _pr.registerForm.currentState?.dispose();
    });
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
        child: Consumer<Calculator>(
          builder: (context, calculator, scaffold) {
            return Column(
              children: [
                if (_isSafari && calculator.showInstall)
                  Material(
                      child: InstallAppBanner(arb: arb!, state: calculator)),
                Expanded(
                  child: scaffold!,
                ),
              ],
            );
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const AutoAppBar(flexibleSpace: SizedBox()),
            body: Form(
              key: _pr.registerForm,
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.white12
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                  children: [
                    GeneralWidgets.loginLogo(context),
                    TextX(
                      context.select(
                              (RegistrationState state) => state.isRegister)
                          ? 'Sign up'
                          : 'Login',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: VerticalFade(
                        child: TextX(
                          context.select(
                                  (RegistrationState state) => state.isRegister)
                              ? arb!.createNewAccount
                              : arb!.logInToYourAccount,
                        ),
                      ),
                    ),
                    // login & create account form elements
                    LogInForm(buttonCtrl: buttonCtrl),
                    SizeTransition(
                      sizeFactor: animate,
                      axis: Axis.vertical,
                      axisAlignment: context.isKeyboardOpen ? -1 : 1,
                      child: Button(
                        () => context.push('/${AppRoute.forgotPassword}'),
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        color: Colors.transparent,
                        TextX(
                          arb!.forgotPassword,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),

                    LogInButton(buttonCtrl: buttonCtrl),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeSwitcher(
                  child: Visibility(
                    key: UniqueKey(),
                    visible: context.select(
                      (RegistrationState state) => state.isRegister,
                    ),
                    replacement: LogInFooter(
                      isRegister: true,
                      title: arb!.dontHaveAccount,
                      subTitle: arb!.registerNow,
                    ),
                    child: LogInFooter(
                      isRegister: false,
                      title: arb!.alreadyHaveAccount,
                      subTitle: arb!.logIn,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns true only when running on the web **and** the browser is Safari.
  bool get _isSafari {
    if (!kIsWeb) return false;
    final ua = html.window.navigator.userAgent ?? '';
    return ua.contains('Safari') &&
        !ua.contains('Chrome') &&
        !ua.contains('Chromium');
  }
}
