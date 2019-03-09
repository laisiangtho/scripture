import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:laisiangtho/Store.dart';
import 'package:laisiangtho/Home.dart';
import 'package:laisiangtho/Note.dart';
import 'package:laisiangtho/Book.dart';
import 'package:laisiangtho/Bible.dart';
import 'package:laisiangtho/ScrollsAnimation.dart';
import 'package:laisiangtho/ScrollsOne.dart';
import 'package:laisiangtho/Tab.dart';
import 'package:laisiangtho/Testing.dart';

void main() => runApp(LaiSiangtho());

class LaiSiangtho extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[500],
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      // systemNavigationBarDividerColor: Colors.red,
      statusBarColor: Colors.grey[300],
    ));
    return MaterialApp(
      // title: Store.appName,
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        // primaryColor: Color.fromRGBO(255, 255, 255, 1.0),
        primaryColor: Colors.grey[50],
        // primaryColorDark: Colors.red,
        // primaryColorBrightness: Brightness.dark,
        // primarySwatch: Colors.grey,
        // primaryColorLight: Colors.orange,
        // primarySwatch: AppColor.appColor,

        backgroundColor: Colors.grey[50],
        // backgroundColor: Colors.transparent,
        // primaryColor: Color.fromRGBO(237, 237, 237, 1.0),
        // brightness: Brightness.light,
        // accentColor: Colors.grey,
        // indicatorColor:Colors.blue,
        // canvasColor: Colors.blueGrey,
        canvasColor: Colors.transparent,
        iconTheme: new IconThemeData(
          color: Colors.black54,
          opacity: 1.0,
          size: 25.0
        ),
        textTheme: TextTheme(
          title: TextStyle(fontWeight: FontWeight.w300, fontSize: 13.0),
          subtitle: TextStyle(fontWeight: FontWeight.w300, fontSize: 11.0, color:Colors.brown),
        )
      ),
      // home: new Home(),
      initialRoute: '/',
      // onGenerateRoute: getGenerateRoute,
      routes: <String, WidgetBuilder>{
        '/': (context) => new Home(),
        // 'launcher': (context) => Launcher(),
        'note': (context) => new Note(),
        'book': (context) => new Book(),
        'bible': (context) => new Bible(),
        'tab': (context) => new Tabs(),
        'CustomScrollOne': (context) => new CustomScrollOne(),
        'ScrollsAnimation': (context) => new ScrollsAnimation(),
        'Testing': (context) => new Testing()
      }
    );
  }
}
// Route<Null> getGenerateRoute(RouteSettings settings) {
//   // final List<String> path = settings.name.split('/');
//   print(settings);
//   // The other paths we support are in the routes table.
//   return null;
// }