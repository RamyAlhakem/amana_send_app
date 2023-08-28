import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '/global/variables.dart';
import 'text/text_c.dart';
import 'text/text_x.dart';

class AutoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AutoAppBar({
    Key? key,
    this.onPressed,
    this.title = '',
    this.subTitle = '',
    this.bGColor,
    this.iconColor,
    this.leading,
    this.leadingWidth,
    this.appBarHeight,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.titleStyle,
    this.subTitleStyle,
    this.titleReplacement,
    this.systemOverlayStyle,
  }) : super(key: key);

  final void Function()? onPressed;
  final String title, subTitle;
  final Widget? titleReplacement;
  final Color? bGColor, iconColor;
  final Widget? leading, flexibleSpace, bottom;
  final double? leadingWidth, appBarHeight;
  final List<Widget>? actions;
  final TextStyle? titleStyle, subTitleStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: leading ??
          IconButton(
            onPressed: onPressed ?? () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: iconColor ?? Theme.of(context).iconTheme.color,
            ),
          ),
      leadingWidth: leadingWidth,
      backgroundColor: bGColor ?? Colors.transparent,
      systemOverlayStyle:
          systemOverlayStyle ?? Global.systemOverlayStyle(context),
      title: Visibility(
        visible: title.isNotEmpty,
        replacement: titleReplacement ?? const SizedBox.shrink(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextC(title,
                style: titleStyle ?? Theme.of(context).textTheme.titleMedium),
            if (subTitle.isNotEmpty)
              TextX(
                subTitle,
                style: subTitleStyle ?? Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: bottom ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}
