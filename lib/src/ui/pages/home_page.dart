import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/ui/components/appbar/custom_navigation_bar_component.dart';
import 'package:playground_app/src/ui/components/buttons/rounded_button_component.dart';
import 'package:playground_app/src/ui/components/menu/menu_component.dart';
import 'package:playground_app/src/ui/page_controllers/home_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

class HomePage extends StatefulWidget {
  final PageArgs? args;
  const HomePage(this.args, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends StateMVC<HomePage> {
  late HomePageController _con;

  _HomePageState() : super(HomePageController()) {
    _con = HomePageController.con;
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
        drawer: MenuComponent(
          closeMenu: () => {_key.currentState!.openEndDrawer()},
        ),
        appBar: simpleNavigationBar(
            title: "Home",
            hideInfoButton: true,
            hideNotificationButton: true,
            onMenu: () => {_key.currentState!.openDrawer()}),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Silentium Bootcamp Winter'22",
                  style: TextStyle(
                      fontSize: KFontSizeXXLarge50,
                      fontWeight: FontWeight.w700,
                      color: KGrey),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(thickness: 2),
                _sizedBox15(),
                RoundedButton(
                  text: "Horizontal Options Transition",
                  onPressed: () {
                    _con.onPressExample1();
                  },
                  width: double.infinity,
                ),
                _sizedBox15(),
                RoundedButton(
                  text: "Sliver",
                  onPressed: () {
                    _con.onPressSliverButton();
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sizedBox15() {
    return const SizedBox(
      height: 15,
    );
  }
}
