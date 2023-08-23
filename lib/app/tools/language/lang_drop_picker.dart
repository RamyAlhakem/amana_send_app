import 'package:flutter/material.dart';

import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/localization/l10n.dart';
import '/services/lang_service.dart';

class LangDropPicker extends StatelessWidget {
  const LangDropPicker({super.key, this.color, this.title, this.icon});

  final Color? color;
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Locale locale = Global.appSettings.locale ?? const Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale.languageCode,
        icon: Row(
          children: [
            Icon(
              icon ?? Icons.chevron_right,
              size: 35,
              color: color ?? Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        items: L10n.all.keys.map<DropdownMenuItem<String>>(
          (Locale locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              value: locale.languageCode,
              onTap: () => Global.appSettings.setLang(locale),
              child: Row(
                children: [
                  TextX(flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  TextX(
                    locale.languageCode.toUpperCase(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: (String? _) => LangService.loadLang(),
        selectedItemBuilder: (context) {
          return L10n.all.values.map<Widget>((String item) {
            return Container(
              alignment: LangService.isAR()
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              constraints: const BoxConstraints(minWidth: 100),
              child: Text(
                title ?? item,
                style: TextStyle(
                  color: color ?? Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
