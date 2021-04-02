import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scriptive/core.dart';
import 'package:scriptive/scroll.dart';
import 'package:scriptive/widget.dart';
import 'package:scriptive/icon.dart';

import 'package:scriptive/view/home/main.dart' as Home;
import 'package:scriptive/view/read/main.dart' as Read;
import 'package:scriptive/view/note/main.dart' as Note;
import 'package:scriptive/view/search/main.dart' as Search;
// import 'package:scriptive/view/demo/more/main.dart' as More;
// import 'package:scriptive/view/demo/myordbok/home/main.dart' as More;

part 'laisiangtho.launcher.dart';

final String appName = Core.instance.appName;
// final Core appInstance = Core.instance;

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainView> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final _navigator = GlobalKey<NavigatorState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  // final focusNode = FocusNode();
  final core = Core();

  final GlobalKey<Home.View> home = GlobalKey<Home.View>();
  final GlobalKey<Read.View> read = GlobalKey<Read.View>();
  final GlobalKey<Note.View> note = GlobalKey<Note.View>();
  final GlobalKey<Search.View> search = GlobalKey<Search.View>();
  // final GlobalKey<More.View> more = GlobalKey<More.View>();
  final homeKey = UniqueKey();
  final readKey = UniqueKey();
  final noteKey = UniqueKey();
  final searchKey = UniqueKey();
  final moreKey = UniqueKey();

  List<Widget> pageView = [];
  List<ModelPage> pageButton = [];

  Future<void> initiator;

  @override
  void initState() {
    super.initState();
    initiator = core.init();
    if (pageView.length == 0){
      pageButton = [
        ModelPage(icon:CustomIcon.flag, name:"Home", description: "List of Holy Bible in many languages", key: home),
        ModelPage(icon:CustomIcon.book_open, name:"Read", description: "Read bible by chapter", key: read),
        ModelPage(icon:CustomIcon.list_nested, name:"Bookmark", description: "Bookmark list", key: note),
        ModelPage(icon:CustomIcon.search, name:"Search", description: "Search bible", key: search),
        // ModelPage(icon:Icons.more_horiz, name:"More",description: "More information/Working", key: more)
      ];
      pageView = [
        WidgetKeepAlive(key:homeKey, child: new Home.Main(key: home,barMaxHeight:100)),
        WidgetKeepAlive(key:readKey, child: new Read.Main(key: read)),
        WidgetKeepAlive(key:noteKey, child: new Note.Main(key: note)),
        WidgetKeepAlive(key:searchKey, child: new Search.Main(key: search)),
        // WidgetKeepAlive(key:moreKey, child: new More.Main(key: more)),
      ];
    }

    _controller.master.bottom.pageListener((int index){
      // navigator.currentState.pushReplacementNamed(index.toString());

      ModelPage page = pageButton[index];
      // NOTE: check State isMounted
      if(page.key.currentState != null){
        page.key.currentState.setState(() {});
      }
      pageController.jumpToPage(index);

      core.analyticsScreen(page.name,'${page.name}State');

      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // navigator.currentState.pushNamed(index.toString());
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Note(),
      // ));
      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => Bible(), maintainState: false));
      // Navigator.of(context, rootNavigator: false).pushNamed(index.toString());
      // Navigator.of(context, rootNavigator: false).pushReplacementNamed(index.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void _pageClick(int index){
    _controller.master.bottom.pageChange(index);
  }

  // void _pageChanged(int index){
  //   _controller.master.bottom.pageChange(index);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initiator,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ScreenLauncher(message:'A moment');
            break;
          case ConnectionState.active:
            return ScreenLauncher(message:'...wait');
            break;
          case ConnectionState.none:
            return ScreenLauncher(message:'getting ready...');
            break;
          // case ConnectionState.done:
          //   return _start();
          //   break;
          default:
            return _start();
        }
      }
    );
    // return ScreenLauncher(message:'A moment');
  }

  Widget _start() {
    return Scaffold(
      key: scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      // body: Navigator(key: navigator, onGenerateRoute: _routeGenerate, onUnknownRoute: _routeUnknown ),
      body: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: _page()
      ),
      extendBody: true,
      bottomNavigationBar: _bottom()
    );
  }

  Widget _bottom() {
    return ScrollPageBottom(
      controller: _controller,
      items: pageButton,
      pageClick:_pageClick,
      // child: Text('??1'),
    );
  }

  Widget _page() {
    // return PageView(
    //   controller: pageController,
    //   onPageChanged: _pageChanged,
    //   physics:new NeverScrollableScrollPhysics(),
    //   children: pageView
    // );

    // return PageView.custom(
    //   controller: pageController,
    //   onPageChanged: _pageChanged,
    //   physics:new NeverScrollableScrollPhysics(),
    //   childrenDelegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) => KeepAlive(key: UniqueKey(), child: pageView[index]),,
    //     childCount: pageView.length,
    //     findChildIndexCallback: (Key key) {
    //       final ValueKey valueKey = key;
    //       final Widget child = valueKey.value;
    //       return pageView.indexOf(child);
    //     }
    //   )
    // );

    return new PageView.builder(
      controller: pageController,
      // onPageChanged: _pageChanged,
      allowImplicitScrolling:false,
      physics:new NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => pageView[index],
      itemCount: pageView.length,
    );
  }


  // Route<dynamic> _routeGenerate(RouteSettings settings) {
  //   switch (settings.name) {
  //     case "1":
  //       return _routeAnimation(Bible());
  //     case "2":
  //       return _routeAnimation(Note());
  //     case "3":
  //       return _routeAnimation(Search());
  //     case "4":
  //       return _routeAnimation(More());
  //     default:
  //       return _routeAnimation(Home());
  //   }
  // }

  // Route<dynamic> _routeAnimation(Widget page){
  //   // MaterialPageRoute(builder: (context) => Home(),maintainState: false);
  //   return PageRouteBuilder(
  //     maintainState: true,
  //     pageBuilder: (context, a, b) => page,
  //     transitionsBuilder: (context, a, b, child) => FadeTransition(opacity: a, child: child),
  //     transitionDuration: Duration(milliseconds: 200),
  //   );
  //   // Navigator.push(
  //   //   context,
  //   //   PageRouteBuilder(
  //   //     pageBuilder: (c, a, b) => Bible(),
  //   //     transitionsBuilder: (c, a, b, child) => FadeTransition(opacity: a, child: child),
  //   //     transitionDuration: Duration(milliseconds: 200),
  //   //   ),
  //   // );
  // }

  // Route<dynamic> _routeUnknown(RouteSettings settings){
  //   return MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))));
  // }

}