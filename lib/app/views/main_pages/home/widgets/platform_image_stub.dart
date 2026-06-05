import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget createPlatformImage(String? url, {BoxFit fit = BoxFit.fill}) {
  if (url == null || url.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
