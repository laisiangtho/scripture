import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bible/avail.dart';

import 'package:bible/view/Home.dart';
import 'package:bible/view/Bible.dart';
import 'package:bible/view/Note.dart';
import 'package:bible/view/Search.dart';
// import 'package:bible/view/search.dart';
// export 'package:bible/view/splash.dart';
// import 'More.dart';
import 'package:bible/component/all.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final navigator = GlobalKey<NavigatorState>();
  final pageController = PageController();
  final controller = ScrollController();
  final store = Store();

  @override
  void initState() {
    super.initState();
    // store.focusNode.addListener(() {
    //   setState(() {});
    //   controller.master.bottom.heightToggle(store.focusNode.hasFocus);
    // });
    controller.master.bottom.pageListener((int index){
      // navigator.currentState.pushReplacementNamed(index.toString());
      pageController.jumpToPage(index);
      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // navigator.currentState.pushNamed(index.toString());
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Note(),
      // ));
      // print('page change $index');
      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => Note(), maintainState: false));
      // Navigator.of(context, rootNavigator: false).pushNamed(index.toString());
      // Navigator.of(context, rootNavigator: false).pushReplacementNamed(index.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  void _pageClick(int index){
    controller.master.bottom.pageChange(index);
  }

  void _pageChanged(int index){
    controller.master.bottom.pageChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        key: scaffoldKey,
        // resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // body: Navigator(key: navigator, onGenerateRoute: routeGenerate, ),
        body: pageView(),
        bottomNavigationBar: bottomView(),
        // onUnknownRoute: routeUnknown,
        extendBody: true,
        // persistentFooterButtons: <Widget>[
        //   Text('a')
        // ],
      ),
    );
  }

  Widget bottomView() {
    return ScrollPageBottom(
      controller: controller,
      pageChange:_pageClick,
      child: Text('??'),
    );
  }

  PageView pageView() {
    return PageView(
      controller: pageController,
      // pageSnapping: false,
      onPageChanged: _pageChanged,
      // onPageChanged: controller.bottom.pageChange,
      physics:new NeverScrollableScrollPhysics(),
      children: <Widget>[
        Home(scaffoldKey: scaffoldKey),
        Bible(),
        Note(),
        Search(),
      ]
    );
  }
  /*
  Route<dynamic> routeGenerate(RouteSettings settings) {
    switch (settings.name) {
      case "1":
        return routeAnimation(Bible());
      case "2":
        return routeAnimation(Note());
      case "3":
        return routeAnimation(Search());
      default:
        return routeAnimation(Home());
    }
  }

  Route<dynamic> routeAnimation(Widget page){
    // MaterialPageRoute(builder: (context) => Home(),maintainState: false);
    return PageRouteBuilder(
      maintainState: false,
      pageBuilder: (context, a, b) => page,
      transitionsBuilder: (context, a, b, child) => FadeTransition(opacity: a, child: child),
      transitionDuration: Duration(milliseconds: 200),
    );
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (c, a1, a2) => Bible(),
    //     transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
    //     transitionDuration: Duration(milliseconds: 200),
    //   ),
    // );
  }
  Route<dynamic> routeUnknown(RouteSettings settings){
    return MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))));
  }
  */
}
