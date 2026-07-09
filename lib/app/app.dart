import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '/app/theme/themes.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/global/variables.dart';
import '/localization/l10n.dart';
import '/router/app_route.dart';
import 'views/main_pages/provider/calculator.dart';
import 'views/notifications/provider/notifications_state.dart';
import 'views/registration/provider/registration_state.dart';
import 'widgets/first_gesture_permission_prompt.dart';

class AmanaSend extends StatelessWidget {
  const AmanaSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationState()),
        ChangeNotifierProvider(create: (_) => Calculator()),
        ChangeNotifierProvider(create: (_) => TransfersState()),
        ChangeNotifierProvider(create: (_) => RecipientsState()),
        ChangeNotifierProvider(create: (_) => NotificationsState()),
      ],
      child: AnimatedBuilder(
        animation: Global.appSettings,
        builder: (BuildContext context, Widget? main) {
          main = MaterialApp.router(
            routerConfig: AppRoute.routes,
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'amana_send',
            scaffoldMessengerKey: Global.snackKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Global.appSettings.locale,
            supportedLocales: L10n.all.keys,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            theme: Themes.light(),
            darkTheme: Themes.dark(),
            themeMode: Global.appSettings.themeMode,
            builder: (context, child) => _ResponsiveShell(
              child: FirstGesturePermissionPrompt(child: child!),
            ),
          );
          return main;
        },
      ),
    );
  }
}

class _ResponsiveShell extends StatelessWidget {
  const _ResponsiveShell({required this.child});
  final Widget? child;

  static const double _maxWidth = 650;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    if (width <= _maxWidth) {
      return ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: child,
      );
    }
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: child,
        ),
      ),
    );
  }
}
