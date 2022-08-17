import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/enums/horizontal_options_transition/lightswitches_enum.dart';
import 'package:playground_app/src/models/horizontal_options_transition/light_switches_model.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/src/ui/components/examples/horizontal_options_transition/animated_circle_component.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition/horizontal_options_transition_page_controller.dart';

import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/utils/rectangle_cliper.dart';
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
          SizedBox(
            height: (MediaQuery.of(context).size.height / 4) * 3,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _con.pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.amber,
                      ),
                    );
                  case 1:
                    return lightSwitches(model);

                  case 2:
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.amber,
                      ),
                    );

                  case 3:
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.amber,
                      ),
                    );

                  default:
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.amber,
                      ),
                    );
                } /* Center(
                  child: Text(
                    'Page ${index + 1}',
                    style: TextStyle(
                      color: index % 2 == 0 ? KBlue_L1 : KWhite,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ); */
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget lightSwitches(dynamic model) {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, //TODO: cambiar
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: sliderContainer(
              model,
              index,
              mediumBlue,
            ),
          );
        },
      ),
    );
  }

  sliderContainer(dynamic model, int index, Color color) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        sliderAnimation(model: model, width: width, index: index, color: color),
        sliderValues(model: model, width: width, index: index),
        content(model: model, width: width, index: index, color: color),
        cupertinoSwitch(model: model, width: width, index: index),
      ],
    );
  }

  sliderAnimation({
    dynamic model,
    required double width,
    required int index,
    required Color color,
  }) {
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          curve: Curves.easeInOutQuart,
          duration: Duration(
            milliseconds: model.state == ViewState.busy ? 0 : 500,
          ),
          width: model.widthValues[index] ?? model.getStartWidth(width),
          height: boxHeight,
          decoration: BoxDecoration(
            color: model.switchValues[index] ? mediumBlue : darkGrey,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
          ),
        ),
      ),
    );
  }

  sliderValues({
    dynamic model,
    required double width,
    required int index,
  }) {
    return IgnorePointer(
      ignoring: model.switchValues[index] ? false : true,
      child: SliderTheme(
        data: const SliderThemeData(
          trackHeight: trackHeight,
          overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
          thumbShape: RoundSliderOverlayShape(overlayRadius: 0.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 80.0),
          child: Slider(
            thumbColor: Colors.transparent,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
            value: model.sliderValues[index],
            onChanged: (value) {
              model.setSliderValue(index, value);
              model.setWidth(index, width);
            },
          ),
        ),
      ),
    );
  }

  Widget content({
    dynamic model,
    required double width,
    required int index,
    required Color color,
  }) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: contentWidget(
              model: model,
              color: darkBlue,
              index: index,
            ),
          ),
          ClipRect(
            clipper: RectangleClipper(
              offset: model.getFormula(index, width),
            ),
            child: SizedBox(
              height: 100,
              child: AnimatedOpacity(
                curve: Curves.easeInOutQuart,
                opacity: model.switchValues[index] ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: contentWidget(
                  model: model,
                  color: mediumBlue,
                  index: index,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  contentWidget({
    dynamic model,
    required int index,
    required Color color,
  }) {
    final homeData = LightSwitchModel.fromMap(homeItems[index]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                homeData.icon,
                color: darkBlue,
              ),
              Text(
                model.switchValues[index]
                    ? '${(model.sliderValues[index] * 100).round()}%'
                    : 'Off',
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 14.0,
                  fontFamily: 'Sf',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              homeData.location,
              style: TextStyle(
                color: color,
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              homeData.power,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  cupertinoSwitch({
    dynamic model,
    required double width,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CupertinoSwitch(
        activeColor: Colors.pinkAccent,
        value: model.switchValues[index],
        onChanged: (value) {
          model.setSwitchValues(index, value);
          model.setWidth(index, width);
        },
      ),
    );
  }
}
