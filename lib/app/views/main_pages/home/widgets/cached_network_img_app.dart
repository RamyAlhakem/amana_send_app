import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageApp extends StatelessWidget {
  final String? urlImg;
  const CachedNetworkImageApp({super.key, this.urlImg});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlImg??"",
      fit: BoxFit.fill,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
