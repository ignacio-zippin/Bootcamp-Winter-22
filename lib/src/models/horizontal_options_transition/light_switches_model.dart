import 'package:flutter/material.dart';

class LightSwitchModel {
  String location;
  String power;
  IconData icon;
  LightSwitchModel.fromMap(data)
      : location = data['location'],
        power = data['power'],
        icon = data['icon'];
}
