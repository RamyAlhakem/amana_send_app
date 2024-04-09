import 'package:amana_send/models/server_app_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/global/variables.dart';
import '/helper/helper.dart';

class Tools {
  static DateTime? _currentBackPressTime;

  static bool onWillPop() {
    DateTime now = DateTime.now();
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;

    ServerAppVersion.isUpdate();

    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Helper.toast(arb.pressBackAgainToExit);

      return false;
    }
    return true;
  }

  static int compareVersion(String appVersion, String apiVersion) {
    List<int> parseVersion(String version) {
      return version.split('.').map((v) => int.parse(v)).toList();
    }

    final List<int> app = parseVersion(appVersion);
    final List<int> api = parseVersion(apiVersion);

    final int length = app.length > api.length ? app.length : api.length;

    for (int i = 0; i < length; i++) {
      int num1 = i < app.length ? app[i] : 0;
      int num2 = i < api.length ? api[i] : 0;

      if (num1 < num2) {
        return -1; // appVersion is less than apiVersion
      } else if (num1 > num2) {
        return 1; // appVersion is greater than apiVersion
      }
    }

    return 0; // versions are equal
  }

  static void removeSpaceFromClipboard(TextEditingController controller) async {
    ClipboardData? content = await Clipboard.getData('text/plain');
    if (content != null) {
      String cleanContent = (content.text ?? '').replaceAll(RegExp(r'\D+'), '');
      controller.text = cleanContent;
    }
  }

  static String transferStatus(int i) {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;

    String status = '';
    switch (i) {
      case 0:
        status = arb.waitingPayment;
        break;
      case 1:
        status = arb.awaitingProcess;
        break;
      case 2:
        status = arb.processing;
        break;
      case 3:
        status = arb.completed;
        break;
      case 4:
        status = arb.canceled;
        break;
      case 5:
        status = arb.dispute;
        break;
    }
    return status;
  }

  static List<bool> setSelect(List<dynamic> elements, List<bool> selection) {
    /// To unselect [selection], pass empty boolean list value.
    final set = List<bool>.generate(elements.length, (i) => false);
    if (selection.isEmpty) selection = set;
    if (elements.length > selection.length) selection = set;

    return selection;
  }

  static List<num> extractNumbers(String input) {
    List<num> numbers = [];
    RegExp regExp = RegExp(r'\d+(\.\d+)?'); // Match integers and decimals

    Iterable<Match> matches = regExp.allMatches(input);

    for (Match match in matches) {
      numbers.add(num.parse(match.group(0)!));
    }

    return numbers;
  }

  static String nicePrice(double price) {
    try {
      final double fraction = (price % 1);
      final int fixed = fraction != 0 ? 2 : 0;
      final String nice = price.toStringAsFixed(fixed);
      final List<String> parts = nice.split('.');

      // Add commas for thousands separator
      parts.first = parts.first.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');

      // Check if decimal part is zero
      if (parts.length > 1 && int.tryParse(parts[1]) == 0) {
        return parts.first; // No decimal part if it's zero
      } else {
        return parts.join('.'); // Include two decimal places
      }
    } catch (e) {
      debugPrint('Error formatting price: $e');
      return '';
    }
  }
}
