import 'package:flutter/material.dart';

class Ancestor extends InheritedWidget {
  const Ancestor({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(Ancestor oldWidget) => false;

  static Ancestor? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Ancestor>();
  }
}
