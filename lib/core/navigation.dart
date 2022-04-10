part of data.core;

class NavigationObserver extends UnitNavigationObserver {
  final NavigationNotify changeNotifier;

  NavigationObserver(this.changeNotifier) : super(changeNotifier);
}

class NavigationNotify extends UnitNavigationNotify {
  @override
  void push(Route<dynamic> currentRoute, Route<dynamic>? previousRoute) {
    super.push(currentRoute, previousRoute);
    debugPrint('push route $name from $previous');
  }

  @override
  void pop(Route<dynamic> previousRoute, Route<dynamic>? currentRoute) {
    super.pop(previousRoute, currentRoute);
    // debugPrint('pop current ${current.settings.name} previous $name');
    debugPrint('pop route $name from $previous');
  }
}
