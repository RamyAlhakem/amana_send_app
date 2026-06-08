import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';

import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/loading.dart';
import '/app/widgets/dotted_border/dotted_border.dart';
import '/app/widgets/image/image_widget.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/https/api/upload_photo.dart';
import '/router/app_route.dart';
import '/tools/attachment_tools.dart';
import 'image_pick_source.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({
    super.key,
    required this.url,
    required this.onChange,
    this.title,
    this.height,
    this.asset,
    this.direction = 'back',
  });

  final String url;
  final void Function(int) onChange;

  final String? title;
  final double? height;
  final String? asset;
  final String direction;

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick>
    with AutomaticKeepAliveClientMixin {
  late AppLocalizations? _arb;
  late String direction;

  final ImagePicker _picker = ImagePicker();
  File? file;

  final double imageRadius = 15;
  String imageTitle = '';
  String overlay = 'rectangle';
  String? overlayView;

  @override
  void initState() {
    super.initState();
    direction = widget.direction;
    overlay = direction == 'front' ? 'oval' : 'rectangle';
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    if (file != null || widget.url.isNotEmpty) {
      imageTitle = _arb!.changeImage;
    } else if (widget.url.isEmpty || file == null) {
      imageTitle = _arb!.uploadImage;
    }
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextX(widget.title ?? _arb!.uploadDocumentImage),
            ),
            Button(
              () => _pickSource(),
              borderRadius: 100,
              Row(children: [
                const HeroIcon(HeroIcons.camera, size: 20, color: Colors.white),
                const SizedBox(width: 6),
                TextX(
                  imageTitle.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            if (widget.url.isNotEmpty || file != null) {
              AttachmentTools.openImage(
                context,
                fil: file,
                url: widget.url,
                overlay: overlayView,
              );
            } else {
              _pickSource();
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: DottedBorder(
            borderType: BorderType.rRect,
            radius: const Radius.circular(20),
            padding: const EdgeInsets.all(8),
            dashPattern: const [8, 8],
            color: Theme.of(context).dividerColor,
            child: Visibility(
              visible: file == null,
              replacement: ClipRRect(
                borderRadius: BorderRadius.circular(imageRadius),
                child: kIsWeb
                    ? Image.network(
                        file?.path ?? '',
                        height: widget.height ?? 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        file ?? File('path'),
                        height: widget.height ?? 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
              ),
              child: ImageWidget(
                widget.url,
                asset: widget.asset ?? 'assets/images/id_icon.png',
                height: widget.height ?? 180,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                radius: imageRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openCamera() async {
    await context.pushNamed(
      '/${AppRoute.camera}',
      pathParameters: <String, String>{'direction': direction},
      queryParameters: <String, String>{'overlay': overlay},
    ).then((map) {
      if (map is Map && map['raw_image'] != null && map['cropped'] != null) {
        uploadImage(map['cropped'], map['raw_image']);
      }
    }).whenComplete(() => setState(() => overlayView = overlay));
  }

  Future<void> imagePicker() async {
    LoadingDialog().show();

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );

    if (image == null) return LoadingDialog.dismiss();

    setState(() => overlayView = null);
    uploadImage(image, image).whenComplete(() => LoadingDialog.dismiss());
  }

  Future<void> uploadImage(XFile? image, XFile fileView) async {
    if (image == null) return;

    setState(() => file = File(fileView.path));
    await UploadPhoto(
      files: <String, XFile>{'photo': image},
    ).request().then((id) {
      setState(() {
        if (id != 0) {
          widget.onChange(id);
          imageTitle = _arb!.changeImage;
        } else {
          Helper.toast(_arb!.oops);
          setState(() => file = null);
        }
      });
    });
  }

  void _pickSource() {
    if (widget.direction == 'front') {
      openCamera(); // selfie
    } else {
      ImagePickSource.select(
        camera: () => openCamera(),
        gallery: () => imagePicker(),
      );
    }
  }
}
