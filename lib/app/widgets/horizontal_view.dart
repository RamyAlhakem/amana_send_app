import 'package:flutter/material.dart';

class HorizontalView extends StatelessWidget {
  const HorizontalView(
    this.children, {
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.controller,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.fromLTRB(4, 4, 4, 4),
      scrollDirection: Axis.horizontal,
      physics: physics,
      controller: controller,
      child: Row(children: children),
    );
  }
}
