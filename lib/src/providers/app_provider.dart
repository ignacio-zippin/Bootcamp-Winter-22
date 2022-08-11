import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground_app/src/enums/culture.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/models/culture_model.dart';
import 'package:playground_app/src/models/horizontal_options_transition/home_model.dart';

class AppProvider with ChangeNotifier {
  static final AppProvider _instance = AppProvider._constructor();

  factory AppProvider() {
    return _instance;
  }

  AppProvider._constructor();

  List<CultureModel> languageList = [
    CultureModel(id: 1, language: "Español", code: Culture.es),
    CultureModel(id: 2, language: "Inglés", code: Culture.en),
  ];

  Timer? _timer;
  Timer? get timer => _timer;

  Timer? _timerInit;
  Timer? get timerInit => _timerInit;

  init() {
    _homeModel = HomeModel();
    _backgroundColor = _homeModel!.palette![0];
    _isHalfway = false;
    _isToggled = false;
    _foregroundColor = _homeModel!.palette![1];
  }

  closeAlert() {
    _timerInit?.cancel();
    ScaffoldMessenger.of(PageManager().navigatorKey.currentContext!)
        .hideCurrentMaterialBanner();
  }

  HomeModel? _homeModel;
  bool? _isHalfway;
  bool? _isToggled;
  Color? _backgroundColor;
  Color? _foregroundColor;

  int _index = 0;
  get index => _index;
  set index(value) {
    _index = value;
    notifyListeners();
  }

  get isHalfway => _isHalfway;
  set isHalfway(value) {
    _isHalfway = value;
    notifyListeners();
  }

  get isToggled => _isToggled;
  set isToggled(value) {
    _isToggled = value;
    notifyListeners();
  }

  get backgroundColor => _backgroundColor;
  set backgroundColor(value) {
    _backgroundColor = value;
    notifyListeners();
  }

  get foregroundColor => _foregroundColor;
  set foregroundColor(value) {
    _foregroundColor = value;
    notifyListeners();
  }

  void swapColors() {
    if (_isToggled!) {
      _backgroundColor = _homeModel!.palette![1];
      _foregroundColor = _homeModel!.palette![0];
    } else {
      _backgroundColor = _homeModel!.palette![0];
      _foregroundColor = _homeModel!.palette![1];
    }

    notifyListeners();
  }
}
