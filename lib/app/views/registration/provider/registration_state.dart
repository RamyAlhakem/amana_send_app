import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/widgets/dialogs/captcha.dart';
import '/app/widgets/loading_button.dart';
import '/graphql/api/log_in.dart';
import '/graphql/api/register.dart';
import '/helper/helper.dart';
import '/models/city.dart';
import '/models/country.dart';
import '/models/metadata.dart';

class RegistrationState extends ChangeNotifier {
  bool _isRegister = false;

  File? _file;

  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();

  late AnimationController _expander;
  late AnimationController _expanderF;

  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();

  // register form <----{
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _fatherName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  //
  // login form --(
  CountryModel? _country; // selected country.
  List<CityModel> _cities = <CityModel>[]; // cities from selected country.
  // CityModel? _city; // selected city.
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _password = TextEditingController();
  // )--
  final TextEditingController _confirmPassword = TextEditingController();
  //

  bool get isRegister => _isRegister;

  File? get file => _file;

  FocusNode get passwordNode => _passwordNode;
  FocusNode get confirmPasswordNode => _confirmPasswordNode;

  AnimationController get expander => _expander;
  AnimationController get expanderF => _expanderF;

  GlobalKey<FormState> get loginForm => _loginForm;
  GlobalKey<FormState> get registerForm => _registerForm;

  TextEditingController get firstName => _firstName;
  TextEditingController get fatherName => _fatherName;
  TextEditingController get lastName => _lastName;

  CountryModel? get country => _country; // selected country.
  List<CityModel> get cities => _cities; // cities from selected country.
  // CityModel? get city => _city; // selected city.
  TextEditingController get mobile => _mobile;
  TextEditingController get email => _email;
  TextEditingController get password => _password;
  TextEditingController get confirmPassword => _confirmPassword;

  void setFile(File? element) {
    _file = element;
    if (element != null) notifyListeners();
  }

  //
  //

  // assign initial value to animation expanders, on page open
  void initializeExpander(AnimationController ctrl) => _expander = ctrl;
  void initializeExpanderF(AnimationController ctrl) => _expanderF = ctrl;

  void register(bool register) {
    // when user tap "register" text, show First+Last name registration fields
    _isRegister = register;
    expandForm();
    //
    // then hide "Forgot password" text button
    expandF();

    notifyListeners();
  }

  void expandForm() => isRegister ? _expander.forward() : _expander.reverse();
  void expandF() => isRegister ? _expanderF.reverse() : _expanderF.forward();

  void setCountry(CountryModel? country) {
    _country = country;
    if (country != null) notifyListeners();
  }

  void setCities(List<CityModel> cities) {
    _cities = cities;
    if (cities.isNotEmpty) notifyListeners();
  }

  // void setCity(CityModel? city) {
  //   _city = city;
  //   if (city != null) notifyListeners();
  // }

  Future<void> submitForm(
    BuildContext context,
    LoadingButtonController buttonCtrl,
  ) async {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (!loginForm.currentState!.validate()) return;
    if (isRegister && !registerForm.currentState!.validate()) return;

    if (country == null) return Helper.bannerWarning(arb!.selectCountry);

    if (isRegister && password.text.length < 8) {
      return Helper.bannerWarning(arb!.passwordMustContainAtLeast8Characters);
    }

    if (isRegister && password.text != confirmPassword.text) {
      return Helper.bannerWarning(arb!.passwordAndConfirmPasswordDoesNotMatch);
    }

    if (buttonCtrl.currentState == ButtonState.loading) return;
    if (buttonCtrl.currentState == ButtonState.error) return;
    if (buttonCtrl.currentState == ButtonState.success) return;

    FocusScope.of(context).unfocus();

    buttonCtrl.start();

    final String? phoneCode = country?.phoneCode;

    Future<void> registerAPI(String value) async => await RegisterAPI(
          context,
          buttonCtrl,
          aName: firstName.text,
          bName: fatherName.text,
          cName: lastName.text,
          coCode: country!.coCode,
          mob: '+$phoneCode${mobile.text}',
          email: email.text,
          pass: password.text,
          coPass: confirmPassword.text,
          captcha: value,
        ).request();

    Future<void> logInAPI(String value) async => await LogInAPI(
          buttonCtrl,
          mobile: '+$phoneCode${mobile.text}',
          password: password.text,
          captcha: value,
        ).request();

    if (isRegister) {
      if (AppMetadata.get.appSignUpCaptcha) {
        return CaptchaDialog(onSubmit: (value) => registerAPI(value)).show();
      }
      registerAPI('');
    } else {
      if (AppMetadata.get.appSignInCaptcha) {
        return CaptchaDialog(onSubmit: (value) => logInAPI(value)).show();
      }
      logInAPI('');
    }
  }
}
