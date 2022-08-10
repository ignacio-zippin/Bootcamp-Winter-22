import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/utils/page_args.dart';

class HorizontalOptionsTransitionPageController extends ControllerMVC
    implements IViewController {
  static late HorizontalOptionsTransitionPageController _this;

  factory HorizontalOptionsTransitionPageController() {
    _this = HorizontalOptionsTransitionPageController._();
    return _this;
  }

  static HorizontalOptionsTransitionPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  HorizontalOptionsTransitionPageController._();

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  onBack() {
    PageManager().goBack();
  }
}
