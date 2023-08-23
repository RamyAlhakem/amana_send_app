import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '/app/widgets/buttons/button.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/delete_account.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/graphql/api/change_email.dart';
import '/graphql/api/change_password.dart';
import '/helper/helper.dart';
import '../../../../../database/injector.dart';
import '/models/user.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late AppLocalizations? _arb;

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final GlobalKey<FormState> form2 = GlobalKey<FormState>();

  final UserModel user = Database().getUser;

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // bool receiveEmail = user.receiveEmail;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: user.firstName);
    _lastName = TextEditingController(text: user.lastName);
    _email = TextEditingController(text: user.email);
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: _arb!.editProfile,
          bGColor: Theme.of(context).cardColor,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          children: [
            Form(
              key: form,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    title: TextX(_arb!.changeEmail),
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: context.isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[350],
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFieldX(
                            controller: _email,
                            hint: _arb!.email,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12),
                              child: HeroIcon(HeroIcons.atSymbol),
                            ),
                            type: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 8),
            const HDivider(thickness: 0.2),
            const SizedBox(height: 8),
            Form(
              key: form2,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  title: TextX(_arb!.changePassword),
                  children: <Widget>[
                    _pass(_currentPassword, _arb!.currentPassword),
                    _pass(_newPassword, _arb!.newPassword),
                    _pass(_confirmPassword, _arb!.confirmNewPassword),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const HDivider(thickness: 0.2),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                title: TextX(_arb!.deleteAccount),
                children: <Widget>[
                  Button(
                    () => DeleteAccountDialog.show(),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    TextX(
                      _arb!.deleteMyAccount.toUpperCase(),
                      style: const TextStyle(color: Colors.red),
                    ),
                    color: Colors.red.withOpacity(0.2),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // const SizedBox(height: 8),
            // const HDivider(thickness: 0.2),
            // const SizedBox(height: 15),
            // InkWell(
            //   splashColor: Colors.transparent,
            //   highlightColor: Colors.transparent,
            //   onTap: () => setState(() => receiveEmail = !receiveEmail),
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(top: 4.0),
            //         child: SizedBox(
            //           height: 30,
            //           width: 20,
            //           child: Checkbox(
            //             activeColor: const Color(0xff00A86B),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4),
            //             ),
            //             side: const BorderSide(
            //               width: 2,
            //               color: MainColors.color2,
            //             ),
            //             value: receiveEmail,
            //             onChanged: (bool? value) =>
            //                 setState(() => receiveEmail = !receiveEmail),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       const Flexible(
            //         child: TextX('Receive email offers and discounts'),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.44,
                child: Button(
                  () => context.pop(),
                  TextX(_arb!.cancel),
                  borderRadius: 100,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: Button(
                    () => submit(),
                    TextX(_arb!.save),
                    borderRadius: 100,
                    color: const Color(0xff4DB677),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pass(TextEditingController ctrl, String hint) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: context.isDarkMode ? Colors.grey[850] : Colors.grey[350],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFieldX(
          controller: ctrl,
          hint: hint,
          suffix: Padding(
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
            child: InkWell(
              onTap: () => setState(() => obscure = !obscure),
              child: HeroIcon(
                obscure ? HeroIcons.eyeSlash : HeroIcons.eye,
                color: Theme.of(context).iconTheme.color,
                size: 22,
              ),
            ),
          ),
          onChanged: (String? v) => TextFieldValidator.latin(context, ctrl),
          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          maxLines: 1,
          obscureText: obscure,
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (!form2.currentState!.validate()) return;

    if (user.email == _email.text && _currentPassword.text.isEmpty) {
      return Helper.bannerWarning(
        'There are no new changes in the fields to save',
      );
    }

    if (_email.text.isNotEmpty) {
      if (user.email != _email.text) {
        ChangeEmail(context, email: _email.text).request();
      }
    }

    if (_currentPassword.text != '' && _confirmPassword.text != '') {
      if (_newPassword.text != _confirmPassword.text) {
        Helper.bannerError("New password & confirm password doesn't match");
        return;
      }
      ChangePassword(
        context,
        currentPassword: _currentPassword.text,
        newPassword: _newPassword.text,
        confirmNewPassword: _confirmPassword.text,
      ).request();
    }
  }
}
