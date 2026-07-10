import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget createPlatformImage(String? url, {BoxFit fit = BoxFit.contain}) {
  if (url == null || url.isEmpty) {
    return const Icon(Icons.broken_image, size: 24);
  }

  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (context, url) => const SizedBox(
      width: 24,
      height: 24,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    ),
    errorWidget: (context, url, error) =>
        const Icon(Icons.broken_image, size: 24),
  );
}
