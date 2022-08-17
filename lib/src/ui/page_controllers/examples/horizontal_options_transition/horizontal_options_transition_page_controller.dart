import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:provider/provider.dart';

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

  AnimationController? animationController;
  Animation<double>? startAnimation;
  Animation<double>? endAnimation;
  Animation<double>? horizontalAnimation;
  PageController? pageController;

  @override
  void initPage(
      {PageArgs? arguments,
      BuildContext? context,
      TickerProviderStateMixin? page}) {
    pageController = PageController();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: page!);

    startAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.000, 0.500, curve: Curves.easeInExpo),
    );

    endAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.500, 1.000, curve: Curves.easeOutExpo),
    );

    horizontalAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.750, 1.000, curve: Curves.easeInOutQuad),
    );

    animationController!
      ..addStatusListener((status) {
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context!,
            listen: false);
        if (status == AnimationStatus.completed) {
          model.swapColors();
          animationController!.reset();
        }
      })
      ..addListener(() {
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context!,
            listen: false);
        if (animationController!.value > 0.5) {
          model.isHalfWay = true;
        } else {
          model.isHalfWay = false;
        }
      });
  }

  @override
  disposePage() {}

  onBack() {
    PageManager().goBack();
  }
}
