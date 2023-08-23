import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/text/text_x.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({
    required this.onTap,
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final String title;
  final HeroIcons icon;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MainColors.color1.withOpacity(0.2),
          border: Border.all(color: MainColors.color1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: HeroIcon(icon, size: 25, color: iconColor ?? MainColors.color1),
      ),
      title: TextX(title, style: TextStyle(color: textColor)),
      trailing: trailing ??
          Icon(Icons.chevron_right,
              size: 35, color: Theme.of(context).iconTheme.color),
      contentPadding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
