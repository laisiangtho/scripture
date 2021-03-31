/*
version: 0.2
developer: Khen Solomon Lethil
*/
part of 'root.dart';

abstract class ScrollPageController {

  ScrollPageController(this.controller)
  : assert(controller != null) {
    // controller.addListener(_listener);
    controller.scrollNotification(_scrollNotification);
  }

  ScrollController controller;

  /// Height of the bar
  double get height;

  double _delta = 0.0, _offsetOld = 0.0; //_minOffset=0.0, _maxOffset=1.0;
  final heightNotify = ValueNotifier<double>(1.0);
  final direction = ValueNotifier<int>(0);
  final enableNotify = ValueNotifier<bool>(true);
  void enable (bool s) => enableNotify.value = s;

  double get percentage => (_delta / height).toDouble();
  double get percentageShrink => (1.0 - percentage).toDouble();
  // double get percentageStretch => ??;

  void _scrollNotification(ScrollNotification notification) {
    // print('${notification}');
    // if (notification is ScrollUpdateNotification) {
    // }
    if (notification == null) return;
    if (notification is UserScrollNotification) {
      // NOTE: down
      // if (notification.direction == ScrollDirection.forward) direction.value = 2;
      // NOTE: up
      // if (notification.direction == ScrollDirection.reverse) direction.value = 1;
      // if (notification.direction == ScrollDirection.idle) direction.value = 0;
      // direction.value = notification.direction.index;
      direction.value = notification.direction.index;
      if (notification.direction == ScrollDirection.idle) {

        // _scrollEnd(notification.metrics);
        // if ([0.0, 1.0].contains(percentageShrink)) {
        //   return;
        // }

        // final offset = percentageShrink.round() == 1? -_delta: height - _delta;

        // controller.animateTo(
        //   controller.offset + offset,
        //   duration: Duration(milliseconds: 200),
        //   curve: Curves.linear,
        // );
      }
    }
    // if (notification is ScrollStartNotification) {}
    if (notification is ScrollUpdateNotification) {
      // if (notification.depth > 0)
      // print(notification.depth);
      if (enableNotify.value) _scrollUpdate(notification.metrics);
    }
    if (notification is ScrollEndNotification) _scrollEnd(notification.metrics);
  }

  void _scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
    if (pixels < 0.0) return;
    // if ([0.0, 1.0].contains(heightNotify.value)) return;
    if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    double maxExtent = scroll.maxScrollExtent, limit = maxExtent - height;
    if (pixels >= limit ){
      if (_delta > 0.0 ) {
        _offsetOld = pixels;
        final _deltaBottom = scroll.extentAfter.clamp(0.0, height);
        _delta = min(_delta,_deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offsetOld).clamp(0.0, height);
      _offsetOld = pixels;
    }
    // if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    heightNotify.value = percentageShrink;
  }

  /*
  void _listener() {
      _scrollListener(controller.position);
  }

  void _scrollListener(ScrollPosition position) {

    double pixels = position.pixels;
    // double _atTop = position.extentBefore;
    double _atBottom = position.extentAfter;
    // double _sizeHeight = position.extentInside;
    /*
    _delta = (_delta + pixels - _offsetOld).clamp(0.0, height);
    _offsetOld = pixels;
    if (position.axisDirection == AxisDirection.down && position.extentAfter == 0.0) {
      if (heightNotify.value == 0.0) return;
      heightNotify.value = 0.0;
      return;
    }
    if (position.axisDirection == AxisDirection.up && position.extentBefore == 0.0) {
      if (heightNotify.value == 1.0) return;
      heightNotify.value = 1.0;
      return;
    }
    if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    heightNotify.value = percentageShrink;
    */
    /*
    _delta += (pixels - _offsetOld);
    if (_delta > 0.0){
      _delta = height;
    } else if (_delta < 0.0) {
      _delta = 0.0;
    }
    _offsetOld = pixels;
    double _test;
    double maxExtent = position.maxScrollExtent, limit = maxExtent - height;
    double minExtent = position.minScrollExtent;
    if (pixels >= limit ){
      _delta = max(-(pixels - maxExtent),-_delta);
      _test = -_delta;
    } else if (pixels <= minExtent ) {
      _test = 0.0;
    } else {
      _test = -_delta;
    }
    */
    // _delta = (_delta + pixels - _offsetOld).clamp(0.0, height);

