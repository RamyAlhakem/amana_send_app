// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

Widget createPlatformImage(String? url, {BoxFit fit = BoxFit.fill}) {
  if (url == null || url.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  final String viewType = 'img-${url.hashCode}';

  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final img = html.ImageElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%';

    if (fit == BoxFit.cover) {
      img.style.objectFit = 'cover';
    } else if (fit == BoxFit.contain) {
      img.style.objectFit = 'contain';
    } else if (fit == BoxFit.fill) {
      img.style.objectFit = 'fill';
    }

    // Remove crossOrigin completely so browser handles it natively without XHR constraint
    // img.crossOrigin = 'anonymous';

    return img;
  });

  return HtmlElementView(viewType: viewType);
}
