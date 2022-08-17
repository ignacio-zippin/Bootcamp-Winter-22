import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playground_app/src/enums/horizontal_options_transition/lightswitches_enum.dart';
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

  //Light Switches
  final List<double> _sliderValues = [1.0, 1.0, 1.0];
  List get sliderValues => _sliderValues;
  void setSliderValue(index, value) {
    setState(ViewState.busy);
    _sliderValues[index] = value;
    notifyListeners();
  }

  double getFormula(index, width) =>
      lswBoxWidth +
      sliderValues[index] * (width - lswBoxWidth * 2 - lswSidePadding * 2);

  double getStartWidth(width) => width - lswSidePadding * 2 - lswBoxWidth;

  final List<double?> _widthValues = [null, null, null];
  get widthValues => _widthValues;
  void setWidth(index, width) {
    if (switchValues[index]) {
      _widthValues[index] = getFormula(index, width);
    } else {
      _widthValues[index] = width - lswSidePadding * 4;
    }
    notifyListeners();
  }

  ViewState _state = ViewState.idle;
  get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  final List<bool> _switchValues = [true, true, true];
  List get switchValues => _switchValues;
  void setSwitchValues(index, value) {
    setState(ViewState.idle);
    _switchValues[index] = value;
    notifyListeners();
  }
}
