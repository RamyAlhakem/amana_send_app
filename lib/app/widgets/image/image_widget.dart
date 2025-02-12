import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


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
    return Visibility(
      visible: url.isNotEmpty,
      replacement: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(asset, height: height, width: width, fit: fit),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        imageBuilder: (BuildContext _, imageProvider) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image(
              image: imageProvider,
              fit: fit,
              height: height,
              width: width,
            ),
          );
        },
        placeholder: (BuildContext __, url) {
          return Opacity(opacity: 0.1, child: Image.asset(asset, fit: fit));
        },
        errorWidget: (BuildContext ___, String url, error) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.asset(asset, height: height, width: width, fit: fit),
          );
        },
      ),
    );
  }
}
