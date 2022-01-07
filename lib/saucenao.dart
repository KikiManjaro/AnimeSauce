import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';

class Saucenao {
  var api_key = "";
  var EnableRename = false;
  var minsim = '80!';

  var url;

  Saucenao() {
    url = 'https://saucenao.com/search.php?output_type=2&numres=1&minsim=' +
        minsim +
        '&dbmask=999' +
        '&api_key=' +
        api_key;
  }

  Future<Response> sendRequest(File img) async {
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(MultipartFile(
        'file', img.readAsBytes().asStream(), img.lengthSync(),
        filename: img.path.split("/").last));
    var streamedResponse = await request.send();
    return await Response.fromStream(streamedResponse);
  }

   Future<Map> search(File img) async {
    Response response = await sendRequest(img);
    if (response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<String> imgToB64img(File img) async {
    List<int> imageBytes = img.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  Future<String> compressFileTob64(File file) async {
    List<int> result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1280,
      minHeight: 720,
      quality: 90,
    );
    print(file.lengthSync());
    print(result.length);
    return base64Encode(result);
  }
}
