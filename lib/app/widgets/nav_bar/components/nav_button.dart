import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/router/app_route.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    required this.title,
    required this.icon,
    required this.index,
    required this.page,
    super.key,
  });

  final String title;
  final HeroIcons icon;
  final int index;
  final int page;

  @override
  Widget build(BuildContext context) {
    int index = this.index;
    return InkWell(
      onTap: () {
        if (Global.appSettings.token.isEmpty && page != 0) {
          context.push('/${AppRoute.logIn}');
          return;
        } else {
          if (index == page) {
            return;
          }
          index = page;
          Global.pageCtrl.jumpToPage(index);
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              icon,
              color: index == page
                  ? Theme.of(
                      context,
                    ).bottomNavigationBarTheme.selectedIconTheme?.color
                  : Theme.of(
                      context,
                    ).bottomNavigationBarTheme.unselectedIconTheme?.color,
            ),
            const SizedBox(height: 2),
            FittedBox(
              child: TextX(
                title,
                style: index == page
                    ? Theme.of(
                        context,
                      ).bottomNavigationBarTheme.selectedLabelStyle
                    : Theme.of(
                        context,
                      ).bottomNavigationBarTheme.unselectedLabelStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
