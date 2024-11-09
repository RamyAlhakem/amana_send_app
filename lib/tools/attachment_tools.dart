import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../app/theme/colors/main_colors.dart';
import '/app/widgets/blurry_container.dart';
import '/configs/configs.dart';

class AttachmentTools {
  static ImageProvider image(String url) => CachedNetworkImageProvider(url);
  static ImageProvider file(String path) => FileImage(File(path));

  static void openImage(
    BuildContext context, {
    File? fil,
    required String url,
    String? overlay,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Theme.of(context).cardColor.withOpacity(0.1),
      elevation: 0,
      isScrollControlled: true,
      builder: (BuildContext _) => BlurryContainer(
        color: Colors.transparent,
        sigmaX: 10,
        sigmaY: 10,
        radius: 30,
        child: FractionallySizedBox(
          heightFactor: 0.85,
          child: Stack(
            children: [
              PhotoViewGallery(
                pageOptions: [
                  PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered,
                    imageProvider: fil == null
                        ? image(url)
                        : file(fil.path),
                  )
                ],
                loadingBuilder: (BuildContext __, ImageChunkEvent? p) {
                  return Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: p == null
                            ? 0
                            : p.cumulativeBytesLoaded /
                                (p.expectedTotalBytes ?? 0),
                        color: MainColors.color1,
                      ),
                    ),
                  );
                },
                backgroundDecoration: const BoxDecoration(),
              ),
              if (overlay != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/$overlay.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
