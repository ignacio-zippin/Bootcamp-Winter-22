import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class Sliver3DPageController extends ControllerMVC implements IViewController {
  static late Sliver3DPageController _this;

  factory Sliver3DPageController() {
    _this = Sliver3DPageController._();
    return _this;
  }

  static Sliver3DPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  Sliver3DPageController._();


  @override
  void initPage({PageArgs? arguments}) {
  }

  @override
  disposePage() {}

  onPressBack() {
    PageManager().goBack();
  }
}
