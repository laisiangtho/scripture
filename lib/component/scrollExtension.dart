/*
version: 0.1
developer: Khen Solomon Lethil
*/
import 'dart:math';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


// class ScrollPageOffset {
//   static final ScrollPageOffset _instance = new ScrollPageOffset.internal();
//   factory ScrollPageOffset() => _instance;
//   ScrollPageOffset.internal();
// }

abstract class ScrollPageController {

  ScrollPageController(this.controller)
  : assert(controller != null) {
    // controller.addListener(_listener);
    controller.scrollNotification(_scrollNotification);
  }

  ScrollController controller;
  // get scrollNotification;
  // scrollNotification(_scrollNotification);

  /// Notification
  // ScrollNotification get notification;

  /// Height of the bar
  double get height;
  // get scrollNotification;

  // ScrollNotification get notification;

  /// Notifier of the visible height factor of bar
  double _delta = 0.0, _offsetOld = 0.0; //_minOffset=0.0, _maxOffset=1.0;
  final heightNotify = ValueNotifier<double>(1.0);
  final direction = ValueNotifier<int>(0);

  /// Notifier of the pin state changes
  final pinNotify = ValueNotifier<bool>(false);


  // void showToggle(bool status) => heightNotify.value = status?0.0:1.0;

  double get percentage => (_delta / height).toDouble();
  double get heightFactor => (1.0 - percentage).toDouble();

  void _scrollNotification(ScrollNotification notification) {
    if (notification == null) return;
    if (notification is UserScrollNotification) {
      // NOTE: down
      // if (notification.direction == ScrollDirection.forward) direction.value = 2;
      // NOTE: up
      // if (notification.direction == ScrollDirection.reverse) direction.value = 1;
      // if (notification.direction == ScrollDirection.idle) direction.value = 0;
      // direction.value = notification.direction.index;
      direction.value = notification.direction.index;
      // print(notification.direction);
      if (notification.direction == ScrollDirection.idle) {

        // _scrollEnd(notification.metrics);
        // if ([0.0, 1.0].contains(heightFactor)) {
        //   return;
        // }

        // final offset = heightFactor.round() == 1? -_delta: height - _delta;

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
      _scrollUpdate(notification.metrics);
    }
    if (notification is ScrollEndNotification)  _scrollEnd(notification.metrics);

  }


  // void _listener() {
  //     _scrollListener(controller.position);
  // }

  void _scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
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
    if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    heightNotify.value = heightFactor;
  }
  /*
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
    heightNotify.value = heightFactor;
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
        print('? $_delta');
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
    heightNotify.value = heightFactor;
  }
  */
  void _scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    // print('?end');
    if (_delta == 0.0 || _delta == height) return;
    // print('?2');

    if ([0.0, 1.0].contains(heightFactor)) return;
    // print('?3');

    // if (direction.value == 2){
    //   _delta = 0.0;
    // } else {
    //   // if (_delta ) {
    //   //   _delta = 0.0;
    //   // } else {
    //   //   _delta = height;
    //   // }
    // }
    _delta = heightFactor.round() == 1? 0.0:height;
    // print(_delta);
    // _delta = height;
    heightNotify.value = heightFactor;
  }

  void dispose() {
    controller.dispose();
    direction.dispose();
    heightNotify.dispose();
    pinNotify.dispose();
  }

}

extension ScrollControllerExtension on ScrollController {
  static final _master = ScrollController();
  // static final _masterOffset = <int, double>{};
  // static final _master = <int, ScrollController>{};
  // static final _bar = <int, _ScrollBarControllerExtends>{};
  static final _bottom = <int, _ScrollBottomControllerExtends>{};


  // double get initialScrollOffset => notification.value?.metrics?.pixels??0.0;

  static final _scrollNotification = ValueNotifier<ScrollNotification>(null);
  ValueNotifier<ScrollNotification> get notification => _scrollNotification;
  void scrollNotification(Function(ScrollNotification) listener) {
    _scrollNotification.addListener(() => listener(_scrollNotification.value));
  }

  ScrollController get master => _master;
  // ScrollController get master => ScrollController();

  // ScrollController get master {
  //   print(this.hashCode);
  //   if (_master.containsKey(this.hashCode)) {
  //     return _master[this.hashCode];
  //   }
  //   // return _master[this.hashCode] = ScrollController(keepScrollOffset:true,initialScrollOffset:initialScrollOffset);
  //   // double offset = _masterOffset.containsKey(this.hashCode)?_masterOffset[this.hashCode]:0.0;
  //   // print(offset);
  //   return _master[this.hashCode] = ScrollController(keepScrollOffset:true,initialScrollOffset:initialScrollOffset);
  // }
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


  // ScrollNotification get notification => controller.notification.value;
  // ScrollNotification scrollNotification => controller.notification.value;

  // @override
  // void scrollNotification(Function(ScrollNotification) listener) {
  //   controller.notification.addListener(() => listener(controller.notification.value));
  // }

  /// Notifier of the active page index
  final pageNotify = ValueNotifier<int>(0);

  final toggleNotify = ValueNotifier<bool>(false);

  /// true is hide
  void toggle(bool status) => toggleNotify.value = status;

  /// Register a closure to be called when the tab changes
  void pageListener(Function(int) listener) {
    pageNotify.addListener(() => listener(pageNotify.value));
  }

  /// Set a new tab
  void pageChange(int index) => pageNotify.value = index;

  @override
  void dispose() {
    pageNotify.dispose();
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
