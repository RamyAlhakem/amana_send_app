import 'package:flutter/material.dart';

import '/app/extensions/dark_mode.dart';
import 'shimmer.dart';

class ShimmerLoad extends StatelessWidget {
  const ShimmerLoad({
    this.verticalCount = 1,
    this.horizontalCount = 1,
    this.height = 40,
    this.width,
    this.radius = 6,
    this.spacingY = 6.0,
    this.spacingX = 4.0,
    this.opacity,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.circular = false,
    Key? key,
  }) : super(key: key);

  final int verticalCount, horizontalCount;
  final double height, radius, spacingY, spacingX;
  final double? width, opacity;
  final MainAxisAlignment rowMainAxisAlignment;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffeeeeee).withOpacity(
        opacity ?? (context.isDarkMode ? 0.3 : 1.0),
      ),
      highlightColor: Colors.grey[300]!.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(verticalCount, (int y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: rowMainAxisAlignment,
            children: List<Widget>.generate(horizontalCount, (int x) {
              return Flexible(
                child: Container(
                  height: height,
                  width: width ?? MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(
                      spacingX, spacingY, spacingX, spacingY),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? Colors.white24 : Colors.white,
                    borderRadius:
                        circular ? null : BorderRadius.circular(radius),
                    shape: circular ? BoxShape.circle : BoxShape.rectangle,
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
