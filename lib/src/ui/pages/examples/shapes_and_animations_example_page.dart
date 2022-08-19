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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
  Color _color = Colors.white;
  Color _secondaryColor = Colors.black;
  Color _applauseColor = Colors.red;
  bool _starsActivated = false;
  bool start = true;
  bool isDark = false;
  bool _silentium = true;
  bool _formActivated = false;
  bool _applause = false;
  bool _draggable = false;
  _ChildrenType _currentChildren = _ChildrenType.base;

  late AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  String _imagePath = "images/silentium.png";

  double _timerValue = 0;
  double _timerValue2 = 0;
  double _timerValue3 = 0;

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
      if (_timerValue3 >= 10) {
        _timerValue3 = 0;
      } else {
        _timerValue3 += 0.005;
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
  Offset _offset = Offset(0.4, 0.7); // new

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
              margin: _draggable ? EdgeInsets.all(5) : EdgeInsets.all(0),
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
        margin: _formActivated ? EdgeInsets.all(25) : EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: _formActivated
              ? ([
                  BoxShadow(
                      color: _secondaryColor.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10)
                ])
              : null,
          color: _applause
              ? Colors.transparent
              : _formActivated
                  ? _color.withOpacity(_opacity)
                  : _secondaryColor.withOpacity(_opacity),
          border: Border.all(
            color: _formActivated ? _secondaryColor : Colors.transparent,
            width: 1,
          ),
          borderRadius:
              BorderRadius.circular(_formActivated ? 20 : _borderRadius),
        ),
        child: _getContainerChild(),
        width: _width,
        height: _height,
      ),
    );
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
    }

    if (_applause) {
    } else if (!_formActivated) {
    } else {}
  }

  Widget _baseChild() {
    return AnimatedOpacity(
      duration: _duration,
      opacity: _silentiumOpacity,
      child: Image.asset(
        _imagePath,
        fit: BoxFit.cover,
        color: _opacity < 1 ? Colors.transparent : (_silentium ? _color : null),
      ),
    );
  }

  Widget _applauseChildContainer() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: _applauseOpacity,
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
                color: Colors.red.withOpacity(_getApplauseShadowOpacity()),
                blurRadius: 15,
                spreadRadius: 15,
              ),
            ],
            borderRadius: BorderRadius.circular(40)),
        child: Container(
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
              "ESCOPETA",
              style: TextStyle(
                color: Colors.red.withOpacity(_getApplauseShadowOpacity()),
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
      ),
    );
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
                        items: ["Argentina", "Chile", "Paraguay"],
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
            duration: Duration(milliseconds: 700),
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

  double _getApplauseShadowOpacity() {
    if (_timerValue < 0.5) {
      return _timerValue;
    } else if (_timerValue < 1) {
      return 1 - (_timerValue);
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
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.7),
          bottom: ((_maskWidth * 0.5) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.8),
          bottom: ((_maskWidth * 1.2) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.1),
          bottom: ((_maskWidth * 1.1) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.3),
          bottom: ((_maskWidth * 0.2) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.45),
          bottom: ((_maskWidth * 0.25) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.2),
          bottom: ((_maskWidth * 0.7) * (_timerValue)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity()),
          ),
        ),

        // ------------
        Positioned(
          right: (_maskWidth * 0.14),
          bottom: ((_maskWidth * 0.8) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.32),
          bottom: ((_maskWidth * 0.4) * (_timerValue + 0.5)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.3),
          bottom: ((_maskWidth * 1) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.83),
          bottom: ((_maskWidth * 1.1) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.6),
          bottom: ((_maskWidth * 0.2) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.7),
          bottom: ((_maskWidth * 0.3) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
            color: _color.withOpacity(_getStarsOpacity2()),
          ),
        ),
        Positioned(
          right: (_maskWidth * 0.82),
          bottom: ((_maskWidth * 0.7) * (_timerValue2)),
          child: Icon(
            Icons.star_rate,
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
      return _timerValue;
    } else if (_timerValue > 0.5) {
      if (_timerValue >= 1) {
        return 0;
      } else {
        return 1 - _timerValue;
      }
    } else {
      return 0.5;
    }
  }

  double _getStarsOpacity2() {
    if (!_starsActivated) {
      return 0;
    }
    if (_timerValue2 <= 0) {
      return 0;
    } else if (_timerValue2 <= 0.5) {
      return _timerValue2;
    } else if (_timerValue2 > 0.5) {
      if (_timerValue2 >= 1) {
        return 0;
      } else {
        return 1 - _timerValue2;
      }
    } else {
      return 0.5;
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
            _silentium ? "images/silentium.png" : "images/icon_alert.png";
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
    _applauseOpacity = 0;
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
}
