import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/registration_state.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/vertical_fade.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({super.key, required this.buttonCtrl});

  final LoadingButtonController buttonCtrl;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        bottom: MediaQuery.of(context).size.height * 0.03,
      ),
      child: RoundedLoadingButton(
        controller: buttonCtrl,
        animateOnTap: false,
        onPressed: () {
          context.read<RegistrationState>().submitForm(context, buttonCtrl);
        },
        child: VerticalFade(
          child: Visibility(
            visible: context.select(
              (RegistrationState state) => state.isRegister,
            ),
            replacement: TextX(
              arb!.logIn.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            child: TextX(
              arb.registerNow,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
