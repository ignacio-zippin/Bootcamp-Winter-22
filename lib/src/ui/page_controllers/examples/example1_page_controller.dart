import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class Example1PageController extends ControllerMVC implements IViewController {
  static late Example1PageController _this;

  factory Example1PageController() {
    _this = Example1PageController._();
    return _this;
  }

  static Example1PageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  Example1PageController._();

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  onBack() {
    PageManager().goBack();
  }
}
