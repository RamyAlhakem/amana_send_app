import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/blurry_container.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/configs/configs.dart';
import '/global/variables.dart';
import '/helper/screen_size.dart';

class CaptchaDialog {
  CaptchaDialog({required this.onSubmit});

  Future<void> Function(String) onSubmit;

  void show() {
    final BuildContext context = Global.key.currentContext!;
    double progress = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      barrierColor: Colors.black26,
      builder: (BuildContext _) {
        return StatefulBuilder(builder: (__, setState) {
          return BlurryContainer(
            child: AlertDialog(
              scrollable: true,
              title: Column(
                children: [
                  TextX(
                    'Captcha verification',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const HDivider(),
                ],
              ),
              titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(8, 5, 8, 10),
              content: SizedBox(
                height: ScreenSize.height * 0.65,
                width: ScreenSize.width,
                child: Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse('${Configs.apiUrl}/captcha'),
                      ),
                      onProgressChanged: (InAppWebViewController _, int p) {
                        setState(() => progress = p / 100);
                      },
                      onLoadStart: (InAppWebViewController ctrl, Uri? _) {
                        ctrl.addJavaScriptHandler(
                          handlerName: 'callHandler',
                          callback: (List<dynamic> args) async {
                            if (args.first.toString().isNotEmpty) {
                              dismiss();
                              await onSubmit(args.first);
                            }
                          },
                        );
                      },
                    ),
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
                        child:
                            CircularProgressIndicator(color: MainColors.color1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
