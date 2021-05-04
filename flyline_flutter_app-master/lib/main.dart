import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/screens/app_settings/help_center.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/data_helper.dart';
import 'screens/introduction/introductionScreen.dart';
import 'screens/home/home.dart';

var fcmToken;

void main() async {
  // ResponsiveSizingConfig.instance.setCustomBreakpoints(
  //   ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(new MyApp()));
  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SettingsBloc()),
      ChangeNotifierProvider(create: (_) => DataHelper()),
      ChangeNotifierProvider(create: (_) => SearchProvider())
    ],
    child: new MyApp(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  static restartApp(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.restartApp();
  }

  static setCustomeTheme(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = new UniqueKey();
  FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
//    generateFCMToken();
    super.initState();
    this.initPlatformState();


//    _messaging.getToken().then((token) {
//        print("FCM Token: " + token);
//      }
    //);

    flyLinebloc.curencyRatesQuery();
//    fireBaseCloudMessagingListeners();
  }

 /* generateFCMToken() {
    _messaging.getToken().then((token) async {
      print('printing FM token');
      print(token);
      fcmToken = token;

      if(fcmToken != null) {
        await flyLinebloc.tryFcmToken(token).then((value) {
          print("Api call success");
        });
      }

    });
  }*/

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  void setCustomeTheme() {
    setState(() {
      AppTheme.isLightTheme = !AppTheme.isLightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness:
          AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      key: key,
      title: 'FlyLine',
      debugShowCheckedModeBanner: false,
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1920,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1920, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      theme: AppTheme.getTheme(),
      routes: routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      navigatorObservers: [routeObserver],
      supportedLocales: [
        const Locale('en', 'US'), // English
      ],
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => kIsWeb ? HomeScreen() : IntroductionScreen(),
    // Routes.SearchScreen: (BuildContext context) => ReservationsDetailsWrapper(),
    Routes.SearchScreen: (BuildContext context) => HomeScreen(),
    Routes.HELP: (BuildContext context) => HelpCenterScreen(),
  };


  /*//Push Notification
  void fireBaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();

    _messaging.getToken().then((token){
      print(token);
    });

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {

    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }*/

}

class Routes {
  static const String SearchScreen = "/home/logged_home";
  static const String SPLASH = "/";
  static const String HELP = "/home/help";
}
