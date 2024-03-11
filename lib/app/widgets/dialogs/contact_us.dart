import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/helper/screen_size.dart';
import 'settings.dart';

class ContactUs {
  ContactUs({required this.message});
  final String message;

  void show() {
    final BuildContext context = Global.key.currentContext!;
    final AppLocalizations arb = AppLocalizations.of(context)!;
    SettingsDialog(
      onSubmit: null,
      title: arb.contactUs,
      subTitle: message,
      subTitleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
      backgroundColor: Theme.of(context).cardColor,
      content: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 20, 6, 0),
        child: Button(
          height: 45,
          width: ScreenSize.width,
          borderRadius: 100,
          () => Helper.launchURL('https://t.me/AMANA_CS'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextX(
                arb.telegram,
                style: const TextStyle(color: MainColors.telegram),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/svg/telegram.svg', height: 25),
            ],
          ),
          color: Theme.of(Global.key.currentContext!).cardColor,
          borderColor: MainColors.telegram,
        ),
      ),
    ).show();
  }
}
