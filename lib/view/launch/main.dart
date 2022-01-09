import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '../routes.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static const route = '/launch';
  // static const icon = Icons.school;
  static const icon = LideaIcon.flag;
  static const name = 'Launch';
  static const description = '';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();
  static final navigator = GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> {
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
      body: HeroControllerScope(
        controller: MaterialApp.createMaterialHeroController(),
        child: Navigator(
          key: Main.navigator,
          initialRoute: AppRoutes.homeInitial(),
          restorationScopeId: 'launch',
          observers: [obs],
          onGenerateRoute: AppRoutes.homeBuilder,
        ),
      ),
    );
  }
}
