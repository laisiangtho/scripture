import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:bible/screen/main.dart';
// import 'package:bible/screen/color.dart';
// import 'package:bible/screen/speak.dart';
import 'package:bible/core.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  final MaterialColor colorPrimarySwatch = MaterialColor(
    0xFF000000,
    <int, Color>{
      10: Color(0xFFFFFFFF),
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
      500: Color(0xFF000000),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF303030), // only for background color in dark theme
      900: Color(0xFF212121)
    },
  );

  @override
  Widget build(BuildContext context) {

    // // NOTE: hide bottom bar
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
    // // NOTE: hide status bar
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
    // // NOTE: hide both
    // SystemChrome.setEnabledSystemUIOverlays ([]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // statusBarColor: Colors.transparent,
        statusBarColor: colorPrimarySwatch[10],

        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorPrimarySwatch[10],
        systemNavigationBarIconBrightness: Brightness.dark
      )
    );

    // WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft
    ]);

    return MaterialApp(
      title: Core.instance.appName,
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      // showSemanticsDebugger: true,
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        // fontFamily: "Lato, Paduak, sans-serif",
        // fontFamily: "Lato, Mm3Web",
        // fontFamily: "Mm3Web, Lato",
        fontFamily: "Lato",
        // fontFamily: "Mm3Web",
        // fontFamily: "Paduak",

        // platform: TargetPlatform.iOS,
        platform: TargetPlatform.android,

        // primarySwatch: Colors.lightGreen,
        // primarySwatch: colorPrimarySwatch,
        // primaryColor: Color(0xFFffffff),
        // accentColor: Color(0xFFffffff),
        // canvasColor: Color(0xFFffffff),

        scaffoldBackgroundColor: colorPrimarySwatch[100],
        // scaffoldBackgroundColor: Color(0x00000000),
        primaryColor: colorPrimarySwatch[10],
        backgroundColor: colorPrimarySwatch[400],
        // primarySwatch: colorPrimarySwatch,
        // primarySwatch: Colors.red,
        // accentColor: Color(0xFFffffff),
        // accentColorBrightness: Brightness.dark,
        // canvasColor: Colors.transparent,
        // canvasColor: colorPrimarySwatch[10],

        // dialogTheme: DialogTheme(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0
        // ),
        // iconTheme: new IconThemeData(
        //   color: Colors.grey,
        // ),
        // primaryIconTheme:new IconThemeData(
        //   color: Colors.grey,
        // ),
        // accentIconTheme:new IconThemeData(
        //   color: Colors.green,
        // ),

        buttonTheme: new ButtonThemeData(
          splashColor: Colors.transparent,
          buttonColor: colorPrimarySwatch[400],
          // textTheme: ButtonTextTheme.primary,
          // textTheme: ButtonTextTheme.accent,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cupertinoOverrideTheme: CupertinoThemeData(
          // textTheme: CupertinoTextThemeData(),
          primaryColor: Colors.black54
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.5),
          subtitle1: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.5),
          subtitle2: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.3),
          caption: TextStyle( color:Colors.black,height: 1.3),
        ),
        snackBarTheme: new SnackBarThemeData(
          backgroundColor: Colors.grey,
          // actionTextColor,
          // disabledActionTextColor,
          // contentTextStyle,
          elevation: 0.0,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(5, 7),
            )
          ),
          behavior: SnackBarBehavior.fixed
        ),

        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // clipBehavior: Clip.antiAlias,
          modalBackgroundColor: colorPrimarySwatch[10],
          modalElevation: 20.0,
          backgroundColor:  Theme.of(context).primaryColor,
          elevation: 10.0,
          // clipBehavior: Clip.antiAlias
          // backgroundColor: Colors.red
        ),
        // tooltipTheme: TooltipThemeData()
      ),
      // initialRoute: '/home',
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   // '/': (context) => Home(),
      //   // '/home': (context) => Home(),
      //   '1': (context) => Bible(),
      //   '2': (context) => Note(),
      //   '3': (context) => Search(),
      // },
      // onUnknownRoute: (RouteSettings s){
      //   return MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))));
      // },
      home: MainView()
    );
  }
}