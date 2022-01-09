part of 'main.dart';

class NavigationObserver extends UnitNavigationObserver {
  final NavigationNotify changeNotifier;

  NavigationObserver(this.changeNotifier) : super(changeNotifier);
}

class NavigationNotify extends UnitNavigationNotify {
  @override
  void push(Route<dynamic> current, Route<dynamic>? previous) {
    super.push(current, previous);
    if (name != null) {
      debugPrint('push current $name');
    }
    if (previous != null) {
      debugPrint('push previous $name');
    }
  }

  @override
  void pop(Route<dynamic> current, Route<dynamic>? previous) {
    super.pop(current, previous);
    debugPrint('pop current ${current.settings.name} previous $name');
  }
}
