import 'package:flutter/widgets.dart';

extension Keyboard on BuildContext {
  bool get isKeyboardOpen {
    final FocusScopeNode scope = FocusScope.of(this);
    return !scope.hasPrimaryFocus && scope.hasFocus;
  }
}
