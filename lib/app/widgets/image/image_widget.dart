import 'package:flutter/material.dart';
import '/app/views/main_pages/home/widgets/platform_image.dart';
import '/configs/configs.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.url, {
    this.asset = 'assets/images/icon.png',
    this.fit = BoxFit.contain,
    this.radius = 3.0,
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);

  final String url;
  final String asset;
  final BoxFit fit;
  final double radius;
  final double? height, width;

  /// Resolves the image URL. If the URL is relative (no scheme), it is
  /// prefixed with [Configs.storageUrl] so it works on web where the browser
  /// would otherwise resolve it against the page origin.
  String _resolveUrl(String raw) {
    if (raw.isEmpty) return raw;
    final trimmed = raw.trim();
    // Already an absolute URL (has scheme like https://)
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    // Relative URL — prepend the storage base URL.
    return '${Configs.storageUrl}$trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedUrl = _resolveUrl(url);

    if (resolvedUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(asset, height: height, width: width, fit: fit),
      );
    }

    final Widget image = createPlatformImage(resolvedUrl, fit: fit);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: image,
      ),
    );
  }
}
