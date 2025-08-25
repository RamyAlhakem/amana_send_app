import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';

import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(0),
      child: DropdownButton<ThemeMode>(
        value: Global.appSettings.themeMode,
        onChanged: Global.appSettings.setThemeMode,
        underline: const SizedBox(),
        icon: Icon(
          Icons.chevron_right,
          size: 35,
          color: Theme.of(context).iconTheme.color,
        ),
        borderRadius: BorderRadius.circular(8),
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: TextX(arb!.systemTheme),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: TextX(arb.lightTheme),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: TextX(arb.darkTheme),
          )
        ],
      ),
    );
  }
}
