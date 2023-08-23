import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/app/widgets/general/general_widgets.dart';
import 'tools/text_form_validator.dart';

class TextFieldX extends StatelessWidget {
  const TextFieldX({
    required this.hint,
    required this.controller,
    this.border,
    Key? key,
    this.onSubmitted,
    this.validateHint,
    this.readOnly = false,
    this.isValidateEmail = false,
    this.focusNode,
    this.focusedBorder,
    this.obscureText = false,
    this.labelStyle,
    this.fillColor,
    this.filled = false,
    this.enabled,
    this.style,
    this.errorStyle,
    this.errorBorder,
    this.onChanged,
    this.height,
    this.width = 1.0,
    this.borderRadius = 6.0,
    this.type,
    this.input,
    this.maxLines = 1,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.initialValue,
    this.validator,
    this.contentPadding,
    this.padding = const EdgeInsets.fromLTRB(0, 8, 0, 8),
    this.textInputAction = TextInputAction.next,
    this.textDirection,
    this.floatingLabelBehavior,
  }) : super(key: key);

  final Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final bool readOnly;
  final bool isValidateEmail;
  final FocusNode? focusNode;
  final InputBorder? border, focusedBorder, errorBorder;
  final String hint;
  final String? validateHint;
  final String? initialValue;
  final Color? fillColor;
  final bool? filled, enabled;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final double? height, width;
  final double borderRadius;
  final TextInputType? type;
  final List<TextInputFormatter>? input;
  final int? maxLines;
  final Widget? prefix, suffix;
  final Widget? prefixIcon, suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry padding;
  final TextInputAction textInputAction;
  final TextDirection? textDirection;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width * (width ?? 1.0),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: TextFormField(
            readOnly: readOnly,
            style: style,
            autocorrect: false,
            enableSuggestions: false,
            focusNode: focusNode,
            maxLines: maxLines,
            keyboardType: type,
            validator: validator ??
                (String? value) => isValidateEmail
                    ? TextFieldValidator.validateEmail(context, value)
                    : TextFieldValidator.validateField(
                        context,
                        value,
                        validateHint ?? hint,
                      ),
            initialValue: initialValue,
            enabled: enabled,
            controller: controller,
            inputFormatters: input,
            obscureText: obscureText,
            textInputAction: textInputAction,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              prefix: prefix,
              prefixIcon: prefixIcon,
              suffix: suffix,
              suffixIcon: suffixIcon,
              labelText: hint,
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 48, minWidth: 48),
              labelStyle: labelStyle ?? Theme.of(context).textTheme.titleSmall,
              contentPadding: contentPadding ?? const EdgeInsets.all(10),
              floatingLabelBehavior: floatingLabelBehavior,
              isDense: true,
              filled: filled,
              fillColor: fillColor,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              focusedBorder: border ??
                  GeneralWidgets.formBorder(context, radius: borderRadius),
              enabledBorder: border ??
                  GeneralWidgets.formBorder(context, radius: borderRadius),
              border: border ??
                  GeneralWidgets.formBorder(context, radius: borderRadius),
              errorStyle: errorStyle,
            ),
            textDirection: textDirection,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}
