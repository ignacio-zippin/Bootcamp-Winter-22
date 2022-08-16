import 'package:flutter/material.dart';
import 'package:playground_app/src/models/horizontal_options_transition/home_model.dart';
import 'package:playground_app/src/providers/app_provider.dart';
import 'package:playground_app/values/k_colors.dart';

// ignore: must_be_immutable
class AnimatedCircle extends AnimatedWidget {
  final Tween<double> tween;
  Tween<double>? horizontalTween;
  final Animation<double> animation;
  Animation<double>? horizontalAnimation;
  final double flip;
  final Color color;
  HomeModel homeModel = HomeModel();

  AnimatedCircle({
    Key? key,
    required this.animation,
    this.horizontalTween,
    this.horizontalAnimation,
    required this.color,
    required this.flip,
    required this.tween,
  })  : assert(flip == 1 || flip == -1),
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.centerLeft,
      transform: Matrix4.identity()
        ..scale(
          tween.evaluate(animation) * flip,
          tween.evaluate(animation),
        ),
      child: Transform(
        transform: Matrix4.identity()
          ..translate(
            horizontalTween != null
                ? horizontalTween!.evaluate(horizontalAnimation!)
                : 0.0,
          ),
        child: Container(
          width: homeModel.radius,
          height: homeModel.radius,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              homeModel.radius! / 2.0 -
                  tween.evaluate(animation) / (homeModel.radius! / 2.0),
            ),
          ),
          child: Icon(
            flip == 1 ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
            color: AppProvider().index % 2 == 0 ? KWhite : KBlue_L1,
          ),
        ),
      ),
    );
  }
}
