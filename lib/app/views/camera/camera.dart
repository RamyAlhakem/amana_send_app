import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/global/variables.dart';
import '/helper/helper.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.direction});

  final String direction;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  late AppLocalizations arb;
  late PermissionStatus permissionStatus;
  CameraLensDirection direction = CameraLensDirection.back;
  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;
  CameraController? cameraCtrl;

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
            Helper.bannerWarning('Please allow app to access camera');
            break;
          default:
            debugPrint('error while initializing camera: $e');
        }
      }
    }).whenComplete(() {
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
    if (cameraCtrl == null || !cameraCtrl!.value.isInitialized) {
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
              aspectRatio: cameraCtrl!.value.aspectRatio,
              child: CameraPreview(cameraCtrl!),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.3,
                child: Image.network(
                  'https://picsum.photos/3000/4000',
                  fit: BoxFit.fill,
                ),
              ),
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
}
