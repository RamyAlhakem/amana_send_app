import 'package:amana_send/app/theme/colors/main_colors.dart';

import '/app/extensions/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '/configs/configs.dart';
import '/helper/helper.dart';
import '/app/widgets/text/text_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/services/lang_service.dart';

class GeneralWidgets {
  static InputBorder formBorder(BuildContext context, {double radius = 6}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: context.isDarkMode ? Colors.white12 : Colors.black26,
        width: 0.9,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // static InputBorder loginBorder({double thickness = 0.9, Color? color}) {
  //   return OutlineInputBorder(
  //     borderSide: BorderSide(color: color ?? Colors.white12, width: thickness),
  //     borderRadius: BorderRadius.circular(6),
  //   );
  // }

  static Widget loginLogo(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Image.asset(
          'assets/images/icon${context.isDarkMode ? '_light' : ''}.png',
          height: 100,
        ),
      ),
    );
  }

  static BoxDecoration formDecoration(
    BuildContext context, {
    Color? color,
    double borderRadius = 8,
  }) {
    return BoxDecoration(
      color: color ?? Theme.of(context).inputDecorationTheme.fillColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Theme.of(context).dividerColor,
        width: 0.9,
      ),
    );
  }

  static final Widget cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 9),
        width: 22,
        height: 1,
        color: MainColors.color1,
      ),
    ],
  );

  static OutlinedBorder customShape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(LangService.isAR() ? 11 : 0),
          topRight: Radius.circular(LangService.isAR() ? 0 : 11),
          bottomLeft: Radius.circular(LangService.isAR() ? 11 : 0),
          bottomRight: Radius.circular(LangService.isAR() ? 0 : 11),
        ),
      );

  static Widget privacyPolicy(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => Helper.launchURL('${Configs.baseUrl}pages/privacy-policy'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextX(
              arb!.privacyPolicyAndPersonalDataProtection,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.blue,
                  ),
            ),
            const HeroIcon(
              HeroIcons.cursorArrowRays,
              size: 15,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
