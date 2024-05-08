import 'package:amana_send/app/widgets/text/text_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/extensions/keyboard.dart';
import '/app/views/registration/components/phone_country_picker.dart';
import '/app/views/registration/provider/registration_state.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key, required this.buttonCtrl});

  final LoadingButtonController buttonCtrl;

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> with TickerProviderStateMixin {
  late AppLocalizations? arb;

  bool _obscure = true;

  late Animation<double> animate;
  late RegistrationState p;

  @override
  void initState() {
    super.initState();
    p = Provider.of<RegistrationState>(context, listen: false);

    p.initializeExpander(AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    ));

    animate = CurvedAnimation(parent: p.expander, curve: Curves.fastOutSlowIn);

    // dispose {
    WidgetsBinding.instance.addPostFrameCallback((_) => p.register(false));
    // }
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: p.loginForm,
      child: Column(
         crossAxisAlignment :CrossAxisAlignment.start,
        children: [
          SizeTransition(
            sizeFactor: animate,
            axis: Axis.vertical,
            axisAlignment: context.isKeyboardOpen ? 0 : -2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowSpaceBetween([
                  Expanded(child: _nameForm(p.firstName, arb!.firstName)),
                  const SizedBox(width: 14),
                  Expanded(child: _nameForm(p.lastName, arb!.lastName)),
                ]),
                TextFieldX(
                  controller: p.fatherName,
                  hint: arb!.fatherNameOptional,
                  type: TextInputType.name,
                  onChanged: (_) =>
                      TextFieldValidator.latin(context, p.fatherName),
                  validator: (_) => null,
                ),
              ],
            ),
          ),
          const PhoneCountryPicker(),
          TextX(
            arb!.verificationCodeWhatsApp,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 148, 13, 4),
            ),
          ),
          SizedBox(height: 20,),
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizeTransition(
              sizeFactor: animate,
              axis: Axis.vertical,
              axisAlignment: context.isKeyboardOpen ? -2 : 0,
              child: TextFieldX(
                controller: p.email,
                hint: arb!.email,
                type: TextInputType.emailAddress,
                labelStyle: Theme.of(context).textTheme.titleSmall,
                validator: (String? val) {
                  if (p.isRegister) {
                    return TextFieldValidator.validateEmail(context, val);
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          _password(
            node: p.passwordNode,
            onSubmitted: (String? v) {
              if (p.isRegister) {
                FocusScope.of(context).requestFocus(p.confirmPasswordNode);
              } else {
                p.submitForm(context, widget.buttonCtrl);
              }
            },
            ctrl: p.password,
            hint: arb!.password,
            validator: (val) {
              if (val == '') {
                return '${arb!.pleaseEnter} ${arb!.password}';
              }
              return null;
            },
          ),
          SizeTransition(
            sizeFactor: animate,
            axis: Axis.vertical,
            axisAlignment: context.isKeyboardOpen ? -2 : 0,
            child: _password(
              onSubmitted: (String? v) =>
                  p.submitForm(context, widget.buttonCtrl),
              ctrl: p.confirmPassword,
              node: p.confirmPasswordNode,
              hint: arb!.confirmPassword,
              validator: (val) {
                if (p.isRegister && val == '') {
                  return '${arb!.pleaseEnter} ${arb!.confirmPassword}';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameForm(TextEditingController ctrl, String hint) {
    return TextFieldX(
      controller: ctrl,
      hint: hint,
      type: TextInputType.name,
      width: 0.3,
      onChanged: (_) => TextFieldValidator.latin(context, ctrl),
      validator: (val) {
        if (p.isRegister && val == '') {
          return '${arb!.pleaseEnter} $hint';
        } else {
          return null;
        }
      },
    );
  }

  Widget _password({
    required Function(String)? onSubmitted,
    required TextEditingController ctrl,
    required String hint,
    FocusNode? node,
    String? Function(String?)? validator,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFieldX(
        onSubmitted: onSubmitted,
        focusNode: node,
        controller: ctrl,
        hint: hint,
        type: TextInputType.visiblePassword,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => setState(() => _obscure = !_obscure),
            child: HeroIcon(
              _obscure ? HeroIcons.eyeSlash : HeroIcons.eye,
              size: 22,
            ),
          ),
        ),
        input: [LengthLimitingTextInputFormatter(50)],
        obscureText: _obscure,
        onChanged: (String? v) => TextFieldValidator.latin(context, ctrl),
        validator: validator,
      ),
    );
  }
}
