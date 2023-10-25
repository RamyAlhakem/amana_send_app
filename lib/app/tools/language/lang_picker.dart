import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/dialogs/language.dart';

class LangPicker extends StatelessWidget {
  const LangPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final button = Theme.of(context).iconTheme.color ?? Colors.transparent;
    return IconButton(
      onPressed: () => LanguageDialog.change(),
      icon: HeroIcon(HeroIcons.language, color: button),
    );
  }
}
