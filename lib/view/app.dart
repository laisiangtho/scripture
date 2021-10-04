import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
// import 'package:lidea/connectivity.dart';
// import 'package:lidea/scroll.dart';
import 'package:lidea/view.dart';
import 'package:lidea/keepAlive.dart';

// import 'package:bible/notifier.dart';
import 'package:bible/core.dart';
// import 'package:bible/widget.dart';
import 'package:bible/icon.dart';

import 'package:bible/view/home/main.dart' as Home;
import 'package:bible/view/read/main.dart' as Read;
import 'package:bible/view/note/main.dart' as Note;
import 'package:bible/view/search/main.dart' as Search;
// import 'package:bible/view/more/main.dart' as more;

part 'app.launcher.dart';
part 'app.view.dart';

class AppMain extends StatefulWidget {
  AppMain({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AppView();
}

abstract class _State extends State<AppMain>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  // final core = Core();
  final viewNotifyNavigation = NotifyNavigationButton.navigation;

  // final GlobalKey<Home.View> _home = GlobalKey<Home.View>();
  // final GlobalKey<Note.View> _note = GlobalKey<Note.View>();
  // final GlobalKey<More.View> _more = GlobalKey<More.View>();
  final _homeGlobal = GlobalKey<ScaffoldState>();
  final _readGlobal = GlobalKey<ScaffoldState>();
  final _noteGlobal = GlobalKey<ScaffoldState>();
  final _searchGlobal = GlobalKey<ScaffoldState>();

  final _homeKey = UniqueKey();
  final _readKey = UniqueKey();
  final _noteKey = UniqueKey();
  final _searchKey = UniqueKey();

  final List<Widget> _pageView = [];
  final List<ViewNavigationModel> _pageButton = [];

  late Core core;
  late Future<void> initiator;
  // late StreamSubscription<ConnectivityResult> connection;

  @override
  void initState() {
    super.initState();
    // Provider.of<Core>(context, listen: false);
    core = context.read<Core>();
    initiator = core.init();

    // initiator = new Future.delayed(new Duration(seconds: 1));
    // connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   // Got a new connectivity status!
    //   // ConnectivityResult.mobile
    //   // ConnectivityResult.wifi
    //   // ConnectivityResult.none
    //   debugPrint(result);
    // });
    if (_pageView.length == 0) {
      _pageButton.addAll([
        // ViewNavigationModel(icon:MyOrdbokIcon.chapter_previous, name:"Previous", description: "Previous search", action: onPreviousHistory() ),

        ViewNavigationModel(
            icon: LaiSiangthoIcon.flag,
            name: "Home",
            description: "List of Holy Bible in many languages",
            key: 0),
        ViewNavigationModel(
            icon: LaiSiangthoIcon.book_open,
            name: "Read",
            description: "Read bible by chapter",
            key: 1),
        ViewNavigationModel(
            icon: LaiSiangthoIcon.list_nested,
            name: "Bookmark",
            description: "Bookmark list",
            key: 2),
        ViewNavigationModel(
            icon: LaiSiangthoIcon.search,
            name: "Search",
            description: "Search bible",
            key: 3),
        // ModelPage(icon:Icons.more_horiz, name:"More",description: "More information/Working", key: 4)
      ]);
      _pageView.addAll([
        WidgetKeepAlive(key: _homeKey, child: Home.Main(key: _homeGlobal)),
        WidgetKeepAlive(key: _readKey, child: Read.Main(key: _readGlobal)),
        WidgetKeepAlive(key: _noteKey, child: Note.Main(key: _noteGlobal)),
        WidgetKeepAlive(
            key: _searchKey, child: Search.Main(key: _searchGlobal)),
        // WidgetKeepAlive(key:moreKey, child: new More.Main(key: more)),
      ]);
    }

    viewNotifyNavigation.addListener(() {
      final index = viewNotifyNavigation.value;
      // navigator.currentState.pushReplacementNamed(index.toString());

      ViewNavigationModel page = _pageButton.firstWhere((e) => e.key == index,
          orElse: () => _pageButton.first);
      core.analyticsScreen(page.name, '${page.name}State');
      // NOTE: check State isMounted
      // if(page.key.currentState != null){
      //   page.key.currentState.setState(() {});
      // }
      pageController.jumpToPage(index);

      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
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
    _controller.dispose();
    viewNotifyNavigation.dispose();
    super.dispose();
    // connection.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _navView(int index) {
    // _controller.master.bottom.pageChange(index);
    viewNotifyNavigation.value = index;
  }

  void onSearch(String word) {
    NotifyNavigationButton.navigation.value = 0;
    Future.delayed(const Duration(milliseconds: 200), () {
      // core.definitionGenerate(word);
    });
    // Future.delayed(Duration.zero, () {
    //   core.historyAdd(word);
    // });
  }
}
