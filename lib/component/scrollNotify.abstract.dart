/*
version: 0.3
developer: Khen Solomon Lethil
Feature
- pin
- at top
- at bottom
- offset
*/
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class ScrollNotify {

  final ValueNotifier<double> bottomPercentageNotify = ValueNotifier<double>(0.0);
  final ValueNotifier<int> directionNotify = ValueNotifier<int>(0);
  /// NOTE: double Value; start from MAX [0.0] to MIN [-bottomBarHeight]
  final ValueNotifier<double> bottomPositionNotify = ValueNotifier<double>(0.0);

  double _delta = 0.0, _offsetOld = 0.0, _offsetMin = 0.0;

  ScrollNotify get scrollNotify => this;

  double get bottomBarHeight => kBottomNavigationBarHeight;

  // NOTE: double Value; start from MIN: [0.0] to MAX: [1.0]
  double get _bottomPercentage => (_delta / bottomBarHeight).toDouble();

  // NOTE: double Value; start from MAX: [1.0] to MIN: [0.0]
  double get _shrink => (1.0 - _bottomPercentage).toDouble();

  // NOTE: Stretch in pixel;
  // double get _bottomPosition => (bottomBarHeight * _bottomPercentage).toDouble();
  // NOTE: Shrink in pixel;
  double get _bottomPosition => ((bottomBarHeight * _shrink) - bottomBarHeight).toDouble();

  bool _scrollNotification (ScrollNotification notification){

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.forward) {
        // NOTE: down
        directionNotify.value = 2;
      }
      if (notification.direction == ScrollDirection.reverse) {
        // NOTE: up
        directionNotify.value = 1;
      }
      if (notification.direction == ScrollDirection.idle) {
        directionNotify.value = 0;
      }
    }
    // if (notification is ScrollStartNotification) {}
    // if (notification is ScrollStartNotification) {}
    if (notification is ScrollUpdateNotification) {
      if (notification.depth > 0) _scrollUpdate(notification.metrics);
    }
    if (notification is ScrollEndNotification) {
      _scrollEnd(notification.metrics);
    }
    // if (notification is OverscrollNotification) {}
    return false;
  }

  void _scrollUpdate(ScrollMetrics scroll) {
    double _atTop = scroll.extentBefore;
    double _atBottom = scroll.extentAfter;
    double _sizeHeight = scroll.extentInside;
    /// NOTE: do skip for bouncing and random numbers in scroll.pixel sequence, eg. 0.2 0.3 [1.0] 0.4
    if ((_atTop + _atBottom) < _sizeHeight) return;
    if (_atTop == _offsetMin) return;
    // if (_atBottom == _offsetMin) return;

    double _pixel = scroll.pixels;
    _delta = (_delta + _pixel - _offsetOld).clamp(_offsetMin, bottomBarHeight);
    _offsetOld = _pixel;
    if (directionNotify.value == 1 || directionNotify.value == 0){
      final _deltaBottom = (_atBottom - 1.0).clamp(_offsetMin, bottomBarHeight);
      _delta = min(_delta,_deltaBottom);
    }
    bottomPositionNotify.value = _bottomPosition;
    bottomPercentageNotify.value = _bottomPercentage;
  }

  void _scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    if (_delta == _offsetMin || _delta == bottomBarHeight) return;

    if (directionNotify.value == 2){
      _delta = 0.0;
    } else if (directionNotify.value == 1){
      if (scroll.extentAfter < bottomBarHeight) {
        _delta = 0.0;
      } else {
        _delta = bottomBarHeight;
      }
    }

    bottomPositionNotify.value = _bottomPosition;
    bottomPercentageNotify.value = _bottomPercentage;
  }

  Widget scrollMain({Key key,Widget child}) {
    return NotificationListener<ScrollNotification>(
      key:key,
      onNotification: _scrollNotification,
      child: child,
    );
  }

  ValueListenableBuilder<double> bottomPercentageListener({Widget Function(BuildContext, double, Widget) builder}){
    return ValueListenableBuilder<double>(
      valueListenable: bottomPercentageNotify,
      builder: builder,
    );
  }

  // ValueListenableBuilder<double> bottomPositionListener({Widget Function(BuildContext, double, Widget) builder}){
  //   return ValueListenableBuilder<double>(
  //     valueListenable: bottomPositionNotify,
  //     builder: builder,
  //   );
  // }

  ValueListenableBuilder<double> bottomPositionListener({Widget Function(BuildContext, double, Widget) builder, bool disable}){
    return ValueListenableBuilder<double>(
      valueListenable: bottomPositionNotify,
      builder: builder,
    );
  }

  ///Notify of the active page index
  final pageNotify = ValueNotifier<int>(0);

  /// Register a closure to be called when the page changes
  // void pageListener(Function(int) listener) {
  //   pageNotify.addListener(() => listener(pageNotify.value));
  // }

  /// Set a new page pageChange
  ///
  void pageChange(int index) => pageNotify.value = index;

  // Widget _listener(){
  //   return bottomPositionListener(
  //     builder: (BuildContext context, double value, Widget child) {}
  //   );
  // }
}
