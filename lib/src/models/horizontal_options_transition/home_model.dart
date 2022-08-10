import 'package:flutter/material.dart';
import 'package:playground_app/values/k_colors.dart';

class HomeModel extends ChangeNotifier {
  static const List<Color> palette = [KWhite, KBlue_L1];
  static const double scale = 1;
  static const double radius = 88.0;
  static const double bottomPadding = 75.0;

  int _index = 0;
  get index => _index;
  set index(value) {
    _index = value;
    notifyListeners();
  }

  final bool _isHalfway = false;
  get isHalfway => isHalfway;
  set isHalfway(value) {
    _index = value;
    notifyListeners();
  }

  final bool _isToggled = false;
  get isToggled => _isToggled;
  set isToggled(value) {
    _index = value;
    notifyListeners();
  }

  Color _backgroundColor = HomeModel.palette[0];
  get backgroundColor => _backgroundColor;
  set backgroundColor(value) {
    _backgroundColor = value;
    notifyListeners();
  }

  Color _foregroundColor = HomeModel.palette[1];
  get foregroundColor => _foregroundColor;
  set foregroundColor(value) {
    _foregroundColor = value;
    notifyListeners();
  }

  void swapColors() {
    if (_isToggled) {
      _backgroundColor = HomeModel.palette[1];
      _foregroundColor = HomeModel.palette[0];
    } else {
      _backgroundColor = HomeModel.palette[0];
      _foregroundColor = HomeModel.palette[1];
    }

    notifyListeners();
  }
}
