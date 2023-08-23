import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/global/variables.dart';
import '/graphql/api/delete_user.dart';

class DeleteAccountDialog {
  static void show() {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations? arb = AppLocalizations.of(context);
    GlobalKey<FormState> f_ = GlobalKey<FormState>();
    TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext _) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  Lottie.asset('assets/json/warning.json', height: 25),
                  const SizedBox(width: 6),
                  TextX(
                    arb!.attention,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Divider(thickness: 1, color: Colors.grey[300]),
              ),
            ],
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
                width: MediaQuery.of(context).size.width,
                child: TextX(
                  arb.areYouSureYouWantToDeleteYourAccount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Form(
                  key: f_,
                  child: TextFieldX(
                    onSubmitted: (String? v) =>
                        _onDelete(context, f_, ctrl.text),
                    controller: ctrl,
                    hint: arb.password,
                    obscureText: true,
                    contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                    onChanged: (String? v) =>
                        TextFieldValidator.latin(context, ctrl),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Button(
                () => _onDelete(context, f_, ctrl.text),
                width: MediaQuery.of(context).size.width,
                borderRadius: 100,
                TextX(
                  arb.deleteAccount,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                color: Colors.red.withOpacity(0.2),
              ),
              const SizedBox(height: 12),
              Button(
                () => dismiss(),
                width: MediaQuery.of(context).size.width,
                borderRadius: 100,
                FittedBox(
                  child: TextX(
                    arb.cancel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                color: Theme.of(context).buttonTheme.colorScheme?.secondary,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        );
      },
    );
  }

  static void _onDelete(
      BuildContext context, GlobalKey<FormState> _, String ctrl) {
    if (!_.currentState!.validate()) return;
    DeleteUser(context, password: ctrl).request();
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
