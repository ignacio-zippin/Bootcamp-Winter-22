import 'package:flutter/material.dart';
import 'package:playground_app/src/ui/components/horizontal_options_transition/song_item.dart';
import 'package:playground_app/src/ui/page_controllers/examples/horizontal_options_transition/horizontal_options_transition_page_controller.dart';

class SongListWidget extends StatefulWidget {
  final HorizontalOptionsTransitionPageController controller;
  const SongListWidget(this.controller, {Key? key}) : super(key: key);

  @override
  State<SongListWidget> createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  int count = 2;
  bool delayAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[buildToolBar(), buildGrid()],
    );
  }

  Widget buildToolBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8, top: 15),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Canciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InkWell(
                onTap: () async {
                  setState(() {
                    delayAnimation = count == 1 ? true : false;
                  });
                  if (count == 1) {
                    await Future.delayed(const Duration(milliseconds: 400));
                  }
                  setState(() {
                    delayAnimation = false;
                    count == 1 ? count = 2 : count = 1;
                  });
                },
                child: Image.asset(count == 1
                    ? 'images/horizontal_options_transition/song_list/icon.png'
                    : 'images/horizontal_options_transition/song_list/list_icon.png')),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        crossAxisCount: count,
        physics: const ClampingScrollPhysics(),
        childAspectRatio: count == 2 ? 150 / 170 : 150 / 75,
        children: widget.controller
            .getSongs()
            .map((e) => SongItem(e, count, delayAnimation))
            .toList(),
      ),
    );
  }
}
