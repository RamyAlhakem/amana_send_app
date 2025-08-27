import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
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
import '/database/injector.dart';
import '/models/user.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late AppLocalizations arb;

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final GlobalKey<FormState> form2 = GlobalKey<FormState>();

  final UserModel user = Database().getUser;

  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController email;

  final FocusNode newPasswordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool obscure = true;

  @override
  void initState() {
    super.initState();
    firstName = TextEditingController(text: user.firstName);
    lastName = TextEditingController(text: user.lastName);
    email = TextEditingController(text: user.email);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: arb.editProfile,
          bGColor: Theme.of(context).cardColor,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          children: [
            Form(
              key: form,
              child: ExpansionTile(
                  tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  title: TextX(arb.changeEmail),
                  shape: const Border(),
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
                          controller: email,
                          hint: arb.email,
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
            const SizedBox(height: 8),
            const HDivider(thickness: 0.2),
            const SizedBox(height: 8),
            Form(
              key: form2,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                title: TextX(arb.changePassword),
                shape: const Border(),
                children: <Widget>[
                  _pass(
                    currentPassword,
                    arb.currentPassword,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(newPasswordNode),
                  ),
                  _pass(
                    newPassword,
                    arb.newPassword,
                    node: newPasswordNode,
                    onSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(confirmPasswordNode),
                  ),
                  _pass(
                    confirmPassword,
                    arb.confirmNewPassword,
                    node: confirmPasswordNode,
                    onSubmitted: (_) => submit(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const HDivider(thickness: 0.2),
            ExpansionTile(
              tilePadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              title: TextX(arb.deleteAccount),
              shape: const Border(),
              children: <Widget>[
                Button(
                  () => DeleteAccountDialog.show(),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  TextX(
                    arb.deleteMyAccount.toUpperCase(),
                    style: const TextStyle(color: Colors.red),
                  ),
                  color: Colors.red.withOpacity(0.2),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
                  TextX(arb.cancel),
                  borderRadius: 100,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: Button(
                    () => submit(),
                    TextX(arb.save),
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

  Widget _pass(
    TextEditingController ctrl,
    String hint, {
    FocusNode? node,
    void Function(String)? onSubmitted,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: context.isDarkMode ? Colors.grey[850] : Colors.grey[350],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFieldX(
          focusNode: node,
          controller: ctrl,
          onSubmitted: onSubmitted,
          hint: hint,
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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

    if (user.email == email.text && currentPassword.text.isEmpty) {
      return Helper.bannerWarning(arb.noNewChangesInTheFieldsToSave);
    }

    if (email.text.isNotEmpty) {
      if (user.email != email.text) {
        ChangeEmail(context, email: email.text).request();
      }
    }

    if (currentPassword.text != '' && confirmPassword.text != '') {
      if (newPassword.text != confirmPassword.text) {
        Helper.bannerError(arb.newPasswordAndConfirmPasswordDoesNotMatch);
        return;
      }
      ChangePassword(
        context,
        currentPassword: currentPassword.text,
        newPassword: newPassword.text,
        confirmNewPassword: confirmPassword.text,
      ).request();
    }
  }
}
