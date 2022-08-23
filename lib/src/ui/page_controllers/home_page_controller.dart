import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class HomePageController extends ControllerMVC implements IViewController {
  static late HomePageController _this;

  factory HomePageController() {
    _this = HomePageController._();
    return _this;
  }

  static HomePageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  HomePageController._();

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  onPressExample1() {
    PageManager().goExample1Page();
  }

  onPressScrollAndMenu(){
    PageManager().goScrollAndMenuPage();
  }
}
