import 'package:flutter/material.dart';

import 'package:lidea/view.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';

import 'package:bible/settings.dart';

import '../app.routes.dart';
// import 'result/main.dart' as result;
// import 'suggest/main.dart' as suggest;

class Main extends StatefulWidget {
  const Main({
    Key? key,
    // this.navigator,
    this.arguments,
    this.defaultRouteName,
  }) : super(key: key);

  // final SettingsController? settings;
  // final GlobalKey<NavigatorState>? navigator;
  final Object? arguments;
  final String? defaultRouteName;

  static const route = '/search';
  static const icon = LideaIcon.search;
  static const name = 'Search';
  static const description = 'Search';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();
  // static final navigator = GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> {
  // ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  // GlobalKey<NavigatorState> get navigator => GlobalKey<NavigatorState>();
  late final navigator = GlobalKey<NavigatorState>();
  late final NavigatorNotifyObserver obs = NavigatorNotifyObserver(
    Provider.of<NavigatorNotify>(
      context,
      listen: false,
    ),
  );
  // late final key = AppRoutes.searchNavigator;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // navigatorKey.currentState
    // final asdf = navigator.currentState;
    return Scaffold(
      body: HeroControllerScope(
        controller: MaterialApp.createMaterialHeroController(),
        child: Navigator(
          key: navigator,
          // observers: [obs],
          restorationScopeId: 'search',
          initialRoute: AppRoutes.searchInitial(name: widget.defaultRouteName),
          onGenerateRoute: (RouteSettings route) {
            final arguments = ViewNavigationArguments(
              navigator: navigator,
              args: widget.arguments,
            );
            return AppRoutes.searchBuilder(route, arguments);
          },
        ),
      ),
    );
  }
}
