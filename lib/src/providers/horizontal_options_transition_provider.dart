import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playground_app/values/k_values.dart';

class HorizontalOptionsTransitionProvider extends ChangeNotifier {
  int _index = 0;
  get index => _index;
  set index(value) {
    _index = value;
    notifyListeners();
  }

  bool _isHalfWay = false;
  get isHalfWay => _isHalfWay;
  set isHalfWay(value) {
    _isHalfWay = value;
    notifyListeners();
  }

  bool _isToggled = false;
  get isToggled => _isToggled;
  set isToggled(value) {
    _isToggled = value;
    notifyListeners();
  }

  void swapColors() {
    if (_isToggled) {
      _backGroundColor = hotPalette[1];
      _foreGroundColor = hotPalette[0];
    } else {
      _backGroundColor = hotPalette[0];
      _foreGroundColor = hotPalette[1];
    }
    notifyListeners();
  }

  Color _backGroundColor = hotPalette[0];
  get backGroundColor => _backGroundColor;
  set backGroundColor(value) {
    _backGroundColor = value;
    notifyListeners();
  }

  Color _foreGroundColor = hotPalette[1];
  get foreGroundColor => _foreGroundColor;
  set foreGroundColor(value) {
    _foreGroundColor = value;
    notifyListeners();
  }
}
