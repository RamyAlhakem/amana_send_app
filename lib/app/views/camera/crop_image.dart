import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class CropImage {
  static int targetWidth = 380;
  static int targetHeight = 550;

  static Future<XFile> crop(XFile rawImage) async {
    XFile croppedXFile = rawImage;
    final bytes = await rawImage.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image != null) {
      // Calculate the starting coordinates for cropping
      int startX = (image.width - image.width * .9) ~/ 2;
      int startY = (image.height - image.height * .7) ~/ 2;
      img.Image resizedImage = img.copyCrop(
        image,
        x: startX,
        y: startY,
        width: (image.width * .9).toInt(),
        height: (image.height * .7).toInt(),
      );

      // Generate an XFile from the cropped bytes (works on web and mobile)
      croppedXFile = XFile.fromData(
        img.encodeJpg(resizedImage),
        name: 'resized_image.jpg',
        mimeType: 'image/jpeg',
      );
    }

    return croppedXFile;
  }
}
