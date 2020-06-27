import 'package:flutter/material.dart';

class WidgetSheet extends StatelessWidget {
  WidgetSheet({this.child});
  final Widget child;

  // double get paddingBottom => Store().contextMedia.padding.bottom;
  // double get paddingBottom => MediaQuery.of(context).padding.bottom;

  @override
  Widget build(BuildContext context) {
    // return new Container(
    //   height: 200,
    //   decoration: new BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //       borderRadius: new BorderRadius.only(
    //         topLeft: const Radius.circular(3),
    //         topRight: const Radius.circular(3))
    //       ),
    //   child: this.child
    // );
    return Container(
      height: 220,
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        // color: Colors.black,
        borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 0.5),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 2))
        ),
        child: new SizedBox.expand(
          child: this.child
        )
      )
    );
  }
}