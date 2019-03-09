import 'package:flutter/material.dart';

class ShapedChapterList extends StatelessWidget {
  ShapedChapterList({this.child, this.height=250, this.width=180});
  final Widget child;
  final double padding = 2;
  final double width;
  final double height;
  // final double maxHeight;

  @override
  Widget build(BuildContext context) {
    // 150/5*40
    double maxHeight = MediaQuery.of(context).size.height/1.2;
    double adjectedHeight = height > maxHeight?maxHeight:null;
    return Container(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(2)),
        // color: Colors.grey,
        // color: Theme.of(context).backgroundColor,
        border: Border.all(color: Colors.grey,style: BorderStyle.none),
        boxShadow: [
          new BoxShadow(color: Colors.grey[400], offset: Offset(0, -1),spreadRadius: 0,blurRadius: 15)
        ]
      ),
      child: Material(
        // clipBehavior: Clip.hardEdge,
        shape: _ShapedWidgetBorder(borderRadius: BorderRadius.all(Radius.circular(2)), padding: padding),
        // borderRadius: BorderRadius.all(Radius.circular(2)),
        // elevation: 0,

        // shadowColor: Colors.red,
        // color: Colors.white,
        color: Theme.of(context).backgroundColor,
        // color: Colors.grey[400],
        child: Container(

          padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
          // padding: EdgeInsets.all(2),
          margin: EdgeInsets.all(0),
          // color: Colors.white,
          child: SizedBox(
            width: width,
            height: adjectedHeight,
            child: SingleChildScrollView(
              child: child
            )
          )
        )
      ),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.width - 20.0 , rect.top)
      ..lineTo(rect.width - 30.0, rect.top - 10.0)
      ..lineTo(rect.width - 40.0, rect.top)
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
  }
}



// class CliperWidget extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     // TODO: implement getClip
//     return null;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return null;
//   }
// }