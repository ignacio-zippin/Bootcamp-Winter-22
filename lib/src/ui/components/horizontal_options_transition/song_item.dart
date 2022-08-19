import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playground_app/src/models/horizontal_options_transition/song_model.dart';

// ignore: must_be_immutable
class SongItem extends StatefulWidget {
  SongModel song;
  int count;
  bool delayAimation;

  SongItem(this.song, this.count, this.delayAimation, {Key? key})
      : super(key: key);

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> with TickerProviderStateMixin {
  late SongModel song;
  GlobalKey containerKey = GlobalKey();
  Postion? fromPostion;
  late AnimationController moveController;
  late AnimationController cdController;
  late AnimationController playingRotationController;
  late AnimationController playingTranslationController;
  bool showPlayingIcons = false;
  bool isPlaying = false;

  @override
  void initState() {
    song = widget.song;
    moveController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fromPostion = getPositionFromKey(containerKey);
        if (widget.count == 1) {
          cdController.forward();
        }
      }
    });

    cdController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    playingRotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    playingTranslationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    moveController.dispose();
    cdController.dispose();
    playingTranslationController.dispose();
    playingRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.delayAimation) {
      moveController.forward(from: 0);
    } else {
      cdController.reverse();
    }
    return Container(
      key: containerKey,
      child: AnimatedBuilder(
          animation: moveController,
          builder: (context, snapshot) {
            double x = 0, y = 0;
            Postion currentPosition = Postion(0, 0);
            if (containerKey.currentContext!.findRenderObject() != null &&
                fromPostion != null) {
              currentPosition = getPositionFromKey(containerKey);
              x = fromPostion!.x - currentPosition.x;
              y = fromPostion!.y - currentPosition.y;
            }
            if (song.index != 0 &&
                fromPostion != null &&
                fromPostion!.x == currentPosition.x &&
                fromPostion!.y == currentPosition.y &&
                moveController.status != AnimationStatus.completed) {
              return Container();
            }

            return Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(
                    x * (1 - moveController.value),
                    y * (1 - moveController.value),
                  ),
                  child: buildImage(),
                ),
                buildTexts(x, y),
              ],
            );
          }),
    );
  }

  Widget buildImage() {
    double imageSize = 120;
    double cdSize = 100;
    double cdAnimation = 0;

    if (widget.count == 1) {
      imageSize = 120 + 40 * moveController.value;
      cdSize = 100 + 40 * moveController.value;
    } else {
      imageSize = 120 + 40 * (1 - moveController.value);
      cdSize = 100 + 40 * (1 - moveController.value);
      cdAnimation = moveController.value;
    }
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (!isPlaying) {
              playingTranslationController.forward();
              playingRotationController.repeat();
              setState(() {
                isPlaying = true;
              });
            } else {
              playingRotationController.reverse();
              playingTranslationController.reverse().whenComplete(() {
                playingRotationController.stop();
              });
              setState(() {
                isPlaying = false;
              });
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: 5,
                child: Image.asset(
                  song.image,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              AnimatedBuilder(
                  animation: cdController,
                  builder: (context, snapshot) {
                    if (widget.count == 1) {
                      cdAnimation =
                          moveController.status == AnimationStatus.completed
                              ? cdController.value
                              : 1 - moveController.value;
                    }
                    return Positioned(
                      top: 10,
                      left: (imageSize - cdSize / 1.7) * cdAnimation,
                      child: AnimatedBuilder(
                        animation: playingTranslationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.translate(
                            offset: Offset(
                                playingTranslationController.value *
                                    (MediaQuery.of(context).size.width - 250),
                                0),
                            child: child,
                          );
                        },
                        child: AnimatedBuilder(
                          animation: playingRotationController,
                          builder: (BuildContext context, Widget? child) {
                            return Transform.rotate(
                              angle: playingRotationController.value * 2.0 * pi,
                              child: child,
                            );
                          },
                          child: Image.asset(
                            'images/horizontal_options_transition/song_list/cd.png',
                            width: cdSize,
                            height: cdSize,
                          ),
                        ),
                      ),
                    );
                  }),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    width: imageSize,
                    height: imageSize + 20,
                    child: Image.asset(
                      song.image,
                      height: imageSize,
                      width: imageSize,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Visibility(
              visible: widget.count == 1 && isPlaying == true,
              child: const SizedBox(width: 10),
            ),
            Visibility(
              visible: widget.count == 1 && isPlaying == true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.volume_up, size: 30),
                  Icon(Icons.stop, size: 30),
                  Icon(Icons.volume_down, size: 30),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildTexts(double x, double y) {
    double textsHeight = widget.count == 1
        ? 120 - 30 * (moveController.value)
        : 90 + 30 * moveController.value;
    return Transform.translate(
      offset: Offset(x * (1 - moveController.value),
          y * (1 - moveController.value) + textsHeight),
      //      top: textsHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              song.name,
              style: TextStyle(
                  color: widget.count == 1 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              song.by,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class Postion {
  double x;
  double y;

  Postion(this.x, this.y);
}

Postion getPositionFromKey(GlobalKey key) {
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);
  return Postion(position.dx, position.dy);
}
