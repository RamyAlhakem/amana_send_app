import 'package:flutter/material.dart';

/// Creates a network image for Flutter web.
///
/// Since Flutter 3.7+, `Image.network` on web automatically handles
/// cross-origin images by falling back to a native `<img>` element when
/// the server doesn't send CORS headers. This eliminates the need for
/// the old `HtmlElementView` platform-view workaround.
///
/// On the HTML renderer, `Image.network` always renders as `<img>`.
/// On CanvasKit (default since Flutter 3.7), it falls back to `<img>`
/// for cross-origin requests that lack `Access-Control-Allow-Origin`.
Widget createPlatformImage(String? url, {BoxFit fit = BoxFit.contain}) {
  if (url == null || url.isEmpty) {
    return const Icon(Icons.image, size: 24);
  }

  return Image.network(
    url,
    fit: fit,
    width: null, // let parent constrain
    height: null,
    errorBuilder: (context, error, stackTrace) {
      // Show a placeholder icon if the image fails to load.
      return const Icon(Icons.broken_image, size: 24);
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const SizedBox(
        width: 24,
        height: 24,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    },
  );
}
