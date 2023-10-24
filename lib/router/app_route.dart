import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/errors/error_screen.dart';
import '/app/views/camera/camera.dart';
import '/app/views/main_pages/account/edit/edit_account.dart';
import '/app/views/main_pages/account/support/support.dart';
import '/app/views/main_pages/account/verify/verify_account.dart';
import '/app/views/main_pages/home/screens/send_hub.dart';
import '/app/views/main_pages/home/screens/success.dart';
import '/app/views/main_pages/recipients/add_recipient/add.dart';
import '/app/views/main_pages/recipients/recipient/recipient.dart';
import '/app/views/main_pages/structure.dart';
import '/app/views/main_pages/transfers/transfer/main.dart';
import '/app/views/notifications/notifications.dart';
import '/app/views/registration/account_activation.dart';
import '/app/views/registration/forgot_password.dart';
import '/app/views/registration/log_in.dart';
import '/app/views/registration/reset_password.dart';
import '/app/views/update_app.dart';
import '/app/views/web/web_view.dart';
import '/global/variables.dart';
import 'guard/auth_guard.dart';

class AppRoute {
  static const String home = 'home';
  static const String webView = 'web_view';
  static const String camera = 'camera';
  static const String addRecipient = 'add_recipient';
  static const String notifications = 'notifications';
  static const String editAccount = 'edit_account';
  static const String verifyAccount = 'verify_account';
  static const String support = 'support';
  static const String sendHub = 'send_hub';
  static const String checkOut = 'check_out';
  static const String payment = 'payment';
  static const String success = 'success';
  static const String recipient = 'recipient';
  static const String transfer = 'transfer';
  static const String logIn = 'log_in';
  static const String accountActivation = 'account_activation';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String updateApp = 'update_app';

  static GoRouter routes = GoRouter(
    initialLocation: '/',
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: Global.appSettings,
    navigatorKey: Global.key,
    debugLogDiagnostics: kDebugMode,
    errorBuilder: (context, state) => ErrorScreen('${state.error}'),
    routes: <GoRoute>[
      GoRoute(
        name: home,
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: Structure(query: state.queryParameters),
          );
        },
        routes: <GoRoute>[
          GoRoute(
            name: '/$camera',
            path: '$camera/:direction',
            builder: (BuildContext context, GoRouterState state) {
              return Camera(direction: state.pathParameters['direction']!);
            },
          ),
          GoRoute(
            name: '/$webView',
            path: '$webView/:url',
            builder: (BuildContext context, GoRouterState state) {
              return WebView(url: state.pathParameters['url']!);
            },
          ),
          GoRoute(
            path: notifications,
            builder: (BuildContext context, GoRouterState state) {
              return const Notifications();
            },
          ),
          GoRoute(
            path: editAccount,
            redirect: (BuildContext context, GoRouterState state) {
              return AuthGuard.isRedirect(state, logIn);
            },
            builder: (BuildContext context, GoRouterState state) {
              return const EditAccount();
            },
          ),
          GoRoute(
            path: verifyAccount,
            builder: (BuildContext context, GoRouterState state) {
              return const VerifyAccount();
            },
          ),
          GoRoute(
            path: support,
            builder: (BuildContext context, GoRouterState state) {
              return const Support();
            },
          ),
          GoRoute(
            name: transfer,
            path: '$transfer/:transfer',
            redirect: (BuildContext context, GoRouterState state) {
              return AuthGuard.isRedirect(state, logIn);
            },
            builder: (BuildContext context, GoRouterState state) {
              return TransferMain(state.pathParameters['transfer']!);
            },
          ),
          GoRoute(
            name: recipient,
            path: '$recipient/:recipient',
            redirect: (BuildContext context, GoRouterState state) {
              return AuthGuard.isRedirect(state, logIn);
            },
            builder: (BuildContext context, GoRouterState state) {
              return Recipient(state.pathParameters['recipient']!);
            },
          ),
          GoRoute(
            name: addRecipient,
            path: '$addRecipient/:recipient',
            redirect: (BuildContext context, GoRouterState state) {
              return AuthGuard.isRedirect(state, logIn);
            },
            builder: (BuildContext context, GoRouterState state) {
              return AddRecipient(
                recipient: state.pathParameters['recipient']!,
                query: state.queryParameters,
              );
            },
          ),
          GoRoute(
            name: sendHub,
            path: '$sendHub/:recipient',
            redirect: (BuildContext context, GoRouterState state) {
              return AuthGuard.isRedirect(state, logIn);
            },
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: SendHub(
                    recipient: state.pathParameters['recipient'] ?? 'null'),
                transitionsBuilder: (_, __, ___, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(__),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            name: success,
            path: '$success/:transfer',
            builder: (BuildContext context, GoRouterState state) {
              return Success(transferData: state.pathParameters['transfer']!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/$logIn',
        name: '/$logIn',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: const LogIn(),
          );
        },
      ),
      GoRoute(
        path: '/$accountActivation/:mobile',
        name: '/$accountActivation',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: AccountActivation(
              state.pathParameters['mobile']!,
              q: state.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: '/$forgotPassword',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: const ForgotPassword(),
          );
        },
      ),
      GoRoute(
        path: '/$resetPassword/:mobile',
        name: '/$resetPassword',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: ResetPassword(mobile: state.pathParameters['mobile']!),
          );
        },
      ),
      GoRoute(
        path: '/$updateApp',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            key: state.pageKey,
            child: const UpdateApp(),
          );
        },
      ),
    ],
  );

  static Future<GoRouter> get() async => routes;
}
