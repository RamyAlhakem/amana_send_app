// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'dart:js_util' as js_util;

void registerCaptchaView(String viewType, String urlStr) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%'
      ..src = urlStr; // Load the actual URL natively
    return iframe;
  });
}
