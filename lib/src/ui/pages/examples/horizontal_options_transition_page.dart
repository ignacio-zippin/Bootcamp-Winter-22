import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/models/horizontal_options_transition/home_model.dart';
import 'package:playground_app/src/providers/app_provider.dart';
import 'package:playground_app/src/ui/components/examples/horizontal_options_transition/animated_circle.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/values/k_colors.dart';

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
      curve: const Interval(0.500, 1.000, curve: Curves.easeInExpo),
    );

    horizontalAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.750, 1.000, curve: Curves.easeOutQuad),
    );

    animationController!
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          AppProvider().swapColors();
          animationController!.reset();
        }
      })
      ..addListener(() {
        if (animationController!.value > 0.5) {
          AppProvider().isHalfway = true;
        } else {
          AppProvider().isHalfway = true;
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeModel model = HomeModel();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppProvider().isHalfway
          ? AppProvider().foregroundColor
          : AppProvider().backgroundColor,
      body: Stack(
        children: [
          Container(
            color: AppProvider().isHalfway
                ? AppProvider().foregroundColor
                : AppProvider().backgroundColor,
            width: screenHeight / 2.0 - model.radius! / 2.0,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(screenWidth / 2 - model.radius! / 2,
                  screenHeight - model.radius!, model.bottomPadding!),
            child: GestureDetector(
              onTap: () {
                if (animationController!.status != AnimationStatus.forward) {
                  AppProvider().isToggled = !AppProvider().isToggled;
                  AppProvider().index++;
                  if (AppProvider().index > 3) {
                    AppProvider().index = 0;
                  }
                  pageController!.animateToPage(AppProvider().index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuad);
                  animationController!.forward();
                }
              },
              child: Stack(
                children: [
                  AnimatedCircle(
                    animation: startAnimation!,
                    color: AppProvider().foregroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: model.radius),
                  ),
                  AnimatedCircle(
                    animation: endAnimation!,
                    color: AppProvider().backgroundColor,
                    flip: -1.0,
                    horizontalTween:
                        Tween<double>(begin: 0, end: -model.radius!),
                    horizontalAnimation: horizontalAnimation,
                    tween: Tween<double>(begin: model.radius, end: 1.0),
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
                      color: index % 2 == 0 ? KBlue_L1 : KWhite,
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
