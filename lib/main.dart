import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:bible/screen/main.dart';
import 'package:bible/core.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  final MaterialColor colorPrimarySwatch = MaterialColor(
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
        statusBarColor: Color(0xFFFFFFFF),
        // statusBarColor: Colors.transparent,
        // statusBarColor: Color(0x00000000),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        // systemNavigationBarColor: Colors.red,
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

        // scaffoldBackgroundColor: store.colorPrimarySwatch[0],
        scaffoldBackgroundColor: colorPrimarySwatch[50],
        // scaffoldBackgroundColor: Color(0x00000000),
        primaryColor: colorPrimarySwatch[10],
        backgroundColor: colorPrimarySwatch[400],
        // primarySwatch: colorPrimarySwatch,
        canvasColor: Colors.transparent,
        // canvasColor: colorPrimarySwatch[0],

        // dialogTheme: DialogTheme(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0
        // ),
        iconTheme: new IconThemeData(
          color: Colors.grey,
        ),
        primaryIconTheme:new IconThemeData(
          color: Colors.grey,
        ),
        // accentIconTheme:new IconThemeData(
        //   color: Colors.green,
        // ),

        buttonTheme: new ButtonThemeData(
          splashColor: Colors.transparent
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cupertinoOverrideTheme: CupertinoThemeData(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.5),
          subtitle1: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.5),
          subtitle2: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.3),
          caption: TextStyle( color:Colors.black,height: 1.3),
        ),
        snackBarTheme: new SnackBarThemeData(
          backgroundColor: Colors.black45,
          // actionTextColor,
          // disabledActionTextColor,
          // contentTextStyle,
          elevation: 0.0,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(3, 2),
            )
          ),
          behavior: SnackBarBehavior.fixed
        ),

        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          clipBehavior: Clip.antiAlias,
          modalBackgroundColor: colorPrimarySwatch[10],
          modalElevation: 20.0,
          backgroundColor:  Theme.of(context).primaryColor,
          elevation: 10.0,
          // clipBehavior: Clip.antiAlias
          // backgroundColor: Colors.red
        )
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