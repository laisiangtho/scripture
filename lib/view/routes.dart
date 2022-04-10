import 'package:flutter/material.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';

import 'main.dart' as root;

import 'launch/main.dart' as launch;
import 'launch/home/main.dart' as home;
import 'launch/bible/main.dart' as bible;

import 'read/main.dart' as read;
import 'note/main.dart' as note;
import 'search/main.dart' as search_page;
import 'search/result/main.dart' as search_result;
import 'search/suggest/main.dart' as search_suggest;

import 'user/main.dart' as user;
import 'read/main.dart' as reader;

class AppRoutes {
  static String rootInitial = root.Main.route;
  static Map<String, Widget Function(BuildContext)> rootMap = {
    root.Main.route: (BuildContext _) {
      return const root.Main();
    },
    bible.Main.route: (BuildContext _) {
      return const bible.Main();
    },
  };

  // static void showParallelList(BuildContext context) {
  //   Navigator.of(context, rootNavigator: true).pushNamed(bible.Main.route);
  // }

  // static GlobalKey<NavigatorState> homeNavigator = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeNavigator = launch.Main.navigator;

  static String homeInitial({String? name}) => name ?? launch.Main.route;

  static Widget _homePage(RouteSettings route) {
    switch (route.name) {
      // case search_page.Main.route:
      //   return search_page.Main(
      //     arguments: route.arguments,
      //     defaultRouteName: search_suggest.Main.route,
      //   );
      // case search_page.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);
      case search_suggest.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      case search_result.Main.route:
        return search_page.Main(arguments: route.arguments);

      // case search_result.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);

      case user.Main.route:
        return user.Main(arguments: route.arguments);
      case reader.Main.route:
        return reader.Main(arguments: route.arguments);
      case bible.Main.route:
        return bible.Main(arguments: route.arguments);
      case home.Main.route:
      default:
        // throw Exception('Invalid route: ${route.name}');
        return home.Main(arguments: route.arguments);
    }
  }

  // static Route<dynamic>? homeBuilder(RouteSettings route) {
  //   return MaterialPageRoute<void>(
  //     settings: route,
  //     fullscreenDialog: true,
  //     builder: (BuildContext context) {
  //       return _homePage(route);
  //     },
  //   );
  // }

  static Route<dynamic>? homeBuilder(RouteSettings route) {
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        return _homePage(route);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _b, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      fullscreenDialog: true,
    );
  }

  // static GlobalKey<NavigatorState> searchNavigator = search_page.Main.navigator;
  // static GlobalKey<NavigatorState> searchNavigator => GlobalKey<NavigatorState>();

  static String searchInitial({String? name}) => name ?? search_result.Main.route;

  static Route<dynamic>? searchBuilder(RouteSettings route, Object? args) {
    // final arguments = ViewNavigationArguments(
    //   navigator: searchNavigator,
    //   args: args,
    // );
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        switch (route.name) {
          case search_suggest.Main.route:
            return search_suggest.Main(arguments: args);
          case search_result.Main.route:
          default:
            return search_result.Main(arguments: args);
        }
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      fullscreenDialog: true,
    );
  }
}

// AppPageView AppPageNavigation
class AppPageNavigation {
  // static final controller = PageController(keepPage: true);
  static List<ViewNavigationModel> button(Preference preference) {
    return [
      ViewNavigationModel(
        key: 0,
        icon: launch.Main.icon,
        name: launch.Main.name,
        description: preference.text.home,
      ),
      ViewNavigationModel(
        key: 1,
        icon: read.Main.icon,
        name: read.Main.name,
        description: preference.text.read,
      ),
      ViewNavigationModel(
        key: 2,
        icon: note.Main.icon,
        name: note.Main.name,
        description: preference.text.note(false),
      ),
      ViewNavigationModel(
        key: 3,
        icon: search_page.Main.icon,
        name: search_page.Main.name,
        description: preference.text.search(false),
      ),
    ];
  }

  // static List<Widget> page({
  //   GlobalKey<NavigatorState>? homeNavigator,
  //   GlobalKey<NavigatorState>? searchNavigator,
  // }) {
  //   return [
  //     WidgetKeepAlive(
  //       key: home.Main.uniqueKey,
  //       child: home.Main(
  //         navigator: homeNavigator,
  //       ),
  //     ),
  //     WidgetKeepAlive(
  //       key: read.Main.uniqueKey,
  //       child: const read.Main(),
  //     ),
  //     WidgetKeepAlive(
  //       key: note.Main.uniqueKey,
  //       child: const note.Main(),
  //     ),
  //     WidgetKeepAlive(
  //       key: search_page.Main.uniqueKey,
  //       child: search_page.Main(
  //         navigator: searchNavigator,
  //       ),
  //     ),
  //   ];
  // }
  static List<Widget> page = [
    ViewKeepAlive(
      key: launch.Main.uniqueKey,
      child: const launch.Main(),
    ),
    ViewKeepAlive(
      key: read.Main.uniqueKey,
      child: const read.Main(),
    ),
    ViewKeepAlive(
      key: note.Main.uniqueKey,
      child: const note.Main(),
    ),
    ViewKeepAlive(
      key: search_page.Main.uniqueKey,
      child: const search_page.Main(),
    ),
  ];
}
