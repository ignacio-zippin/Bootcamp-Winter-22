import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/models/horizontal_options_transition/home_model.dart';
import 'package:playground_app/src/ui/components/examples/horizontal_options_transition/animated_circle.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/values/k_colors.dart';
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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
        final model = Provider.of<HomeModel>(context);
        if (status == AnimationStatus.completed) {
          model.swapColors();
          animationController!.reset();
        }
      })
      ..addListener(() {
        final model = Provider.of<HomeModel>(context);
        if (animationController!.value > 0.5) {
          model.isHalfway = true;
        } else {
          model.isHalfway = true;
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:
          model.isHalfway ? model.foregroundColor : model.backgroundColor,
      body: Stack(
        children: [
          Container(
            color:
                model.isHalfway ? model.foregroundColor : model.backgroundColor,
            width: screenHeight / 2.0 - HomeModel.radius / 2.0,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(screenWidth / 2 - HomeModel.radius / 2,
                  screenHeight - HomeModel.radius, HomeModel.bottomPadding),
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
                children: [
                  AnimatedCircle(
                    animation: startAnimation!,
                    color: model.foregroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: HomeModel.radius),
                  ),
                  AnimatedCircle(
                    animation: endAnimation!,
                    color: model.backgroundColor,
                    flip: -1.0,
                    horizontalTween:
                        Tween<double>(begin: 0, end: -HomeModel.radius),
                    horizontalAnimation: horizontalAnimation,
                    tween: Tween<double>(begin: HomeModel.radius, end: 1.0),
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
