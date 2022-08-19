import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playground_app/src/enums/horizontal_options_transition/lightswitches_enum.dart';
import 'package:playground_app/src/models/horizontal_options_transition/light_switches_model.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition/horizontal_options_transition_page_controller.dart';
import 'package:playground_app/utils/rectangle_cliper.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';
import 'package:provider/provider.dart';

class LightSwitchesWidget extends StatefulWidget {
  final HorizontalOptionsTransitionPageController controller;
  const LightSwitchesWidget(this.controller, {Key? key}) : super(key: key);

  @override
  State<LightSwitchesWidget> createState() => _LightSwitchesWidgetState();
}

class _LightSwitchesWidgetState extends State<LightSwitchesWidget> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HorizontalOptionsTransitionProvider>(context);
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.controller.homeItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: sliderContainer(
              model,
              index,
              KWhite,
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
          height: lswBoxHeight,
          decoration: BoxDecoration(
            color: model.switchValues[index] ? KWhite : KGrey_L1,
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
          trackHeight: lswTrackHeight,
          overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
          thumbShape: RoundSliderOverlayShape(overlayRadius: 0.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 45, right: 80.0),
          child: Slider(
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
              color: KBlue_T2,
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
                  color: KWhite,
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
    final homeData =
        LightSwitchModel.fromMap(widget.controller.homeItems[index]);
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
                color: KBlue_T2,
                size: 35,
              ),
              Text(
                model.switchValues[index]
                    ? '${(model.sliderValues[index] * 100).round()}%'
                    : 'Off',
                style: const TextStyle(
                  color: KBlue_T2,
                  fontSize: 18.0,
                  fontFamily: 'Sf',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              homeData.location,
              style: TextStyle(
                color: color,
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
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
