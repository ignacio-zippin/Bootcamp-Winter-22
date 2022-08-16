import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/src/ui/components/examples/horizontal_options_transition/animated_circle_component.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition_page_controller.dart';
import 'package:playground_app/src/ui/shared/globals.dart';
import 'package:playground_app/utils/page_args.dart';

import 'package:provider/provider.dart';

class HorizontalOptionsTransitionPage extends StatefulWidget {
  final PageArgs? args;
  const HorizontalOptionsTransitionPage(this.args, {Key? key})
      : super(key: key);

  @override
  _HorizontalOptionsTransitionPageState createState() =>
      _HorizontalOptionsTransitionPageState();
}

class _HorizontalOptionsTransitionPageState
    extends StateMVC<HorizontalOptionsTransitionPage>
    with TickerProviderStateMixin {
  late HorizontalOptionsTransitionPageController _con;

  _HorizontalOptionsTransitionPageState()
      : super(HorizontalOptionsTransitionPageController()) {
    _con = HorizontalOptionsTransitionPageController.con;
  }
  AnimationController? animationController;
  Animation<double>? startAnimation;
  Animation<double>? endAnimation;
  Animation<double>? horizontalAnimation;
  PageController? pageController;

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    super.initState();

    pageController = PageController();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);

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
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context,
            listen: false);
        if (status == AnimationStatus.completed) {
          model.swapColors();
          animationController!.reset();
        }
      })
      ..addListener(() {
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context,
            listen: false);
        if (animationController!.value > 0.5) {
          model.isHalfWay = true;
        } else {
          model.isHalfWay = false;
        }
      });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HorizontalOptionsTransitionProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:
          model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            color:
                model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
            width: screenWidth / 2.0 - Global.radius / 2.0,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(
                screenWidth / 2 - Global.radius / 2.0,
                screenHeight - Global.radius - Global.bottomPadding,
              ),
            child: GestureDetector(
              onTap: () {
                if (animationController!.status != AnimationStatus.forward) {
                  model.isToggled = !model.isToggled;
                  model.index++;
                  if (model.index > 3) {
                    model.index = 0;
                  }
                  pageController!.animateToPage(model.index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuad);
                  animationController!.forward();
                }
              },
              child: Stack(
                children: <Widget>[
                  AnimatedCircle(
                    animation: startAnimation!,
                    color: model.foreGroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: Global.radius),
                  ),
                  AnimatedCircle(
                    animation: endAnimation!,
                    color: model.backGroundColor,
                    flip: -1.0,
                    horizontalTween:
                        Tween<double>(begin: 0, end: -Global.radius),
                    horizontalAnimation: horizontalAnimation,
                    tween: Tween<double>(begin: Global.radius, end: 1.0),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: PageView.builder(
              controller: pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Page ${index + 1}',
                    style: TextStyle(
                      color: index % 2 == 0 ? Global.mediumBlue : Global.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
