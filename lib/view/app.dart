import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
import 'package:lidea/view.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';

// import 'package:bible/view/home/main.dart' as home;
// import 'package:bible/view/read/main.dart' as read;
// import 'package:bible/view/note/main.dart' as note;
// import 'package:bible/view/search/main.dart' as search;
import 'app.routes.dart';

part 'app.view.dart';
part 'app.launcher.dart';
part 'app.other.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.settings}) : super(key: key);
  final SettingsController? settings;

  static const route = '/root';

  @override
  _State createState() => AppView();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  // final _homeNavigator = GlobalKey<NavigatorState>();
  // final _searchNavigator = GlobalKey<NavigatorState>();

  // late Core core;
  late StreamSubscription<ConnectivityResult> _connection;

  // late final Core core = Provider.of<Core>(context, listen: false);
  late final Core core = context.read<Core>();
  late final NavigatorNotify _navigatorNotify = context.read<NavigatorNotify>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  AppLocalizations get translate => AppLocalizations.of(context)!;

  late final Future<void> initiator = core.init();
  // late final initiator = Future.delayed(const Duration(milliseconds: 300));
  // late final GlobalKey<NavigatorState> _tmp123 = AppRoutes.pageRouteNavigator;

  List<ViewNavigationModel> get _pageButton => AppPageNavigation.button(translate);

  late final List<Widget> _pageView = AppPageNavigation.page;

  @override
  void initState() {
    super.initState();
    core.navigate = navigate;

    _connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      // ConnectivityResult.mobile
      // ConnectivityResult.wifi
      // ConnectivityResult.none
    });
  }

  @override
  void dispose() {
    // core.store?.subscription?.cancel();
    _controller.dispose();
    super.dispose();
    _connection.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void Function()? _navButtonAction(ViewNavigationModel item, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null) {
      return () => _navPageViewAction(item.key);
    } else {
      return item.action;
    }
  }

  void _navPageViewAction(int index) {
    _navigatorNotify.index = index;
    ViewNavigationModel page = _pageButton.firstWhere(
      (e) => e.key == index,
      orElse: () => _pageButton.first,
    );
    core.analyticsScreen('${page.name}', '${page.name}State');
    // NOTE: check State isMounted
    // if(page.key.currentState != null){
    //   page.key.currentState.setState(() {});
    // }
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void navigate({int at = 0, String? to, Object? args, bool routePush = true}) {
    _navPageViewAction(at);
    final _tmp123 = AppRoutes.homeNavigator;
    // final _tmp123 = AppNavigatorState.home;
    // final _tmp123 = _homeNavigator;
    final state = _tmp123.currentState;
    if (to != null && state != null) {
      final canPop = state.canPop();
      // final canPop = Navigator.canPop(context);
      final arguments = ViewNavigationArguments(
        navigator: _tmp123,
        args: args,
        canPop: canPop,
      );
      if (routePush) {
        state.pushNamed(to, arguments: arguments);
        // Navigator.of(context).pushNamed(to, arguments: arguments);
      } else {
        state.pushReplacementNamed(to, arguments: arguments);
        // Navigator.of(context).pushReplacementNamed(to, arguments: arguments);
      }
    }
  }
}
