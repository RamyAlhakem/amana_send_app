// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import '/configs/configs.dart';

final Set<String> _registeredViewTypes = {};

/// Resolves relative URLs against [Configs.storageUrl].
/// Backend may return relative paths like `files/123.png`; on web the browser
/// would otherwise resolve those against the page origin, so we prefix the storage base.
String _resolveUrl(String? raw) {
  if (raw == null || raw.isEmpty) return raw ?? '';
  final url = raw.trim();
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return '${Configs.storageUrl}$url';
}

/// Creates a network image for Flutter web using HtmlElementView.
///
/// Uses the native browser `<img>` element to work without CORS restrictions.
/// On debug builds Flutter web uses the HTML renderer (which renders images
/// natively), but release builds use **CanvasKit** — and CanvasKit's
/// `Image.network` requires `Access-Control-Allow-Origin` from the server.
/// If the storage server lacks CORS headers, all images fail silently in
/// release. This HtmlElementView approach avoids that entirely.
Widget createPlatformImage(String? rawUrl, {BoxFit fit = BoxFit.contain}) {
  final url = _resolveUrl(rawUrl);
  if (url.isEmpty) {
    return const Icon(Icons.image, size: 24);
  }

  final viewType = 'network-img-${url.hashCode}';

  if (!_registeredViewTypes.contains(viewType)) {
    try {
      ui_web.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewId) {
          final img = html.ImageElement()
            ..src = url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = _fitToCss(fit)
            ..onError.listen((_) {
              debugPrint('Failed to load image: $url');
            });

          return html.DivElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..append(img);
        },
      );
      _registeredViewTypes.add(viewType);
    } catch (e) {
      debugPrint('Failed to register view factory: $e');
      return const Icon(Icons.broken_image, size: 24);
    }
  }

  return SizedBox.expand(
    child: HtmlElementView(viewType: viewType),
  );
}

String _fitToCss(BoxFit fit) {
  switch (fit) {
    case BoxFit.cover:
      return 'cover';
    case BoxFit.contain:
      return 'contain';
    case BoxFit.fill:
      return 'fill';
    case BoxFit.fitWidth:
      return '100% auto';
    case BoxFit.fitHeight:
      return 'auto 100%';
    case BoxFit.none:
      return 'none';
    case BoxFit.scaleDown:
      return 'scale-down';
  }
}
