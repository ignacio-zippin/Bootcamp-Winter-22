import 'package:flutter/material.dart';

class LightSwitchModel {
  String location;
  IconData icon;
  LightSwitchModel.fromMap(data)
      : location = data['location'],
        icon = data['icon'];
}
