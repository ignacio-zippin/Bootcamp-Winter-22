import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/src/ui/components/examples/horizontal_options_transition/animated_circle_component.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition_page_controller.dart';

import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

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

  @override
  void initState() {
    _con.initPage(
      arguments: widget.args,
      context: context,
      page: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _con.animationController!.dispose();
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
            width: screenWidth / 2.0 - hotRadius / 2.0,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(
                screenWidth / 2 - hotRadius / 2.0,
                screenHeight - hotRadius - hotBottomPadding,
              ),
            child: GestureDetector(
              onTap: () {
                if (_con.animationController!.status !=
                    AnimationStatus.forward) {
                  model.isToggled = !model.isToggled;
                  model.index++;
                  if (model.index > 3) {
                    model.index = 0;
                  }
                  _con.pageController!.animateToPage(model.index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuad);
                  _con.animationController!.forward();
                }
              },
              child: Stack(
                children: <Widget>[
                  AnimatedCircle(
                    animation: _con.startAnimation!,
                    color: model.foreGroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: hotRadius),
                  ),
                  AnimatedCircle(
                    animation: _con.endAnimation!,
                    color: model.backGroundColor,
                    flip: -1.0,
                    horizontalTween: Tween<double>(begin: 0, end: -hotRadius),
                    horizontalAnimation: _con.horizontalAnimation,
                    tween: Tween<double>(begin: hotRadius, end: 1.0),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: PageView.builder(
              controller: _con.pageController,
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
