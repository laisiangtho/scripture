import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/icon.dart';

import 'package:bible/settings.dart';
import 'package:bible/view/app.routes.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.settings}) : super(key: key);

  final SettingsController? settings;

  static const route = '/home';
  static const icon = LideaIcon.flag;
  static const name = 'home';
  static const description = 'home';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();
  static final navigator = GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> {
  late final NavigatorNotifyObserver obs = NavigatorNotifyObserver(
    Provider.of<NavigatorNotify>(
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
          restorationScopeId: 'home',
          observers: [obs],
          onGenerateRoute: AppRoutes.homeBuilder,
        ),
      ),
    );
  }
}
