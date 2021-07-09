import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ViewHeaderDecoration extends StatelessWidget {
  ViewHeaderDecoration({
    Key? key,
    required this.child,
    // this.color,
    this.overlapsColor:false,
    required this.overlaps
  }): super(key: key);

  final Widget child;
  final bool overlaps;
  final bool overlapsColor;
  // final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        // color: color==null?Theme.of(context).scaffoldBackgroundColor:color,
        color: (overlaps && overlapsColor)?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).backgroundColor.withOpacity(overlaps?0.3:0.0),
            blurRadius: 0.0,
            spreadRadius: 0.1,
            offset: Offset(0, .1)
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: child
      )
    );
  }
}
