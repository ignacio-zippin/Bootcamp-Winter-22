import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/ui/page_controllers/examples/shapes_and_animations_example_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';

enum _ShapesEnum {
  circle,
  square,
}

class ShapesAndAnimationsPage extends StatefulWidget {
  final PageArgs? args;
  const ShapesAndAnimationsPage(this.args, {Key? key}) : super(key: key);

  @override
  _ShapesAndAnimationsPageState createState() =>
      _ShapesAndAnimationsPageState();
}

class _ShapesAndAnimationsPageState extends StateMVC<ShapesAndAnimationsPage> {
  late ShapesAndAnimationsPageController _con;

  _ShapesAndAnimationsPageState() : super(ShapesAndAnimationsPageController()) {
    _con = ShapesAndAnimationsPageController.con;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late double _width;
  late double _maskWidth;
  late double _maxWidth;
  late double _iconSize;
  bool start = true;
  bool isDark = false;
  Color _color = Colors.white;
  Color _secondaryColor = Colors.black;
  final Duration _duration = const Duration(milliseconds: 230);
  double _borderRadius = 0;
  double _opacity = 1;
  _ShapesEnum _shape = _ShapesEnum.square;

  double _timerValue = 0;

  void _startTimer() async {
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (_timerValue >= 1) {
        setState(() {
          _timerValue = 0;
        });
      } else {
        setState(() {
          _timerValue += 0.005;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (start) {
      start = !start;
      _width = MediaQuery.of(context).size.width / 1.5;
      _maxWidth = MediaQuery.of(context).size.width;
      _iconSize = MediaQuery.of(context).size.height * 0.07;
      _maskWidth = _width * 1.3;
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) => _startTimer());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _key,
        body: AnimatedContainer(
          duration: _duration,
          color: _color,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: _container(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: _mask(),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _optionBox(child: _hideChild(), onTap: _hideTap),
                    _optionBox(
                        child: _darkThemeChildren(), onTap: _darkThemeTap),
                    _optionBox(child: _increaseChild(), onTap: _increaseTap),
                    _optionBox(child: _decreaseChild(), onTap: _decreaseTap),
                    _optionBox(child: _circleChild(), onTap: _circleTap),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionBox({required Widget child, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: _secondaryColor.withOpacity(0.2),
          focusColor: _secondaryColor.withOpacity(0.2),
          hoverColor: _secondaryColor.withOpacity(0.2),
          highlightColor: _secondaryColor.withOpacity(0.2),
          onTap: () {
            onTap();
          },
          child: AnimatedContainer(
            duration: _duration,
            height: MediaQuery.of(context).size.height * 0.125,
            width: MediaQuery.of(context).size.height * 0.125,
            decoration: BoxDecoration(
              color: _color,
              border: Border.all(
                color: _secondaryColor,
                width: 5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _container() {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: _duration,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(_opacity),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      width: _width,
      height: _width,
    );
  }

  Widget _mask() {
    return AnimatedContainer(
      duration: _duration,
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.8)),
      width: (_maskWidth),
      height: (_maskWidth),
      child: Stack(
        children: [
          _starsMask(),
        ],
      ),
    );
  }

  Widget _starsMask() {
    return Container(
      color: Colors.purpleAccent,
      child: Stack(
        children: [
          Positioned(
            right: (_maskWidth * 0.9),
            bottom: (_maskWidth * _timerValue),
            child: Icon(
              Icons.star_rate,
              color: _color.withOpacity(_getOpacity()),
            ),
          ),
          Positioned(
            right: (_maskWidth * 0.7),
            bottom: ((_maskWidth * 0.5) * (_timerValue)),
            child: Icon(
              Icons.star_rate,
              color: _color.withOpacity(_getOpacity()),
            ),
          ),
          Positioned(
            right: (_maskWidth * 0.8),
            bottom: ((_maskWidth * 1.2) * (_timerValue)),
            child: Icon(
              Icons.star_rate,
              color: _color.withOpacity(_getOpacity()),
            ),
          ),
        ],
      ),
    );
  }

  double _getOpacity() {
    if (_timerValue > 1) {
      return 1;
    } else if (_timerValue < 0) {
      return 0;
    } else {
      return _timerValue;
    }
  }

  void _darkThemeTap() {
    if (isDark) {
      setState(() {
        _color = Colors.white;
        _secondaryColor = Colors.black;
      });
    } else {
      setState(() {
        _color = Colors.black;
        _secondaryColor = const Color.fromARGB(255, 197, 197, 197);
      });
    }
    isDark = !isDark;
  }

  Widget _darkThemeChildren() {
    return Icon(
      Icons.dark_mode_sharp,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _increaseTap() {
    if (_width + 50 < _maxWidth) {
      setState(() {
        _width += 50;
        _maskWidth = _width * 1.3;
      });
    }
    return;
  }

  Widget _increaseChild() {
    return Icon(
      Icons.add,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _decreaseTap() {
    if (_width - 50 > 0) {
      setState(() {
        _width -= 50;
        _maskWidth = _width * 1.3;
      });
    }
    return;
  }

  Widget _decreaseChild() {
    return Icon(
      Icons.remove,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _circleTap() {
    if (_borderRadius > 0) {
      setState(() {
        _borderRadius = 0;
      });
    } else {
      setState(() {
        _borderRadius = _maxWidth;
      });
    }
  }

  Widget _circleChild() {
    return Icon(
      _borderRadius > 0 ? Icons.square : Icons.circle,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _hideTap() {
    if (_opacity > 0) {
      setState(() {
        _opacity = 0;
      });
    } else {
      setState(() {
        _opacity = 1;
      });
    }
  }

  Widget _hideChild() {
    return Icon(
      Icons.remove_red_eye_sharp,
      color: _secondaryColor,
      size: _iconSize,
    );
  }
}
