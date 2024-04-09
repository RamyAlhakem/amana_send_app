import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/global/variables.dart';
import '/helper/helper.dart';

class TextFieldValidator {
  static void validateMobile(TextEditingController num) {
    final arb = AppLocalizations.of(Global.key.currentContext!)!;
    if (num.text.isNotEmpty && num.text.startsWith('0')) {
      num.clear();
      Helper.toast(arb.pleaseAvoidStartingMobileNumberWithAZero);
    }
  }

  static List<TextInputFormatter> onlyDigits({int length = 16}) => [
        LengthLimitingTextInputFormatter(length),
        FilteringTextInputFormatter.digitsOnly,
      ];

  static String? validateEmail(BuildContext context, String? val) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val ?? '')) {
      return arb!.enterValidEmail;
    } else {
      return null;
    }
  }

  static String? validateField(BuildContext context, String? val, String hint) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    if (val == '') {
      return '${arb!.pleaseEnter} $hint';
    } else {
      return null;
    }
  }

  static void latin(BuildContext context, TextEditingController ctrl) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    final RegExp nonLatin = RegExp(r'[^\u0000-\u007F]');

    if (nonLatin.hasMatch(ctrl.text)) {
      Helper.toast(arb!.onlyLatin);
      ctrl.text = ctrl.text.replaceAll(nonLatin, '');
    }
  }

  static void arabic(BuildContext context, TextEditingController ctrl) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    final RegExp nonArabic = RegExp(r'[^\u0600-\u06FF\u0660-\u0669\s0-9.]');

    if (nonArabic.hasMatch(ctrl.text)) {
      Helper.toast(arb!.onlyArabic);
      ctrl.text = ctrl.text.replaceAll(nonArabic, '');
    }
  }
}
