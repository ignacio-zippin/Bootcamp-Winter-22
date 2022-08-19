import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class SliverPageController extends ControllerMVC implements IViewController {
  static late SliverPageController _this;

  factory SliverPageController() {
    _this = SliverPageController._();
    return _this;
  }

  static SliverPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  SliverPageController._();


  @override
  void initPage({PageArgs? arguments}) {
  }

  @override
  disposePage() {}

  onPressBack() {
    PageManager().goBack();
  }
}
