import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class ShapesAndAnimationsPageController extends ControllerMVC
    implements IViewController {
  static late ShapesAndAnimationsPageController _this;

  factory ShapesAndAnimationsPageController() {
    _this = ShapesAndAnimationsPageController._();
    return _this;
  }

  static ShapesAndAnimationsPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  ShapesAndAnimationsPageController._();

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  onBack() {
    PageManager().goBack();
  }
}
