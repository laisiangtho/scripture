import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'MainBottomNavigationBar.dart';
import 'Store.dart';
// import 'package:bible/Home.dart';
// import 'package:bible/Bible.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF), //top bar color
      statusBarBrightness: Brightness.light, // iOS
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    )
  );
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
  //   statusBarColor: Colors.white, // Color for Android
  //   statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
  //   statusBarIconBrightness: Brightness.dark,
  // ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(LaiSiangtho()));

  // String UA = 'UA-18644721-1';

  // Analytics ga = new AnalyticsIO(UA, 'ga_test', '31');
  // Analytics ga = new AnalyticsIO(UA, 'ga_test', '31','documentsDirectory': PathProvider.getApplicationDocumentsDirectory()));
  // ga.analyticsOpt = AnalyticsOpt.optIn;
  // ga.sendScreenView('home');
  // ga.sendException('foo exception');
    // documentsDirectory: PathProvider.getApplicationDocumentsDirectory());
}




class LaiSiangtho extends StatelessWidget {

  // final String UA = 'UA-18644721-1';
  // final String UA = 'App + Web | 207437591';
  // final String UA = '207437591';
  final Store store = new Store();




  @override
  Widget build(BuildContext context) {
    // Analytics analytics = getAnalytics();
    // analytics.sendEvent('main', '31.0');
    // googleAnalytics().then((e){
    //   e.sendEvent('main', '31.0');
    //   print('sending');
    // });
    // googleAnalytics().then((e){
    //   e.sendEvent('main', '31.0');
    //   print('sending');
    // });

    MaterialColor colorPrimarySwatch = MaterialColor(
      // 0xFFF5F5F5,
      0xFFFFFFFF,
      <int, Color>{
        10: Color(0xFFFFFFFF),
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        400: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
        500: Color(0xFFBDBDBD),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030), // only for background color in dark theme
        900: Color(0xFF212121)
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        // fontFamily: "Caveat, Paduak, sans-serif",
        fontFamily: "Paduak",

        // platform: TargetPlatform.iOS,
        // platform: TargetPlatform.android,

        scaffoldBackgroundColor:colorPrimarySwatch[10],
        primarySwatch: colorPrimarySwatch,
        primaryColor: colorPrimarySwatch[10],
        backgroundColor: colorPrimarySwatch[400],
        canvasColor: Color(0x00000000),

        dialogTheme: DialogTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        ),
        iconTheme: new IconThemeData(
          color: Colors.grey,
        ),
        primaryIconTheme:new IconThemeData(
          color: Colors.grey,
        ),
        accentIconTheme:new IconThemeData(
          color: Colors.green,
        ),
        buttonTheme: new ButtonThemeData(
          splashColor: Colors.transparent
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cupertinoOverrideTheme: CupertinoThemeData(),

        textTheme: TextTheme(
          title: TextStyle(fontWeight: FontWeight.w300),
          subtitle: TextStyle(fontWeight: FontWeight.w400),
          headline: TextStyle(fontWeight: FontWeight.w300),
          subhead: TextStyle(fontWeight: FontWeight.w400),
          caption: TextStyle(fontWeight: FontWeight.w300),
          overline: TextStyle(fontWeight: FontWeight.w300),
          button: TextStyle(fontWeight: FontWeight.w300),
          body1: TextStyle(fontWeight: FontWeight.w300),
          body2: TextStyle(fontWeight: FontWeight.w300),
          // display2: TextStyle(fontWeight: FontWeight.w300,color: Colors.black),
          // display3: TextStyle(fontWeight: FontWeight.w300,color: Colors.black),
          display4: TextStyle(fontWeight: FontWeight.w300,color: Colors.black,height: 1.0) // bible verse
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none
        )
      ),
      title: store.appTitle,
      home: new MainBottomNavigationBar()
    );
  }
}
