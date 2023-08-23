import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/dialogs/language.dart';

class LangPicker extends StatelessWidget {
  const LangPicker({super.key, this.iconColor, this.padding = 5});

  final Color? iconColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => LanguageDialog.change(),
      child: Container(
        padding: EdgeInsets.all(padding),
        child: HeroIcon(HeroIcons.language, color: iconColor),
      ),
    );
  }
}
