import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:pinput/pinput.dart';

import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';

class PinForm extends StatelessWidget {
  const PinForm({
    super.key,
    required this.focusNode,
    required this.pin,
    this.nextFiledNode,
    this.onSubmit,
  });

  final TextEditingController pin;
  final FocusNode focusNode;
  final FocusNode? nextFiledNode;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: const TextStyle(fontSize: 22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Pinput(
          controller: pin,
          focusNode: focusNode,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          defaultPinTheme: defaultPinTheme,
          validator: (value) => TextFieldValidator.validateField(
            context,
            value,
            arb!.enterCode,
          ),
          errorTextStyle: Theme.of(context).inputDecorationTheme.errorStyle,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onClipboardFound: kIsWeb ? null : (value) => pin.setText(value),
          hapticFeedbackType: HapticFeedbackType.heavyImpact,
          cursor: GeneralWidgets.cursor,
          separatorBuilder: (_) => const SizedBox(width: 16),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                )
              ],
            ),
          ),
          closeKeyboardWhenCompleted: nextFiledNode != null ? false : true,
          onCompleted: (String? v) {
            if (nextFiledNode != null) {
              FocusScope.of(context).requestFocus(nextFiledNode);
            } else {
              if (onSubmit != null) onSubmit!();
            }
          },
          onSubmitted: (String? v) {
            if (onSubmit != null) onSubmit!();
          },
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration?.copyWith(
              color: const Color.fromRGBO(243, 246, 249, 0),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(
                color: const Color.fromRGBO(23, 171, 144, 1),
              ),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(
              color: Theme.of(context).inputDecorationTheme.errorStyle?.color ??
                  Colors.red,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
