import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/blurry_container.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';

class SettingsDialog {
  SettingsDialog({
    required this.onSubmit,
    required this.title,
    required this.subTitle,
    required this.content,
    this.onSubmitTitle,
    this.subTitleStyle,
    this.onSubmitTitleStyle,
    this.onSubmitColor,
    this.horizontalPadding = 20,
    this.backgroundColor,
  });

  final String title;
  final String subTitle;
  final Widget Function(void Function(VoidCallback)) content;
  final String? onSubmitTitle;
  final TextStyle? subTitleStyle, onSubmitTitleStyle;
  final Color? onSubmitColor, backgroundColor;
  final double horizontalPadding;
  final void Function()? onSubmit;

  Future<void> show() async {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations? arb = AppLocalizations.of(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      useSafeArea: false,
      builder: (BuildContext _) {
        return StatefulBuilder(builder: (__, state) {
          return BlurryContainer(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: backgroundColor ?? Colors.transparent,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextX(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: MainColors.color2,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                    child: TextX(
                      subTitle,
                      style: subTitleStyle ??
                          Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              insetPadding: EdgeInsets.fromLTRB(
                horizontalPadding,
                kTextTabBarHeight,
                horizontalPadding,
                0,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: content(state),
              ),
              contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              actions: [
                Column(
                  children: [
                    if (onSubmit != null)
                      Button(
                        onSubmit,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        TextX(
                          onSubmitTitle ?? arb!.ok,
                          style: onSubmitTitleStyle ??
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        color: onSubmitColor ?? MainColors.color5,
                        borderRadius: 100,
                      ),
                    if (onSubmit != null) const SizedBox(height: 12),
                    Button(
                      () => dismiss(),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      FittedBox(
                        child: TextX(
                          onSubmit == null ? arb!.done : arb!.ok,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.secondary,
                      borderRadius: 100,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
