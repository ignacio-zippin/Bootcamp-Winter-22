import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class ImageModel {
  final int? id;
  final String? path;
  final String? url;

  ImageModel({this.id, this.path, this.url});

  factory ImageModel.fromMap(Map<String, dynamic> json) {
    try {
      return ImageModel(
        id: json['imageId'].toInt(),
        path: json['path'],
        url: json['imageUrl'],
      );
    } catch (ex) {
      log(ex.toString() + "fromMap ImageModel:" + json['imageId'].toString());
      return ImageModel();
    }
  }

  Map<String, dynamic> toMap() => {
    "imageId": id,
    "path": path,
    "imageUrl": url,
  };

  Map<String, dynamic> toApi() => {
    "imageId": url != null ? "$id" : null,
    "fileName": "$id.jpg",
    "mimeType": "image/jpeg",
    "base64": getBase64(),
  };

  getBase64() {
    if (url != null) {
      return null;
    }

    if (path != null) {
      File img = File.fromUri(Uri.parse(path!));
      var bytes = img.readAsBytesSync();
      var result = base64.encode(bytes);
      return result;
    } else {
      return null;
    }
    //return 'base64encodedHere';
  }
}