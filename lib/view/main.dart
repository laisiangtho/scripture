import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
import 'package:lidea/cluster/main.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';
// import '/type/main.dart';
import '/widget/main.dart';

import 'routes.dart';

part 'view.dart';
part 'launcher.dart';
part 'navigator.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static const route = '/root';

  @override
  MainState createState() => AppView();
}

abstract class MainState extends State<Main> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(keepPage: true);
  final _controller = ScrollController();

  late StreamSubscription<ConnectivityResult> _connection;

  // late final Core core = Provider.of<Core>(context, listen: false);
  late final Core core = context.read<Core>();
  // late final NavigationNotify _navigationNotify = context.read<NavigationNotify>();
  // late final ViewScrollNotify viewScrollNotify = context.read<ViewScrollNotify>();

  late final Future<void> initiator = core.init(context);

  Preference get preference => core.preference;
  List<ViewNavigationModel> get _pageButton => AppPageNavigation.button(preference);

  late final List<Widget> _pageView = AppPageNavigation.page;

  @override
  void initState() {
    super.initState();
    core.navigate = navigate;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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

  void _navPageViewAction(int index) {
    core.navigation.index = index;
    ViewNavigationModel page = _pageButton.firstWhere(
      (e) => e.key == index,
      orElse: () => _pageButton.first,
    );
    final screenName = UtilString.screenName(page.name);
    final screenClass = UtilString.screenClass(core.navigation.name);

    core.analytics.screen(screenName, screenClass);

    // NOTE: check State isMounted
    // if(page.key.currentState != null){
    //   page.key.currentState.setState(() {});
    // }
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void navigate({int at = 0, String? to, Object? args, bool routePush = true}) {
    if (core.navigation.index != at) {
      _navPageViewAction(at);
    }
    final vi = AppRoutes.homeNavigator;
    final st = vi.currentState;
    if (to != null && st != null) {
      final ar = ViewNavigationArguments(key: vi, args: args, canPop: st.canPop());
      if (routePush) {
        st.pushNamed(to, arguments: ar);
        // Navigator.of(context).pushNamed(to, arguments: ar);
      } else {
        // _state.pushReplacementNamed(to, arguments: ar);
        st.pushNamedAndRemoveUntil(to, ModalRoute.withName('/'), arguments: ar);
      }

      final screenName = UtilString.screenName(to);
      final screenClass = UtilString.screenClass(core.navigation.name);
      core.analytics.screen(screenName, screenClass);
    }
  }
}
