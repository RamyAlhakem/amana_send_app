// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerCaptchaView(String viewType, String urlStr) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';

    if (urlStr.trimLeft().startsWith('<')) {
      iframe.srcdoc = urlStr;
    } else {
      iframe.src = urlStr;
    }

    iframe.sandbox?.add('allow-scripts');
    iframe.sandbox?.add('allow-same-origin');
    iframe.sandbox?.add('allow-forms');
    iframe.sandbox?.add('allow-popups');
    return iframe;
  });
}
