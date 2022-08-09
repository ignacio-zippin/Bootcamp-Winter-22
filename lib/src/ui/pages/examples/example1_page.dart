import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/ui/components/appbar/custom_navigation_bar_component.dart';
import 'package:playground_app/src/ui/components/menu/menu_component.dart';
import 'package:playground_app/src/ui/page_controllers/examples/example1_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

class Example1Page extends StatefulWidget {
  final PageArgs? args;
  const Example1Page(this.args, {Key? key}) : super(key: key);

  @override
  _Example1PageState createState() => _Example1PageState();
}

class _Example1PageState extends StateMVC<Example1Page> {
  late Example1PageController _con;

  _Example1PageState() : super(Example1PageController()) {
    _con = Example1PageController.con;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: MenuComponent(
          closeMenu: () => {_key.currentState!.openEndDrawer()},
        ),
        appBar: simpleNavigationBar(
          title: "Example1",
          hideInfoButton: true,
          hideNotificationButton: true,
          onBack: _con.onBack,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Soy un diseño muy copado que les va a volar la cabeza a todos",
                  style: TextStyle(
                      fontSize: KFontSizeXXLarge50,
                      fontWeight: FontWeight.w700,
                      color: KGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
