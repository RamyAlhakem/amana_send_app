import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/app/views/main_pages/account/verify/components/image_pick_source.dart';
import '/app/views/main_pages/account/verify/components/remove_image_icon.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/loading.dart';
import '/app/widgets/horizontal_view.dart';
import '/app/widgets/image/image_widget.dart';
import '/https/api/upload_photo.dart';

class MultipleImagePick extends StatefulWidget {
  const MultipleImagePick({
    super.key,
    this.urls = const <String>[],
    required this.onChange,
  });

  final List<String> urls;
  final void Function(int) onChange;

  @override
  State<MultipleImagePick> createState() => _MultipleImagePickState();
}

class _MultipleImagePickState extends State<MultipleImagePick>
    with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();

  List<File?> files = <File?>[];

  int serverId = 0;
  int length = 0;

  @override
  void initState() {
    super.initState();
    if (widget.urls.isNotEmpty) {
      length = widget.urls.length;
      files = List.generate(length, (index) => null);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: HorizontalView([
        if (widget.urls.isNotEmpty || files.isNotEmpty)
          SizedBox(
            height: 75,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: length,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                return Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (widget.urls.isNotEmpty || files[i] != null)
                          Visibility(
                            visible: files[i] == null,
                            replacement: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                files[i] ?? File('path'),
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ImageWidget(
                              widget.urls[i],
                              asset: 'assets/images/id_icon.png',
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                              radius: 4,
                            ),
                          ),
                        if (files[i] != null)
                          RemoveImageIcon(
                            () => setState(() {
                              files.removeAt(i);
                              widget.urls.removeAt(i);
                              length -= 1;
                              widget.onChange(serverId);
                            }),
                            topPosition: -20,
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          ),
        Visibility(
          visible: files.length < 4,
          child: Button(
            () => ImagePickSource.select(
              camera: () => _imagePicker(ImageSource.camera),
              gallery: () => _imagePicker(ImageSource.gallery),
            ),
            height: 75,
            width: 70,
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 20,
              color: Theme.of(context).iconTheme.color,
            ),
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ]),
    );
  }

  Future<void> _imagePicker(ImageSource source) async {
    LoadingDialog().show();

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 30,
    );

    if (image == null) return LoadingDialog.dismiss();

    setState(() {
      files.add(File(image.path));
      widget.urls.add('');
      length += 1;
    });

    UploadPhoto(
      files: <String, XFile>{'photo': image},
    ).request().then((id) {
      if (id != 0) {
        serverId = id;
        widget.onChange(id);
      }
    }).whenComplete(() => LoadingDialog.dismiss());
  }
}
