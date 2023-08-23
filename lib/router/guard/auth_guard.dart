import 'package:go_router/go_router.dart';
import '/global/variables.dart';

class AuthGuard {
  static String? isRedirect(GoRouterState state, String route) {
    // if the user is not logged in, they need to login
    final bool loggedIn = Global.appSettings.loggedIn;
    final bool loggingIn = state.matchedLocation == '/$route';
    if (!loggedIn) return loggingIn ? null : '/$route';

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggingIn) return '/';

    // no need to redirect at all
    return null;
  }
}
