// ignore_for_file: unused_field

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/ui/components/entry/item_data_form_component.dart';
import 'package:playground_app/src/ui/page_controllers/examples/shapes_and_animations_example_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';

enum _ChildrenType {
  base,
  form,
  applause,
  flip,
  psycho,
}

class ShapesAndAnimationsPage extends StatefulWidget {
  final PageArgs? args;
  const ShapesAndAnimationsPage(this.args, {Key? key}) : super(key: key);

  @override
  _ShapesAndAnimationsPageState createState() =>
      _ShapesAndAnimationsPageState();
}

class _ShapesAndAnimationsPageState extends StateMVC<ShapesAndAnimationsPage>
    with TickerProviderStateMixin {
  late ShapesAndAnimationsPageController _con;

  _ShapesAndAnimationsPageState() : super(ShapesAndAnimationsPageController()) {
    _con = ShapesAndAnimationsPageController.con;
  }

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late double _width;
  late double _height;
  late double _maxHeight;
  late double _maskWidth;
  late double _maxWidth;
  late double _iconSize;
  final Duration _duration = const Duration(milliseconds: 230);
  double _borderRadius = 0;
  double _opacity = 1;
  double _silentiumOpacity = 1;
  double _text1Opacity = 0;
  double _text2Opacity = 0;
  double _text3Opacity = 0;
  double _text4Opacity = 0;
  double _text5Opacity = 0;
  double _text6Opacity = 0;
  double _text7Opacity = 0;
  double _applauseOpacity = 0;
  double _applauseTextOpacity = 0;
  double _emergencyApplauseTextOpacity = 0;
  Color _color = Colors.white;
  Color _secondaryColor = Colors.black;
  final Color _applauseColor = Colors.red;
  bool _starsActivated = false;
  bool start = true;
  bool isDark = false;
  bool _silentium = true;
  bool _formActivated = false;
  bool _applause = false;
  bool _draggable = false;
  _ChildrenType _currentChildren = _ChildrenType.base;
  static final AudioPlayer _player = AudioPlayer();

  late AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  String _imagePath = "images/silentium.png";

  double _timerValue = 0;
  double _timerValue2 = 0;
  int _timerGreen = 0;
  int _timerRed = 0;
  int _timerBlue = 0;

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
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (_timerRed >= 255) {
        _timerRed = 0;
      } else {
        _timerRed += 1;
      }
    });
    await Future.delayed(const Duration(milliseconds: 75));
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (_timerBlue >= 255) {
        _timerBlue = 0;
      } else {
        _timerBlue += 1;
      }
    });
    await Future.delayed(const Duration(milliseconds: 75));
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (_timerGreen >= 255) {
        _timerGreen = 0;
      } else {
        _timerGreen += 1;
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (_timerValue2 >= 1) {
        _timerValue2 = 0;
      } else {
        _timerValue2 += 0.005;
      }
    });
  }

  int _counter = 0;
  Offset _offset = const Offset(0.4, 0.7); // new

  // ignore: unused_element
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _parentWidget(Widget child) {
    return Transform(
      // Transform widget
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(0.01 * _offset.dy) // changed
        ..rotateY(-0.01 * _offset.dx),
      alignment: FractionalOffset.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (start) {
      start = !start;
      _width = MediaQuery.of(context).size.width / 1.5;
      _height = _width;
      _maxHeight = MediaQuery.of(context).size.height * 0.8;
      _maxWidth = MediaQuery.of(context).size.width;
      _iconSize = MediaQuery.of(context).size.height * 0.07;
      _maskWidth = _width * 1.3;
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) => _startTimer());
    return _parentWidget(
      GestureDetector(
        onPanUpdate: _draggable
            ? (details) => setState(() => _offset += details.delta)
            : null,
        onLongPress: () => setState(() => _offset = Offset.zero),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: AnimatedContainer(
              duration: _duration,
              decoration: BoxDecoration(
                color: _color,
                border: Border.all(
                  color: _draggable ? Colors.black : Colors.transparent,
                ),
              ),
              margin: _draggable
                  ? const EdgeInsets.all(5)
                  : const EdgeInsets.all(0),
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
                        _optionBox(
                            child: _increaseChild(), onTap: _increaseTap),
                        _optionBox(
                            child: _decreaseChild(), onTap: _decreaseTap),
                        _optionBox(
                            child: _rotationChild(), onTap: _rotationTap),
                        _optionBox(child: _circleChild(), onTap: _circleTap),
                        _optionBox(
                            child: _darkThemeChildren(), onTap: _darkThemeTap),
                        _optionBox(child: _hideChild(), onTap: _hideTap),
                        _optionBox(child: _imageChild(), onTap: _imageTap),
                        _optionBox(child: _starsChild(), onTap: _starsTap),
                        _optionBox(child: _formChild(), onTap: _formTap),
                        _optionBox(
                            child: _draggableChild(), onTap: _draggableTap),
                        //_optionBox(child: _psychoChild(), onTap: _psychoTap),
                        _optionBox(
                            child: _applauseChild(), onTap: _applauseTap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
    return RotationTransition(
      turns: _rotationAnimation,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: _duration,
        width: _width,
        height: _height,
        margin:
            _formActivated ? const EdgeInsets.all(25) : const EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: _getContainerShadow(),
          color: _getContainerColor(),
          border: _getContainerBorder(),
          borderRadius:
              BorderRadius.circular(_formActivated ? 20 : _borderRadius),
        ),
        child: _getContainerChild(),
      ),
    );
  }

  List<BoxShadow>? _getContainerShadow() {
    switch (_currentChildren) {
      case _ChildrenType.form:
        return [
          BoxShadow(
              color: _secondaryColor.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10)
        ];
      default:
        return null;
    }
  }

  BoxBorder? _getContainerBorder() {
    switch (_currentChildren) {
      case _ChildrenType.form:
        return Border.all(
          color: _formActivated ? _secondaryColor : Colors.transparent,
          width: 1,
        );
      default:
        return null;
    }
  }

  Color _getContainerColor() {
    switch (_currentChildren) {
      case _ChildrenType.base:
        return _secondaryColor.withOpacity(_opacity);
      case _ChildrenType.form:
        return _color.withOpacity(_opacity);
      case _ChildrenType.applause:
        return Colors.transparent;
      case _ChildrenType.flip:
        return Colors.transparent;
      case _ChildrenType.psycho:
        return Colors.transparent;
    }
  }

  Widget _getContainerChild() {
    switch (_currentChildren) {
      case _ChildrenType.base:
        return _baseChild();
      case _ChildrenType.form:
        return _formChildContainer();
      case _ChildrenType.applause:
        return _applauseChildContainer();
      case _ChildrenType.flip:
        return _flipChildContainer();
      case _ChildrenType.psycho:
        return _psychoChildContainer();
    }
  }

  Widget _baseChild() {
    return AnimatedOpacity(
      duration: _duration,
      opacity: _silentiumOpacity,
      child: AnimatedContainer(
        duration: _duration,
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: _secondaryColor.withOpacity(1),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            opacity: _starsActivated ? 0.8 : 1,
            duration: _duration,
            child: Image.asset(
              _imagePath,
              fit: BoxFit.cover,
              color: _opacity < 1
                  ? Colors.transparent
                  : (_silentium ? _color : null),
            ),
          ),
        ),
      ),
    );
  }

  Widget _applauseChildContainer() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: _applauseOpacity,
      child: Column(
        children: [
          Flexible(
            child: AnimatedContainer(
              duration: _duration,
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.red.withOpacity(_getApplauseShadowOpacity()),
                      blurRadius: 15,
                      spreadRadius: 15,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(40)),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _applauseTextOpacity,
                      child: Text(
                        "APLAUSOS",
                        style: TextStyle(
                          color: Colors.red
                              .withOpacity(_getApplauseShadowOpacity()),
                          fontSize: 50,
                          shadows: [
                            BoxShadow(
                              color: Colors.red.withOpacity(
                                _getApplauseShadowOpacity(),
                              ),
                              spreadRadius: 10,
                              blurRadius: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _emergencyApplause(),
        ],
      ),
    );
  }

  Widget _emergencyApplause() {
    return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _emergencyApplauseTextOpacity,
        child: GestureDetector(
          onTap: _play,
          child: const Text(
            "Tapear aqui en caso de emergencia",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              decoration: TextDecoration.underline,
              shadows: [
                BoxShadow(
                  color: Colors.red,
                  spreadRadius: 10,
                  blurRadius: 10,
                )
              ],
            ),
          ),
        ));
  }

  Widget _formChildContainer() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _text1Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Nombres...",
                          hintStyle: TextStyle(color: _secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _text2Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Apellidos...",
                          hintStyle: TextStyle(color: _secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _text3Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Email...",
                          hintStyle: TextStyle(color: _secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _text4Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Telefono...",
                          hintStyle: TextStyle(color: _secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _text5Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _secondaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Fecha de nacimiento...",
                          hintStyle: TextStyle(color: _secondaryColor),
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: _secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _text5Opacity,
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ItemDataFormComponent.dropDown(
                        items: const ["Argentina", "Chile", "Paraguay"],
                        onChange: (item) {},
                        placeholder: "Pais...",
                        dropdownArrowColor: _secondaryColor,
                        dropdownHintColor: _secondaryColor,
                        dropdownHintSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: _text7Opacity,
            child: Container(
              color: _secondaryColor,
              height: 50,
              child: Center(
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                    color: _color,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flipChildContainer() {
    return Container();
  }

  Widget _psychoChildContainer() {
    return Container(
      color: Color.fromRGBO(_timerRed, _timerRed, _timerBlue, 1),
    );
  }

  double _getApplauseShadowOpacity() {
    if (_timerValue < 0.5) {
      return _timerValue * 2;
    } else if (_timerValue < 1) {
      return (1 - (_timerValue)) * 2;
    } else {
      return 0;
    }
  }

  Widget _mask() {
    return AnimatedContainer(
      duration: _duration,
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
    return Stack(
      children: [
        // ------------
        Positioned(
          right: (_maskWidth * 0.84),
          bottom: (_maskWidth * _timerValue),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.7),
          bottom: ((_maskWidth * 0.5) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.8),
          bottom: ((_maskWidth * 1.2) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.1),
          bottom: ((_maskWidth * 1.1) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.76),
          bottom: ((_maskWidth * 0.2) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.12),
          bottom: ((_maskWidth * 0.25) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.2),
          bottom: ((_maskWidth * 0.7) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),

        // ------------
        Positioned(
          right: (_maskWidth * 0.14),
          bottom: ((_maskWidth * 0.8) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.58),
          bottom: ((_maskWidth * 0.4) * (_timerValue2 + 0.5)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.3),
          bottom: ((_maskWidth * 1) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.83),
          bottom: ((_maskWidth * 1.1) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.6),
          bottom: ((_maskWidth * 0.2) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.7),
          bottom: ((_maskWidth * 0.3) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.82),
          bottom: ((_maskWidth * 0.7) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            size: (_width / 8),
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),

        // ------------
      ],
    );
  }

  double _getStarsOpacity() {
    if (!_starsActivated) {
      return 0;
    }
    if (_timerValue <= 0) {
      return 0;
    } else if (_timerValue <= 0.5) {
      return _timerValue * 2;
    } else if (_timerValue > 0.5) {
      if (_timerValue >= 1) {
        return 0;
      } else {
        return (1 - _timerValue) * 2;
      }
    } else {
      return 1;
    }
  }

  double _getStarsOpacity2() {
    if (!_starsActivated) {
      return 0;
    }
    if (_timerValue2 <= 0) {
      return 0;
    } else if (_timerValue2 <= 0.5) {
      return _timerValue2 * 2;
    } else if (_timerValue2 > 0.5) {
      if (_timerValue2 >= 1) {
        return 0;
      } else {
        return (1 - _timerValue2) * 2;
      }
    } else {
      return 1;
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
    _formActivated = false;
    _applause = false;
    setState(() {
      _currentChildren = _ChildrenType.base;
      _silentiumOpacity = 1;
      _height = _width;
    });
    if (_width + 50 < _maxWidth) {
      setState(() {
        _width += 50;
        _maskWidth = _width * 1.3;
        _height = _width;
      });
    }
    _toggleOffTexts();
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
    _formActivated = false;
    _applause = false;
    setState(() {
      _currentChildren = _ChildrenType.base;
      _silentiumOpacity = 1;
      _height = _width;
    });
    if (_width - 50 > 0) {
      setState(() {
        _width -= 50;
        _maskWidth = _width * 1.3;
        _height = _width;
      });
    }
    _toggleOffTexts();
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
    _formActivated = false;
    _applause = false;
    if (_borderRadius > 0) {
      setState(() {
        _currentChildren = _ChildrenType.base;
        _opacity = 1;
        _height = _width;
        _borderRadius = 0;
        _silentiumOpacity = 1;
      });
    } else {
      setState(() {
        _currentChildren = _ChildrenType.base;
        _opacity = 1;
        _height = _width;
        _borderRadius = _maxWidth;
        _silentiumOpacity = 1;
      });
    }
    _toggleOffTexts();
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
        _starsActivated = false;
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

  Widget _starsChild() {
    return Icon(
      Icons.star_rate_sharp,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _starsTap() {
    setState(() {
      _starsActivated = !_starsActivated;
    });
  }

  Widget _imageChild() {
    return Icon(
      Icons.image,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _imageTap() async {
    setState(() {
      _silentiumOpacity = 0;
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _silentium = !_silentium;
        _imagePath =
            _silentium ? "images/silentium.png" : "images/barrilete.jpg";
        _silentiumOpacity = 1;
      });
    });
  }

  Widget _rotationChild() {
    return Icon(
      Icons.rotate_left,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _rotationTap() async {
    if (_rotationController.status == AnimationStatus.completed) {
      _rotationController.reset();
      _rotationController.forward();
    } else if (_rotationController.status == AnimationStatus.dismissed) {
      _rotationController.forward();
    }
  }

  Widget _formChild() {
    return Icon(
      Icons.format_align_justify_sharp,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _formTap() async {
    _currentChildren = _ChildrenType.form;
    _starsActivated = false;
    _applause = false;
    if (_formActivated) {
      return;
    }
    setState(() {
      _formActivated = !_formActivated;
    });
    setState(() {
      _borderRadius = 0;
      _width = _maxWidth - 20;
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _height = _maxHeight;
      });
    });

    await Future.delayed(_duration).then((value) {
      setState(() {
        _silentiumOpacity = 0;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text1Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text2Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text3Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text4Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text5Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text6Opacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _text7Opacity = 1;
      });
    });
  }

  void _toggleOffTexts() {
    setState(() {
      _text1Opacity = 0;
      _text2Opacity = 0;
      _text3Opacity = 0;
      _text4Opacity = 0;
      _text5Opacity = 0;
      _text6Opacity = 0;
      _text7Opacity = 0;
    });
  }

  Widget _applauseChild() {
    return Icon(
      Icons.waving_hand_sharp,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _applauseTap() async {
    setState(() {
      _applauseOpacity = 0;
      _applauseTextOpacity = 0;
      _emergencyApplauseTextOpacity = 0;
    });
    _toggleOffTexts();
    _formActivated = false;
    setState(() {
      if (!isDark) {
        _color = Colors.black;
        _secondaryColor = const Color.fromARGB(255, 197, 197, 197);
        isDark = true;
      }
      _currentChildren = _ChildrenType.applause;
      _applause = true;
      _width = _maxWidth - 50;
      _height = _maxWidth / 2.5;
      _borderRadius = 0;
      _silentiumOpacity = 0;
      _starsActivated = false;
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _applauseOpacity = 1;
      });
    });
    await Future.delayed(_duration).then((value) {
      setState(() {
        _applauseTextOpacity = 1;
      });
    });
    await Future.delayed(const Duration(seconds: 4)).then((value) {
      setState(() {
        _emergencyApplauseTextOpacity = 1;
      });
    });
  }

  Widget _draggableChild() {
    return Icon(
      Icons.moving,
      color: _secondaryColor,
      size: _iconSize,
    );
  }

  void _draggableTap() {
    setState(() {
      if (_draggable) {
        _offset = Offset.zero;
      }
      _draggable = !_draggable;
    });
  }

  // ignore: unused_element
  void _psychoTap() {
    setState(() {
      _width = _maxWidth;
      _height = _maxHeight;
      _borderRadius = 0;
      _currentChildren = _ChildrenType.psycho;
    });
  }

  Future<void> _play() async {
    // await _player.setSourceAsset('aplausos.mp3');
    _player.play(
      AssetSource("aplausos.mp3"),
      // mode: PlayerMode.lowLatency,
      // volume: 1,
    );
  }
}
