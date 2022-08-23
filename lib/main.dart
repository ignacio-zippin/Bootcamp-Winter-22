import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground_app/src/enums/culture.dart';
import 'package:playground_app/src/managers/data_manager/data_manager.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/providers/app_provider.dart';
import 'package:playground_app/src/providers/product_provider.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/src/support/futuristic.dart';
import 'package:playground_app/src/ui/components/common/loading_component.dart';
import 'package:playground_app/src/ui/pages/home_page.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(
            create: (_) => HorizontalOptionsTransitionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyHomePageState? state =
        context.findAncestorStateOfType<_MyHomePageState>();
    state!.changeLanguage(newLocale);
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    //_initApp(context);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: KPrimary));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _locale = Locale(getCode(DataManager().selectedCulture), '');
    return MaterialApp(
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      navigatorKey: PageManager().navigatorKey,
      locale: _locale,
      onGenerateRoute: (settings) {
        return PageManager().getRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: '',
      theme: ThemeData(
        fontFamily: 'Sans',
        scrollbarTheme: ScrollbarThemeData(
          trackColor: MaterialStateProperty.all(Colors.grey),
          thumbColor: MaterialStateProperty.all(KGrey_L2),
          trackBorderColor: MaterialStateProperty.all(Colors.grey),
          showTrackOnHover: true,
        ),
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _home(),
    );
  }

  _home() {
    return Futuristic<void>(
      autoStart: true,
      futureBuilder: () => _initApp(),
      busyBuilder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.37,
          child: loadingComponent(true, backgroundColor: Colors.white)),
      dataBuilder: (context, data) => _initPage(),
    );
  }

  _initPage() {
    return const HomePage(null);
    //return Sliver3DPage(null);
    /* return Dashoard o login? */ /* DataManager().hasSession()
        ? InitPage(PageArgs(fromPage: PageNames.main))
        : const LoginPage(); */
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  getCode(Culture code) {
    switch (code) {
      case Culture.es:
        return 'es';
      case Culture.en:
        return 'en';
    }
  }

  _initApp() async {
    //AppSettings.init(context);
    await DataManager().init();
    await AppProvider().init();
  }
}
