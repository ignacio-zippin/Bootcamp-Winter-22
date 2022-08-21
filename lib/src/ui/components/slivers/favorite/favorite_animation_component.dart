import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FavoriteAnimationComponent extends StatefulWidget {
  final double height;
  bool isFavorite;
  Function(bool) functionReturn;

  FavoriteAnimationComponent({Key? key, this.height = 20.0, required this.isFavorite, required this.functionReturn}) : super(key: key);

  @override
  State<FavoriteAnimationComponent> createState() =>
      _FavoriteAnimationComponentState();
}

class _FavoriteAnimationComponentState extends State<FavoriteAnimationComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _greyHeartSize;
  late Animation<double> _redCircleSize;
  late Animation<double> _whiteCircleSize;
  late Animation<double> _waveEffectSize;
  late Animation<double> _waveEffectOpacity;
  late Animation<double> _redHeartSize;

  double heightHeart = 20.0;
  late double heightRedCircle;
  late double heightWhiteCircle;
  late double heightWaveEffectBegin;
  late double heightWaveEffectEnd;
  late double heightRedHeart1;
  late double heightRedHeart2;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    heightHeart = widget.height;
    isFavorite = widget.isFavorite;
    heightRedCircle = heightHeart * 1.42;
    heightWhiteCircle = heightHeart * 2.13;
    heightWaveEffectBegin = heightHeart * 0.74;
    heightWaveEffectEnd = heightHeart * 1.42;
    
    heightRedHeart1 = heightHeart * 1.35;
    heightRedHeart2 = heightHeart * 0.54;

    //Dure 2 seconds
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _greyHeartSize = Tween(begin: heightHeart, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeInOut),
      ),
    );

    _redCircleSize = Tween(begin: 0.0, end: heightRedCircle).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _whiteCircleSize = Tween(begin: 0.0, end: heightWhiteCircle).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.25, curve: Curves.easeInOut),
      ),
    );

    _waveEffectSize = Tween(begin: heightWaveEffectBegin, end: heightWaveEffectEnd).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );

    _redHeartSize = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 5.0, end: heightRedHeart1)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: heightRedHeart1, end: heightRedHeart2)
              .chain(CurveTween(curve: const Cubic(0.71, -0.01, 1.0, 1.0))),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: heightRedHeart2, end: heightHeart)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60.0,
        ),
      ],
    ).animate((CurvedAnimation(
        parent: _controller, curve: const Interval(0.1, 1.0))));

    _waveEffectOpacity = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          weight: 60.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 0.0),
          weight: 40.0,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    if (isFavorite){
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isFavorite){
          _controller.reset();
          _controller.forward();
        }else{
          _controller.reset();
        }
        isFavorite = !isFavorite;
        widget.isFavorite = isFavorite;
        widget.functionReturn(isFavorite);
      },
      child: SizedBox(
        height: heightWhiteCircle,
        width: heightWhiteCircle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return SizedBox(
                    height: _redCircleSize.value,
                    width: _redCircleSize.value,
                    child: Image.asset('images/favorite/fav_circle_red.png'),
                  );
                }),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    height: _whiteCircleSize.value,
                    width: _whiteCircleSize.value,
                    child: Image.asset('images/favorite/fav_circle_white.png'),
                  );
                }),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _waveEffectOpacity.value,
                    child: SizedBox(
                      height: _waveEffectSize.value,
                      width: _waveEffectSize.value,
                      child:
                          Image.asset('images/favorite/fav_heart_waveeffect.png'),
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    height: _redHeartSize.value,
                    width: _redHeartSize.value,
                    child: Image.asset('images/favorite/fav_heart_red.png'),
                  );
                }),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return SizedBox(
                  height: _greyHeartSize.value,
                  width: _greyHeartSize.value,
                  child: Image.asset('images/favorite/fav_heart_grey.png'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
