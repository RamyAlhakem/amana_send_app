import 'package:flutter/material.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/loading_animations/build_loading_animation.dart';
import '/global/variables.dart';

class LoadingDialog {
  LoadingDialog({this.loader, this.barrierColor});

  final Widget? loader;
  final Color? barrierColor;

  void show() {
    final BuildContext context = Global.key.currentContext!;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.15),
      builder: (BuildContext _) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                loader ??
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: 70,
                        secondRingColor: MainColors.color1,
                        thirdRingColor: MainColors.color2,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void dismiss() => Navigator.pop(Global.key.currentContext!);
}
