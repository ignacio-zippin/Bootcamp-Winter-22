import 'package:flutter/material.dart';

class RectangleClipper extends CustomClipper<Rect> {
  final double offset;
  RectangleClipper({required this.offset});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(offset, 0.0, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(RectangleClipper oldClipper) => true;
}
