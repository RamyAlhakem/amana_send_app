import 'package:flutter/material.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/graphql/api/get_countries.dart';

class LanguageDialog {
  static void change() {
    final BuildContext context = Global.key.currentContext!;
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          title: const SizedBox.shrink(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Button(
                () {
                  Global.appSettings.setLang(const Locale('en'));
                  dismiss();
                },
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).hintColor,
                const Row(children: [
                  Icon(Icons.translate),
                  SizedBox(width: 15),
                  TextX('English'),
                ]),
              ),
              const SizedBox(height: 15),
              Button(
                () {
                  Global.appSettings.setLang(const Locale('ar'));
                  dismiss();
                },
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).hintColor,
                const Row(children: [
                  Icon(Icons.translate),
                  SizedBox(width: 15),
                  TextX('العربية'),
                ]),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      // Refresh UI

      GetCountriesAPI.request();
    });
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
