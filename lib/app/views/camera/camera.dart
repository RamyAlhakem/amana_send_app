import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '/app/views/camera/crop_image.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/loading.dart';
import '/global/variables.dart';
import '/helper/helper.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.direction, this.query = const {}});

  final String direction;
  final Map<String, String> query;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  late AppLocalizations arb;
  late PermissionStatus permissionStatus;
  late String imageOverlay;
  CameraLensDirection direction = CameraLensDirection.back;

  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;
  CameraController? cameraCtrl;
  FlashMode currentFlashMode = FlashMode.auto;

  Future<void> _setCameraCtrl(CameraDescription description) async {
    cameraCtrl = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraCtrl?.initialize().catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Helper.bannerWarning(arb.pleaseAllowAppToAccessCamera);
            break;
          default:
            debugPrint('error while initializing camera: $e');
        }
      }
    }).whenComplete(() {
      if (direction == CameraLensDirection.back) {
        if (cameraCtrl != null && cameraCtrl!.value.isInitialized) {
          cameraCtrl?.setFlashMode(currentFlashMode);
        }
      }
      if (mounted) setState(() {}); // refresh UI.
    });
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras.firstWhere(
      (CameraDescription camera) => camera.lensDirection == direction,
    );
    _setCameraCtrl(selectedCamera);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    imageOverlay = widget.query['overlay'] ?? '';
    if (widget.direction == 'front') direction = CameraLensDirection.front;
    initCamera();
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    permissionStatus = await Permission.camera.status;
    if (permissionStatus.isGranted) {
      if (cameraCtrl == null || !cameraCtrl!.value.isInitialized) {
        Global.snackKey.currentState?.hideCurrentMaterialBanner();
        if (mounted) _setCameraCtrl(selectedCamera);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraCtrl?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraCtrl == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AutoAppBar(title: arb.camera),
      body: _cameraPreview(),
    );
  }

  Widget _cameraPreview() {
    if (cameraCtrl != null && cameraCtrl!.value.isInitialized) {
      return Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: 1 / cameraCtrl!.value.aspectRatio,
              child: CameraPreview(cameraCtrl!),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/$imageOverlay.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            child: Column(
              children: [
                Button(
                  () async {
                    LoadingDialog().show();
                    XFile? rawImage = await takePicture();
                    XFile? croppedImage;
                    if (rawImage != null) {
                      croppedImage = await CropImage.crop(rawImage);
                    }
                    final Map<String, dynamic> image = {
                      'raw_image': rawImage,
                      'cropped': croppedImage,
                    };
                    LoadingDialog.dismiss();
                    if (context.mounted) context.pop(image);
                  },
                  height: 80,
                  width: 80,
                  borderRadius: 100,
                  color: Colors.white38,
                  borderColor: Colors.white,
                  borderWidth: 6,
                  const SizedBox.shrink(),
                ),
                const SizedBox(height: 30),
                // if (direction == CameraLensDirection.back)
                //   SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         InkWell(
                //           onTap: () async {
                //             setState(() => currentFlashMode = FlashMode.off);
                //             await cameraCtrl!.setFlashMode(
                //               FlashMode.off,
                //             );
                //           },
                //           child: Icon(
                //             Icons.flash_off,
                //             color: currentFlashMode == FlashMode.off
                //                 ? MainColors.color4
                //                 : Colors.white,
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () async {
                //             setState(() => currentFlashMode = FlashMode.auto);
                //             await cameraCtrl!.setFlashMode(FlashMode.auto);
                //           },
                //           child: Icon(
                //             Icons.flash_auto,
                //             color: currentFlashMode == FlashMode.auto
                //                 ? MainColors.color4
                //                 : Colors.white,
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () async {
                //             setState(() {
                //               currentFlashMode = FlashMode.torch;
                //             });
                //             await cameraCtrl!.setFlashMode(
                //               FlashMode.torch,
                //             );
                //           },
                //           child: Icon(
                //             Icons.highlight,
                //             color: currentFlashMode == FlashMode.torch
                //                 ? MainColors.color4
                //                 : Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Button(
          () => openAppSettings(),
          Text(
            arb.cameraPermission,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = cameraCtrl;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return null;
    }
  }
}
