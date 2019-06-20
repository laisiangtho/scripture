import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'WidgetShaped.dart';
// import 'dart:math' as math;

/*
showDialog(
  context: context,
  builder: (_) => Popup(),
);

Navigator.of(context).push(PageRouteBuilder(
  opaque: false,
  barrierDismissible: true,
  pageBuilder: (BuildContext context, _, __) => Popup()
));
*/

class Popup extends StatefulWidget {
  Popup(
    {
      Key key,
      this.child,
      this.offsetPersentage:1.0,
      this.top:75,
      this.right,
      this.left,
      this.bottom,

      this.backgroundColor:Colors.grey,
      this.height:250,
      this.width:180,
      this.arrow:65,
      this.padding:2
    }
  ) : super(key: key);
  final Widget child;

  final double top;
  final double right;
  final double left;
  final double bottom;
  final double offsetPersentage;

  final double padding;
  final double width;
  final double height;
  final double arrow;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _PopupState();
}

class _PopupState extends State<Popup> with SingleTickerProviderStateMixin {
  // AnimationController controller;
  // Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    // controller.addListener(() {
    //   setState(() {});
    // });
    // controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    double maxHeight = 0.7*MediaQuery.of(context).size.height;
    double fixedHeight = widget.height > maxHeight?maxHeight:widget.height;
    // double fixedArrow = (widget.arrow-(widget.arrow*widget.offsetPersentage)+widget.arrow);
    // double fixedArrowWidth = math.min(97,fixedArrow);
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        Positioned(
          // top: math.max(43,(widget.top*widget.offsetPersentage)),
          top: widget.top,
          right: widget.right,
          bottom: widget.bottom,
          left: widget.left,
          child: Material(
            // shape: _ShapedArrow(arrow:widget.arrow, borderRadius: BorderRadius.all( Radius.elliptical(3,3)), padding: widget.padding),
            shape: _ShapedArrow(arrow:widget.arrow, borderRadius: BorderRadius.all( Radius.elliptical(3,3)), padding: widget.padding),
            clipBehavior: Clip.hardEdge,
            elevation:0,
            color: widget.backgroundColor,
            child: Container(
              // padding: EdgeInsets.all(widget.padding).copyWith(bottom:widget.padding * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all( Radius.elliptical(3,3))
              ),
              child: SizedBox(
                width: widget.width,
                height: fixedHeight,
                child: widget.child
              )
            )
          )
        )
      ]
    );
  }
}

class _ShapedArrow extends RoundedRectangleBorder {
  _ShapedArrow({
    @required this.padding,
    @required this.arrow,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;
  final double arrow;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(arrow , rect.top)
      ..lineTo(arrow + 8, rect.top - 4.0)
      ..lineTo(arrow + 15, rect.top)
      // ..moveTo(rect.width - 65.0 , rect.top)
      // ..lineTo(rect.width - 75.0, rect.top - 5.0)
      // ..lineTo(rect.width - 85.0, rect.top)
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
  }
}
/*
class PopupShaped extends StatelessWidget {
  PopupShaped({this.child, this.backgroundColor:Colors.white,this.height=250, this.width=180,this.arrow=10});
  final Widget child;
  final double padding = 2;
  final double width;
  final double height;
  final double arrow;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height/1.2;
    double adjectedHeight = height > maxHeight?maxHeight:null;
    return Container(
      child: Material(
        // shape: PopupShapedArrow(arrow:arrow, borderRadius: BorderRadius.vertical(top: Radius.circular(50)), padding: padding),
        shape: PopupShapedArrow(arrow:arrow, borderRadius: BorderRadius.all( Radius.circular(2)), padding: padding),
        elevation:0.5,
        // shadowColor: Colors.red,
        color: backgroundColor,
        child: Container(
          padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
          child: SizedBox(
            width: width,
            height: adjectedHeight,
            child: SingleChildScrollView(
              child: child
            )
          )
        )
      )
    );
  }
}
*/