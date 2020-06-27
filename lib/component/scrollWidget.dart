import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
import 'scrollExtension.dart';

class ScrollPage extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final bool self;

  ScrollPage({
    Key key,
    // this.controller,
    this.controller,
    this.self:false,
    @required this.child,
  }) :
  assert(child != null),
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _Behavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: _notification,
        child: child,
      )
   );
  }

  bool _notification(ScrollNotification notification) {
    if (controller != null) controller.notification.value = notification;
    return false;
  }
}

class _Behavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}
