import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '../routes.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments, this.defaultRouteName}) : super(key: key);

  final Object? arguments;
  final String? defaultRouteName;

  static const route = '/search';
  static const icon = LideaIcon.search;
  static const name = 'Search';
  static const description = 'Search';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> {
  late final _key = GlobalKey<NavigatorState>();

  late final NavigationObserver obs = NavigationObserver(
    Provider.of<NavigationNotify>(
      context,
      listen: false,
    ),
  );

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
    return Scaffold(
      body: Navigator(
        key: _key,
        // observers: [obs],
        restorationScopeId: 'search',
        initialRoute: AppRoutes.searchInitial(name: widget.defaultRouteName),
        onGenerateRoute: (RouteSettings routeSettings) {
          return AppRoutes.searchBuilder(
            routeSettings,
            ViewNavigationArguments(
              key: _key,
              args: widget.arguments,
              canPop: routeSettings.arguments == null,
            ),
          );
        },
      ),
    );
  }
}
