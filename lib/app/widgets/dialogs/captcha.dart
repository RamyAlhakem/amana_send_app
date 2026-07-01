import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import 'captcha_stub.dart' if (dart.library.js_interop) 'captcha_web.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/divider.dart';
import '/configs/configs.dart';
import '/global/variables.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';

class CaptchaDialog {
  CaptchaDialog({required this.onSubmit});
  final Future<void> Function(String) onSubmit;

  static const _border = BorderRadius.vertical(top: Radius.circular(25));

  Future<void> show() async {
    final BuildContext context = Global.key.currentContext!;
    double progress = 0;

    StreamSubscription<html.MessageEvent>? messageSubscription;
    String? webHtmlData;
    final String webCaptchaViewType =
        'captcha-iframe-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      // On Web, fetch the captcha HTML from the server and inject a postMessage callback.
      try {
        final response = await http.get(Uri.parse('${Configs.apiUrl}captcha'));
        if (response.statusCode == 200) {
          webHtmlData = response.body.replaceAll(
            "window.flutter_inappwebview.callHandler('callHandler', response);",
            "window.parent.postMessage('captcha:' + response, '*');" +
                "window.location.href = '${Configs.apiUrl}captcha-success?token=' + response;",
          );
        }
      } catch (e) {
        Helper.log('Captcha HTML load error: $e', color: DebugColor.red);
      }

      registerCaptchaView(
        webCaptchaViewType,
        webHtmlData ?? '${Configs.apiUrl}captcha',
      );
      progress = 1.0;
      messageSubscription = html.window.onMessage.listen((event) async {
        final data = event.data.toString();
        if (data.startsWith('captcha:')) {
          final token = data.replaceFirst('captcha:', '');
          if (token.isNotEmpty) {
            messageSubscription?.cancel();
            dismiss();
            await onSubmit(token);
          }
        }
      });
    }

    await showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      barrierColor: context.isDarkMode ? Colors.white10 : Colors.black26,
      shape: const RoundedRectangleBorder(borderRadius: _border),
      builder: (BuildContext _) {
        return GestureDetector(
          onTap: () => Helper.unFocusCursor(context),
          child: StatefulBuilder(builder: (___, set) {
            return ClipRRect(
              borderRadius: _border,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appbar:
                  AppBar(),
                  const HDivider(height: 1),

                  // loader:
                  Visibility(
                    visible: progress < 1,
                    child: SizedBox(
                      height: 7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          color: Colors.blueGrey,
                          backgroundColor: Colors.blueGrey.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: progress < 1,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: MainColors.color1,
                      ),
                    ),
                  ),

                  // captcha view:
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: kIsWeb
                          ? webHtmlData != null
                              ? HtmlElementView(
                                  viewType: webCaptchaViewType,
                                )
                              : Center(
                                  child: Text(
                                    'Unable to load captcha. Please refresh.',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                          : InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: WebUri('${Configs.apiUrl}captcha'),
                              ),
                              initialData: null,
                              onConsoleMessage:
                                  (controller, consoleMessage) async {
                                if (kIsWeb &&
                                    consoleMessage.message
                                        .startsWith('captcha:')) {
                                  final token = consoleMessage.message
                                      .replaceFirst('captcha:', '');
                                  if (token.isNotEmpty) {
                                    dismiss();
                                    await onSubmit(token);
                                  }
                                }
                              },
                              onProgressChanged:
                                  (InAppWebViewController _, int p) {
                                set(() => progress = p / 100);
                              },
                              onLoadStart: (InAppWebViewController ctrl,
                                  WebUri? url) async {
                                if (kIsWeb &&
                                    url != null &&
                                    url
                                        .toString()
                                        .contains('captcha-success?token=')) {
                                  final token =
                                      url.queryParameters['token'] ?? '';
                                  if (token.isNotEmpty) {
                                    dismiss();
                                    await onSubmit(token);
                                  }
                                  return;
                                }

                                if (!kIsWeb) {
                                  ctrl.addJavaScriptHandler(
                                    handlerName: 'callHandler',
                                    callback: (List<dynamic> args) async {
                                      if (args.first.toString().isNotEmpty) {
                                        dismiss();
                                        await onSubmit(args.first);
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );

    messageSubscription?.cancel();
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
