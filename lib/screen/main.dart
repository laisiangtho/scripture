import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bible/core.dart';
import 'package:bible/component.dart';
// import 'package:bible/widget.dart';

import 'package:bible/view/home/main.dart' as Home;
import 'package:bible/view/read/main.dart' as Read;
import 'package:bible/view/note/main.dart' as Note;
import 'package:bible/view/search/main.dart' as Search;
// import 'package:bible/view/more/main.dart' as More;

import 'package:bible/screen/SplashScreen.dart';

class MainView extends StatefulWidget {
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

  String identify;
  int bookId;
  int chapterId;

  List<Widget> pageView = [];
  List<ModelPage> pageList = [];

  @override
  void initState() {
    super.initState();
    if (pageView.length == 0){
      pageList = [
        ModelPage(
          icon:Icons.flag, name:"Home",
          key: home,
        ),
        ModelPage(
          icon:Icons.local_library, name:"Read",
          key: read,
        ),
        ModelPage(
          icon:Icons.book, name:"Bookmark",
          key: note,
        ),
        ModelPage(
          icon:CupertinoIcons.search, name:"Search",
          key: search,
        ),
        // ModelPage(
        //   icon:Icons.more_horiz, name:"More", key: ?,
        // )
      ];
      pageView = [
        KeepAlive(key:UniqueKey(), child: new Home.Main(key: home)),
        KeepAlive(key:UniqueKey(), child: new Read.Main(key: read)),
        KeepAlive(key:UniqueKey(), child: new Note.Main(key: note)),
        KeepAlive(key:UniqueKey(), child: new Search.Main(key: search))
      ];
    }
    // focusNode.addListener(() {
    //   _controller.master.bottom.toggle(focusNode.hasFocus);
    // });

    _controller.master.bottom.pageListener((int index){
      // navigator.currentState.pushReplacementNamed(index.toString());

      ModelPage page = pageList[index];
      if(page.key.currentState != null){
        // NOTE: check State isMounted
        if (
          (index == 1 && core.verseChapterBibleIsEmpty()) ||
          (index == 2) ||
          (index == 3 && core.verseSearchBibleIsEmpty())
        ) page.key.currentState.setState(() {});
      }
      // TODO: bookmarkView setState
      // && identify == core.identify
      identify = core.identify;
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
    // NOTE: initProgress
    core.init().whenComplete((){
      // print('init Completeds');
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

  void _pageChanged(int index){
    // _controller.master.bottom.pageChange(index);
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: core.initProgress,
      builder: (BuildContext context, double i,Widget child) => (i < 1.0)?SplashScreen(progress:i):_start()
    );
    // return LauncherScreen();
    // return WelcomeScreen();
    // return SplashScreen(progress:.5);
  }

  Widget _start() {
    return Scaffold(
      key: scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.transparent,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // body: Navigator(key: navigator, onGenerateRoute: _routeGenerate, onUnknownRoute: _routeUnknown ),
      body: SafeArea(
        top: true,
        // bottom: false,
        maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: _page()
      ),
      bottomNavigationBar: _bottom(),
      extendBody: true
      // extendBodyBehindAppBar: true,
    );
  }

  Widget _bottom() {
    return ScrollPageBottom(
      controller: _controller,
      items: pageList,
      pageClick:_pageClick,
      // child: Text('??1'),
    );
  }

  Widget _page() {
    // return PageView(
    //   controller: pageController,
    //   onPageChanged: _pageChanged,
    //   // onPageChanged: _controller.bottom.pageChange,
    //   physics:new NeverScrollableScrollPhysics(),
    //   children: pageView
    // );

    // return PageView.custom(
    //   // key: UniqueKey(),
    //   controller: pageController,
    //   onPageChanged: _pageChanged,
    //   physics:new NeverScrollableScrollPhysics(),
    //   childrenDelegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) => KeepAlive(key: UniqueKey(), child: pageView[index]),,
    //     childCount: pageView.length,
    //     // findChildIndexCallback: (Key key) {
    //     //   final ValueKey valueKey = key;
    //     //   final Widget child = valueKey.value;
    //     //   return pageView.indexOf(child);
    //     // }
    //   )
    // );

    return new PageView.builder(
      controller: pageController,
      onPageChanged: _pageChanged,
      allowImplicitScrolling:false,
      physics:new NeverScrollableScrollPhysics(),
      // itemBuilder: (a,index) => KeepAlive(key: UniqueKey(), child: pageView[index]),
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

class KeepAlive extends StatefulWidget {
  const KeepAlive({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
