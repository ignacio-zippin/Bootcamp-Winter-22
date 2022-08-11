import 'package:flutter/material.dart';
import 'package:playground_app/values/k_colors.dart';

class HomeModel {
  List<Color>? palette;
  double? scale;
  double? radius;
  double? bottomPadding;

  HomeModel({
    this.palette = const [KWhite, KBlue_L1],
    this.scale = 1,
    this.radius = 88.0,
    this.bottomPadding = 75.0,
  });
}
