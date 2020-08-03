import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class WidgetSheet extends StatelessWidget {
  final Widget child;
  WidgetSheet({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 10),
      // margin: EdgeInsets.symmetric(horizontal:20),
      // padding: EdgeInsets.symmetric(vertical:20),
      // padding: EdgeInsets.only(top: 0.5),
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Container(
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
        // child: new SizedBox.shrink(
        //   child: this.child
        // ),
        child: new SizedBox.expand(
          child: this.child
        ),
        // child: this.child
      )
    );
  }
}