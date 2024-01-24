import 'dart:io';

import 'package:flutter/material.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/text/text_x.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.shadowColor = Colors.black12,
    this.itemCornerRadius = 50,
    this.containerHeight,
    this.blurRadius = 2,
    this.spreadRadius = 0,
    this.borderRadius,
    this.shadowOffset = Offset.zero,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) : assert(items.length >= 2 && items.length <= 5);

  /// The selected item is index. Changing this property will change and animate
  /// the item being selected. Defaults to zero.
  final int selectedIndex;

  /// The icon size of all items. Defaults to 24.
  final double iconSize;

  /// The background color of the navigation bar. It defaults to
  /// [ThemeData.BottomAppBarTheme] if not provided.
  final Color? backgroundColor;

  /// Defines the shadow color of the navigation bar. Defaults to [Colors.black12].
  final Color shadowColor;

  /// Whether this navigation bar should show a elevation. Defaults to true.
  final bool showElevation;

  /// Use this to change the item's animation duration. Defaults to 270ms.
  final Duration animationDuration;

  /// Defines the appearance of the buttons that are displayed in the bottom
  /// navigation bar. This should have at least two items and five at most.
  final List<NavBarItem> items;

  /// A callback that will be called when a item is pressed.
  final ValueChanged<int> onItemSelected;

  /// Defines the alignment of the items.
  /// Defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [items] corner radius, if not set, it defaults to 50.
  final double itemCornerRadius;

  /// Defines the bottom navigation bar height. Defaults to 56.
  final double? containerHeight;

  /// Used to configure the blurRadius of the [BoxShadow]. Defaults to 2.
  final double blurRadius;

  /// Used to configure the spreadRadius of the [BoxShadow]. Defaults to 0.
  final double spreadRadius;

  /// Used to configure the offset of the [BoxShadow]. Defaults to null.
  final Offset shadowOffset;

  /// Used to configure the borderRadius of the [NavBar]. Defaults to null.
  final BorderRadiusGeometry? borderRadius;

  /// Used to configure the padding of the [NavBarItem] [items].
  /// Defaults to EdgeInsets.symmetric(horizontal: 10).
  final EdgeInsets titlePadding;

  /// Used to configure the animation curve. Defaults to [Curves.linear].
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: shadowColor,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              offset: shadowOffset,
            ),
        ],
        borderRadius: borderRadius,
      ),
      child: Container(
        width: double.infinity,
        height: containerHeight ?? (Platform.isIOS ? 85 : 75),
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: items.map((item) {
            int index = items.indexOf(item);
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _ItemWidget(
                item: item,
                iconSize: iconSize,
                isSelected: index == selectedIndex,
                backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
                itemCornerRadius: itemCornerRadius,
                animationDuration: animationDuration,
                titlePadding: titlePadding,
                curve: curve,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final NavBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final EdgeInsets titlePadding;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.iconSize,
    required this.isSelected,
    required this.item,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.animationDuration,
    required this.titlePadding,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        width: isSelected ? 130 : 50,
        duration: animationDuration,
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        curve: curve,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black12 : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: isSelected ? 130 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: iconSize,
                    color: isSelected ? item.activeColor : item.inactiveColor,
                  ),
                  child: item.icon,
                ),
                if (isSelected)
                  Flexible(
                    child: FittedBox(
                      child: Container(
                        padding: titlePadding,
                        child: TextX(
                          item.title,
                          style: Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedLabelStyle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The [NavBar.items] definition.
class NavBarItem {
  NavBarItem({
    required this.icon,
    required this.title,
    this.activeColor = MainColors.color2,
    this.inactiveColor = MainColors.color1,
  });

  /// Defines this item's icon which is placed in the right side of the [title].
  final Widget icon;

  /// Defines this item's title which placed in the left side of the [icon].
  final String title;

  /// The [icon] and [title] color defined when this item is selected. Defaults
  /// to [Colors.blue].
  final Color activeColor;

  /// The [icon] and [title] color defined when this item is not selected.
  final Color inactiveColor;
}
