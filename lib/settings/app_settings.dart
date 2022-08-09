import 'dart:convert';
import 'package:flutter/material.dart';

class AppSettings {
  static String? apiUrl;

  static Future<void> init(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("lib/settings/app_settings.json");
    final jsonResult = json.decode(data);
    apiUrl = jsonResult["api_url"];
  }
}
