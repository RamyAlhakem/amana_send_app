import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CropImage {
  static int targetWidth = 380;
  static int targetHeight = 550;

  static Future<XFile> crop(XFile rawImage) async {
    XFile croppedXFile = rawImage;
    img.Image? image = img.decodeImage(File(rawImage.path).readAsBytesSync());
    if (image != null) {
      // Calculate the starting coordinates for cropping
      int startX = (image.width - image.width * .8) ~/ 2;
      int startY = (image.height - image.height * .6) ~/ 2;
      img.Image resizedImage = img.copyCrop(
        image,
        x: startX,
        y: startY,
        width: (image.width * .8).toInt(),
        height: (image.height * .6).toInt(),
      );

      // Get the app's writable directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Generate a unique filename for the resized image
      String resizedImagePath = '$appDocPath/resized_image.jpg';

      File tempFile = File(resizedImagePath);
      tempFile.writeAsBytesSync(img.encodeJpg(resizedImage));

      croppedXFile = XFile(tempFile.path);
    }

    return croppedXFile;
  }
}
