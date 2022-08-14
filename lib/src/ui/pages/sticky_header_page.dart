import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/ui/components/appbar/custom_navigation_bar_component.dart';
import 'package:playground_app/src/ui/page_controllers/sticky_header_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';

class StickyHeaderPage extends StatefulWidget {
  final PageArgs? args;
  const StickyHeaderPage(this.args, {Key? key}) : super(key: key);

  @override
  _StickyHeaderPageState createState() => _StickyHeaderPageState();
}

class _StickyHeaderPageState extends StateMVC<StickyHeaderPage> {
  late StickyHeaderPageController _con;

  _StickyHeaderPageState() : super(StickyHeaderPageController()) {
    _con = StickyHeaderPageController.con;
  }

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    super.initState();
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  "Silentium Apps",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                background: Image.network(
                  'https://w0.peakpx.com/wallpaper/86/756/HD-wallpaper-macbook-ultra-computers-mac-dark-laptop-technology-computer-keyboard-macbook.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            
          ],
        ),
      ),
    );
  }
  
}
