import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class ScrollAndMenuPageController extends ControllerMVC implements IViewController {
  static late ScrollAndMenuPageController _this;

  factory ScrollAndMenuPageController() {
    _this = ScrollAndMenuPageController._();
    return _this;
  }

  static ScrollAndMenuPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  ScrollAndMenuPageController._();


  @override
  void initPage({PageArgs? arguments}) {
  }

  @override
  disposePage() {}

  onPressBack() {
    PageManager().goBack();
  }
}
