import 'package:flutter/material.dart';
import 'platform_image.dart';

class CachedNetworkImageApp extends StatelessWidget {
  final String? urlImg;
  const CachedNetworkImageApp({super.key, this.urlImg});

  @override
  Widget build(BuildContext context) {
    return createPlatformImage(urlImg, fit: BoxFit.fill);
  }
}
