import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Snap extends StatelessWidget {
  final ScrollBarsController controller;
  final Widget child;

  const Snap({
    Key key,
    this.controller,
    @required this.child,
  })  : assert(controller != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: _onNotification,
      child: child,
    );
  }

  bool _onNotification(UserScrollNotification notification) {
    if (notification.direction == ScrollDirection.idle) {
      if ([0.0, 1.0].contains(controller._heightFactor)) {
        return true;
      }

      final offset = controller._heightFactor.round() == 1
          ? -controller._delta
          : controller.height - controller._delta;

      controller.scrollController.animateTo(
        controller.scrollController.offset + offset,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
    return true;
  }
}

abstract class ScrollBarsController {
  ScrollBarsController(this.scrollController)
  : assert(scrollController != null) {
    scrollController.addListener(_scrollListener);
  }

  /// Height of the bar
  double get height;

  /// Scroll controller
  ScrollController scrollController;

  /// Notifier of the visible height factor of bar
  final heightNotifier = ValueNotifier<double>(1.0);

  /// Notifier of the pin state changes
  final pinNotifier = ValueNotifier<bool>(false);

  /// Returns [true] if the bar is pinned or [false] if the bar is not pinned
  bool get isPinned => pinNotifier.value;

  /// Set a new pin state
  void setPinState(bool state) => pinNotifier.value = state;

  /// Toogle the pin state
  void tooglePinState() => setPinState(!pinNotifier.value);

  double _delta = 0.0, _oldOffset = 0.0;

  double get _heightFactor => 1.0 - (_delta / height);

  void _scrollListener() {
    ScrollPosition position = scrollController.position;
    double pixels = position.pixels;

    _delta = (_delta + pixels - _oldOffset).clamp(0.0, height);
    _oldOffset = pixels;


    if (position.axisDirection == AxisDirection.down && position.extentAfter == 0.0) {
      if (heightNotifier.value == 0.0) return;
      heightNotifier.value = 0.0;
      return;
    }

    if (position.axisDirection == AxisDirection.up && position.extentBefore == 0.0) {
      if (heightNotifier.value == 1.0) return;
      heightNotifier.value = 1.0;
      return;
    }

    if ((_delta == 0.0 && heightNotifier.value == 0.0) || (_delta == height && heightNotifier.value == 1.0)) return;

    heightNotifier.value = _heightFactor;
  }

  /// Discards resources
  void dispose() {
    pinNotifier.dispose();
    heightNotifier.dispose();
  }
}

extension ScrollBottomNavigationBarControllerExt on ScrollController {
  static final _controllers = <int, _ScrollBottomNavigationBarController>{};

  _ScrollBottomNavigationBarController get bottomNavigationBar {
    if (_controllers.containsKey(this.hashCode)) {
      return _controllers[this.hashCode];
    }

    return _controllers[this.hashCode] =
        _ScrollBottomNavigationBarController(this);
  }
}

class _ScrollBottomNavigationBarController extends ScrollBarsController {
  _ScrollBottomNavigationBarController(ScrollController scrollController)
      : assert(scrollController != null),
        super(scrollController);

  @override
  double height = kBottomNavigationBarHeight;

  /// Notifier of the active page index
  final tabNotifier = ValueNotifier<int>(0);

  /// Register a closure to be called when the tab changes
  void tabListener(Function(int) listener) {
    tabNotifier.addListener(() => listener(tabNotifier.value));
  }

  /// Set a new tab
  void setTab(int index) => tabNotifier.value = index;

  @override
  void dispose() {
    tabNotifier.dispose();
    super.dispose();
  }
}