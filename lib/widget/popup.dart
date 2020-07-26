import 'package:flutter/material.dart';

/*
showDialog(
  context: context,
  builder: (_) => WidgetPopup(),
);

Navigator.of(context).push(PageRouteBuilder(
  opaque: false,
  barrierDismissible: true,
  pageBuilder: (BuildContext context, _, __) => WidgetPopup()
));
*/

class WidgetPopup extends StatelessWidget {
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

  WidgetPopup(
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

  @override
  Widget build(BuildContext context) {
    double maxHeight = 0.7*MediaQuery.of(context).size.height;
    double fixedHeight = this.height > maxHeight?maxHeight:this.height;
    // double fixedArrow = (this.arrow-(this.arrow*this.offsetPersentage)+this.arrow);
    // double fixedArrowWidth = math.min(97,fixedArrow);
    return Stack(
      // overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          // top: math.max(43,(this.top*this.offsetPersentage)),
          top: this.top,
          right: this.right,
          bottom: this.bottom,
          left: this.left,
          child: Material(
            shape: ShapedArrow(arrow:this.arrow, borderRadius: BorderRadius.all( Radius.elliptical(3,3)), padding: this.padding),
            clipBehavior: Clip.antiAlias,
            elevation:0,
            color: this.backgroundColor,
            // shadowColor: Colors.black,
            child: Container(
              // padding: EdgeInsets.all(this.padding).copyWith(bottom:this.padding * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all( Radius.elliptical(3,3)),
                boxShadow: [
                  BoxShadow(
                    blurRadius:10.0,
                    color: Colors.white12,
                    // color: Theme.of(context).backgroundColor,
                    // color: this.backgroundColor,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 2.4),
                  )
                ]
              ),
              child: SizedBox(
                width: this.width,
                height: fixedHeight,
                child: this.child
              )
            )
          )
          // child: ClipPath(
          //   clipBehavior: Clip.hardEdge,
          //   clipper: ClipperArrow(), // class code shown below
          //   child: Material(
          //     shadowColor: Colors.black38,
          //     elevation: 5,
          //     child: SizedBox(
          //       width: this.width,
          //       height: fixedHeight,
          //       child: this.child
          //     )
          //   )
          // )
          // child: Container(
          //   decoration: ShapeDecoration(
          //     // shape: RoundedRectangleBorder(
          //     //   borderRadius: BorderRadius.all(Radius.circular(3)),
          //     //   side: BorderSide(color: Colors.grey[300]),
          //     // ),
          //     color: this.backgroundColor,
          //     shape:ShapedArrow(
          //       arrow:this.arrow,
          //       borderRadius: BorderRadius.all( Radius.circular(3)),
          //       side: BorderSide(color:this.backgroundColor),
          //       padding: this.padding
          //     ),
          //     shadows: [
          //       const BoxShadow(
          //         color: Colors.grey,
          //         blurRadius: 1,
          //         offset: Offset(0.0, 1.0),
          //       )
          //     ],
          //   ),
          //   child: Material(
          //     // shadowColor: Colors.black38,
          //     // shape: ShapedArrow(arrow:this.arrow, borderRadius: BorderRadius.all( Radius.elliptical(3,3)), padding: this.padding),
          //     // clipBehavior: Clip.antiAlias,
          //     elevation: 0,
          //     color: this.backgroundColor,
          //     child: SizedBox(
          //       width: this.width,
          //       height: fixedHeight,
          //       child: this.child
          //     )
          //   )
          // )
        )
      ]
    );
  }
}

class ClipperArrow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, 0);
    path.lineTo(20, 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ShapedArrow extends RoundedRectangleBorder {
  ShapedArrow({
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
class WidgetPopupShaped extends StatelessWidget {
  WidgetPopupShaped({this.child, this.backgroundColor:Colors.white,this.height=250, this.width=180,this.arrow=10});
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
        // shape: WidgetPopupShapedArrow(arrow:arrow, borderRadius: BorderRadius.vertical(top: Radius.circular(50)), padding: padding),
        shape: WidgetPopupShapedArrow(arrow:arrow, borderRadius: BorderRadius.all( Radius.circular(2)), padding: padding),
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