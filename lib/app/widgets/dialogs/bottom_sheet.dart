import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/divider.dart';
import '/configs/configs.dart';
import '/global/variables.dart';
import '/helper/helper.dart';

class BottomSheeter {
  BottomSheeter({
    required this.onSubmit,
  });

  Future<void> Function(String) onSubmit;

  static const _border = BorderRadius.vertical(top: Radius.circular(25));
  Future<void> show() async {
    final BuildContext context = Global.key.currentContext!;
    double progress = 0;
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
                  AutoAppBar(
                    title: '',
                    bGColor: Colors.transparent,
                    titleStyle: Theme.of(context).textTheme.bodyLarge,
                    iconColor: Theme.of(context).iconTheme.color,
                    onPressed: () => dismiss(),
                  ),
                  const HDivider(height: 1),

                  // content:
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: Uri.parse('${Configs.apiUrl}captcha'),
                          ),
                          onProgressChanged: (InAppWebViewController _, int p) {
                            set(() => progress = p / 100);
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
                          child: CircularProgressIndicator(
                            color: MainColors.color1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // -:
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
