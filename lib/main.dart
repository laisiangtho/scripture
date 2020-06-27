import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// import 'package:bible/layout/tabRoute.dart';
import 'package:bible/layout/pageView.dart';
import 'package:bible/avail.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark
    )
  );
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
  //   statusBarColor: Colors.white,
  //   statusBarBrightness: Brightness.light,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarIconBrightness: Brightness.dark
  // ));
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(LaiSiangtho()));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]).then((_){
    runApp(LaiSiangtho());
  });
}

class LaiSiangtho extends StatelessWidget {

  final store = new Store();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: store.appTitle,
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: false,
      // showSemanticsDebugger: false,
      // debugShowMaterialGrid: false,
      theme: ThemeData(
        // fontFamily: "Caveat, Paduak, sans-serif",
        // fontFamily: "Caveat, , Mm3Web",
        fontFamily: "Mm3Web, Old Standard TT",
        // fontFamily: "Mm3Web",
        // fontFamily: "Paduak",

        // platform: TargetPlatform.iOS,
        // platform: TargetPlatform.android,

        scaffoldBackgroundColor: store.colorPrimarySwatch[10],
        // scaffoldBackgroundColor: Color(0x00000000),
        primarySwatch: store.colorPrimarySwatch,
        primaryColor: store.colorPrimarySwatch[10],
        backgroundColor: store.colorPrimarySwatch[400],
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
        // accentIconTheme:new IconThemeData(
        //   color: Colors.green,
        // ),
        buttonTheme: new ButtonThemeData(
          splashColor: Colors.transparent
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // cupertinoOverrideTheme: CupertinoThemeData(),

        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.deepOrange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.5),
          subtitle1: TextStyle(fontWeight: FontWeight.w200,color:Colors.black,height: 1.5),
          subtitle2: TextStyle(fontWeight: FontWeight.w300,color:Colors.black,height: 1.3),
          caption: TextStyle(fontWeight: FontWeight.w200,color:Colors.black,height: 1.3),
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