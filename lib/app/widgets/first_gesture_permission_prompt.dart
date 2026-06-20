import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '/services/notification_service.dart';

/// Wraps [child] and, on the first user gesture (pointer down, scroll wheel,
/// or touch), synchronously triggers the web notification permission prompt
/// before the transient user activation expires. After firing once, the
/// listener removes itself by returning [child] unchanged.
class FirstGesturePermissionPrompt extends StatelessWidget {
  const FirstGesturePermissionPrompt({super.key, required this.child});

  final Widget child;

  void _prompt() {
    NotificationService.requestWebPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _prompt(),
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) _prompt();
      },
      child: child,
    );
  }
}