    double maxExtent = position.maxScrollExtent, limit = maxExtent - height;
    // double minExtent = position.minScrollExtent;
    if (pixels >= limit ){
      if (_delta > 0.0 ) {
        // _delta = (pixels - _offsetOld).clamp(0.0, height);
        _offsetOld = pixels;
        final _deltaBottom = _atBottom.clamp(0.0, height);
        _delta = min(_delta,_deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offsetOld).clamp(0.0, height);
      _offsetOld = pixels;
      // if (position.axisDirection == AxisDirection.down && position.extentAfter == 0.0) {
      //   if (heightNotify.value == 0.0) return;
      //   heightNotify.value = 0.0;
      //   return;
      // }
      // if (position.axisDirection == AxisDirection.up && position.extentBefore == 0.0) {
      //   if (heightNotify.value == 1.0) return;
      //   heightNotify.value = 1.0;
      //   return;
      // }
    }
    if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    heightNotify.value = percentageShrink;
  }
  */
  void _scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    if (_delta == 0.0 || _delta == height) return;

    if ([0.0, 1.0].contains(percentageShrink)) return;

    _delta = percentageShrink.round() == 1? 0.0:height;
    heightNotify.value = percentageShrink;
  }

  void dispose() {
    controller.dispose();
    direction.dispose();
    heightNotify.dispose();
  }
}

extension ScrollControllerExtension on ScrollController {
  static final _master = ScrollController();
  // static final _bar = <int, _ScrollBarControllerExtends>{};
  static final _bottom = <int, _ScrollBottomControllerExtends>{};

  static final _scrollNotification = ValueNotifier<ScrollNotification>(null);
  ValueNotifier<ScrollNotification> get notification => _scrollNotification;

  void scrollNotification(Function(ScrollNotification) listener) {
    _scrollNotification.addListener(() => listener(_scrollNotification.value));
  }

  ScrollController get master => _master;
  // ScrollController get master => ScrollController();

  // _ScrollBarControllerExtends get bar {
  //   if (_bar.containsKey(this.hashCode)) {
  //     return _bar[this.hashCode];
  //   }
  //   return _bar[this.hashCode] = _ScrollBarControllerExtends(this);
  // }

  _ScrollBottomControllerExtends get bottom {
    if (_bottom.containsKey(this.hashCode)) {
      return _bottom[this.hashCode];
    }
    return _bottom[this.hashCode] = _ScrollBottomControllerExtends(this);
  }
}

class _ScrollBottomControllerExtends extends ScrollPageController {
  _ScrollBottomControllerExtends(ScrollController scrollController)
      : assert(scrollController != null),
        super(scrollController);

  @override
  double height = kBottomNavigationBarHeight;

  /// Notifier of the active page index
  final pageNotify = ValueNotifier<int>(0);

  final toggleNotify = ValueNotifier<bool>(false);

  /// true is hide
  void toggle(bool status) => toggleNotify.value = status;

  /// Register a closure to be called when the tab changes
  void pageListener(Function(int) listener) {
    pageNotify.addListener(() => listener(pageNotify.value));
  }

  /// Set current page index
  void pageChange(int index) => pageNotify.value = index;

  @override
  void dispose() {
    pageNotify.dispose();
    toggleNotify.dispose();
    super.dispose();
  }
}

// class _ScrollBarControllerExtends extends ScrollPageController {
//   _ScrollBarControllerExtends(ScrollController scrollController)
//       : assert(scrollController != null),
//         super(scrollController);

//   @override
//   double height = kToolbarHeight + (kIsWeb ? 0.0 : Platform.isAndroid ? 24.0 : 0.0);
// }
