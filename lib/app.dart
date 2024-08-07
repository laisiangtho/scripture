import 'package:flutter/material.dart';

/// NOTE: Lidea
import 'package:lidea/view/keep_alive.dart';

/// NOTE: Core
import '/core/main.dart';
export '/core/main.dart';

/// NOTE: Routes
import '/view/routes.dart';
export '/view/routes.dart';

/// NOTE: Components
export '/components/main.dart';

/// App instance that providing Core, Data, Route, Preference, Authenticate and Context
class App {
  // static ScrollNotifier notifier = ScrollNotifier();
  // static Routes routeDelegate = Routes();
  // static RouteNotifier route = routeDelegate.state;
  static final Core core = Core();

  /// Scroll notifier for factor, toggle
  /// + MediaQueryData, since modal bottom sheet does nothing
  static final ViewData viewData = core.viewData;

  /// Route core delegate (routeDelegate)
  static final RouteDelegates routeDelegate = RouteDelegates();

  /// Route delegate notifier
  static final RouteNotifier route = routeDelegate.notifier;

  /// Data
  static final Data data = core.data;

  /// Theme, Locales
  static final Preference preference = core.preference;

  /// Social Sign in
  static final Authenticate authenticate = core.authenticate;
}

abstract class StateAbstract<T extends StatefulWidget> extends ViewStateWidget<T> {
  late final Map<String, dynamic> args = state.asMap;

  late final ViewData viewData = App.viewData;
  late final RouteDelegates routeDelegate = App.routeDelegate;
  late final RouteNotifier route = App.route;

  late final Core core = App.core;
  late final Data data = App.data;
  late final Preference preference = App.preference;
  late final Authenticate authenticate = App.authenticate;
}

class StateAlive extends ViewKeepAlive {
  const StateAlive({super.key, required super.child});
}
