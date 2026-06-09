import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '/configs/configs.dart';
import '/global/variables.dart';

class UploadPhoto {
  // This is a restful API request.

  UploadPhoto({required this.files});

  final Map<String, XFile> files;

  static String _auth() {
    String authorization = '';
    if (Global.appSettings.token.isNotEmpty) {
      authorization = 'Bearer ${Global.appSettings.token}';
    }
    return authorization;
  }

  Future<int> request() async {
    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(Configs.apiRestPhoto),
    );

    for (final entry in files.entries) {
      final file = entry.value;
      final bytes = await file.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(entry.key, bytes, filename: file.name),
      );
    }

    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    if (Global.appSettings.token.isNotEmpty) {
      request.headers.addAll({'Authorization': _auth()});
    }

    final http.StreamedResponse response = await request.send();
    final String data = await response.stream.bytesToString();

    final Map<String, dynamic> result = {
      'statusCode': response.statusCode,
      'data': data,
    };

    int id = 0;

    if (result['statusCode'] == 200) {
      if (result['data'] != null && result['data'].toString().isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(result['data']);
        if (data['id'] != null) id = int.parse(data['id'].toString());
      }
    }

    return id;
  }
}
