import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/dialogs/language.dart';

class LangPicker extends StatelessWidget {
  const LangPicker({super.key, this.padding = 5});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final button = Theme.of(context).iconTheme.color ?? Colors.transparent;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => LanguageDialog.change(),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: button),
        ),
        child: HeroIcon(HeroIcons.language, color: button),
      ),
    );
  }
}
