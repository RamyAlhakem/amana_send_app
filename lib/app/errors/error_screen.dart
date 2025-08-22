import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/text/text_x.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.error, {super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    return Scaffold(
      appBar: AutoAppBar(title: '${arb!.error} ⚠'),
      body: SingleChildScrollView(
        child: Visibility(
          visible: kDebugMode,
          replacement: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextX('${arb.oops} 😥'),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: OverflowBox(
                    maxHeight: 400,
                    maxWidth: 400,
                    child: Lottie.asset('assets/json/error.json'),
                  ),
                ),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextX(
                error,
                style: TextStyle(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
