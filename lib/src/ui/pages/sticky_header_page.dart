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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: simpleNavigationBar(
            title: "Sticky Header",
            hideInfoButton: true,
            onBack: _con.onPressBack,
            hideNotificationButton: true),
        body: const Text('Sticky Header')
      ),
    );
  }
}
