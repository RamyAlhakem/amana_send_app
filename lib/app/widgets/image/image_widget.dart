import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/app/views/main_pages/home/widgets/platform_image.dart';

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

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(asset, height: height, width: width, fit: fit),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: createPlatformImage(url, fit: fit),
      ),
    );
  }
}
