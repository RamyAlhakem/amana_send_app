import 'package:flutter/cupertino.dart';

class RowSpaceBetween extends StatelessWidget {
  const RowSpaceBetween(this.children, {super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
