import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

class WidgetSheet extends StatelessWidget {
  WidgetSheet(
    {
      this.child,
      Key key,
    }
  ) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {

    return Theme(
      key: key,
      // isMaterialAppTheme: true,
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Material(
        elevation:  0.3,
        // color: Theme.of(context).backgroundColor,
        color: Colors.grey,
        shadowColor: Colors.white,
        // borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        shape: new RoundedRectangleBorder(
          // side: BorderSide( color: Colors.grey, width:0.2),
          // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(10, 10))
          // borderRadius: BorderRadius.vertical(top: Radius.circular(7))
          borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3,2))
        ),
        child: this.child
      ),
    );

    // return ConstrainedBox(
    //   key: key,
    //   constraints: new BoxConstraints(
    //     minHeight: 35.0,
    //     minWidth: double.infinity
    //     // minWidth: MediaQuery.of(context).size.width
    //   ),
    //   child: Container(
    //     margin: EdgeInsets.symmetric(horizontal: 5),
    //     padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    //     decoration: const BoxDecoration(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
    //       color: Colors.grey,
    //       // shape: BoxShape.circle
    //       // shape: BoxShape.rectangle
    //     ),
    //     child: child
    //   )
    // );
    // return Material(
    //   elevation: 50,
    //   type: MaterialType.canvas,
    //   borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
    //   // color: Colors.grey,
    //   child:n1
    // );
  }
}

class WidgetLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1
      )
    );
  }
}

class WidgetError extends StatelessWidget {
  WidgetError({this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: new EdgeInsets.symmetric(horizontal:60),
        // padding: new EdgeInsets.all(25),
        // decoration: new BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(2)),
        //   color: Colors.white,
        //   boxShadow: [
        //     new BoxShadow(color: Colors.grey, offset: Offset(0, 1),spreadRadius: 0.2,blurRadius: 0.7)
        //   ]
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(this.message, textAlign: TextAlign.center,),
            Padding(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Icon(CupertinoIcons.ellipsis),
            ),
          ],
        )
      ),
    );
  }
}
class WidgetEmptyIdentify extends StatelessWidget {
  WidgetEmptyIdentify({this.atleast:'',this.enable:'Bible',this.task:'to',this.message:'read'});
  final String atleast;
  final String enable;
  final String task;
  final String message;
  @override
  // ...enable at least\na Bible to read
  // ...enable at least\na Bible to view bookmarks
  // ...search\na Word or two in verses!
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '...',
          style: Theme.of(context).textTheme.subhead.copyWith(fontFamily: 'Caveat',fontSize: 25,color: Colors.grey),
          children: <TextSpan>[
            TextSpan(text:this.atleast),
            TextSpan(text: ' '),
            TextSpan(
              text: this.enable,
              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 17),
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: this.task,
            ),
            TextSpan(text: '\n'),
            TextSpan(
              text: this.message,
              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.blue,fontSize: 30),
            ),
            TextSpan(
              text: '...',
            )
          ]
        )
      )
    );
  }
}

class WidgetBottomSheet extends StatelessWidget {
  WidgetBottomSheet({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation:  0.3,
      color: Colors.red,
      shadowColor: Colors.white,
      borderOnForeground: true,
      // clipBehavior: Clip.hardEdge,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: new RoundedRectangleBorder(
        // side: BorderSide( color: Colors.grey, width:0.2),
        // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(10, 10))
        // borderRadius: BorderRadius.vertical(top: Radius.circular(7))
        borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 7))
      ),
      child: this.child
    );

  }
}
// WidgetSliverHeader, WidgetBottomBar, WidgetHeaderSliver WidgetHeaderSliver, WidgetBottomNavigation
class WidgetHeaderSliver extends SliverPersistentHeaderDelegate {
  WidgetHeaderSliver(
    this.builder,
    {
      this.minHeight:35.0,
      this.maxHeight:50.0,
      this.color,
      this.elevation:0.35,
      this.statusBar:0
    }
  );
  final double minHeight;
  final double maxHeight;
  double statusBar;
  final Color color;
  final double elevation;


  double stretch = 0.0;
  double shrink = 1.0;
  Function builder;

  @override
  // double get minExtent => (minHeight + statusBar);
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;


  FloatingHeaderSnapConfiguration get snapConfiguration => null;


  @override
  Widget build(BuildContext context,double offset,bool overlaps) {
    // statusBar = MediaQuery.of(context).padding.top;
    double limitOffset = (maxExtent - minExtent);
    stretch= min(1,offset /limitOffset);
    shrink = max(0.0,(limitOffset - offset) / (limitOffset * 1.0));

    return Material(
      elevation: this.elevation,
      color: Theme.of(context).primaryColor,
      clipBehavior: Clip.hardEdge,
      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5,3))),
      // shape: BeveledRectangleBorder(
      //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(46.0)),
      // ),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(3, 3))),
      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 3))),
      child: new SizedBox.expand(
        child: Container(
          padding: new EdgeInsets.only(top: statusBar),
          child: builder(context,offset,overlaps,stretch,shrink)
        )
      )
    );
  }

  @override
  bool shouldRebuild(WidgetHeaderSliver oldDelegate) {
    return true;
  }
}

class WidgetBottomNavigation extends StatelessWidget {
  WidgetBottomNavigation(
    {
      this.child,
      this.color,
      this.elevation:2.30,
    }
  );
  final Color color;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation:  this.elevation,
      // color: this.color,
      // color: Theme.of(context).backgroundColor,
      color: Theme.of(context).primaryColor,
      shadowColor: Colors.black,
      // color: Colors.white,
      // clipBehavior: Clip.hardEdge,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: new RoundedRectangleBorder(
        // side: BorderSide( color: Colors.grey, width:0.2),
        // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(10, 10))
        // borderRadius: BorderRadius.vertical(top: Radius.circular(7))
        borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
      ),
      child: this.child
    );
  }
}

// class WidgetLauncher extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 1,
//         )
//       )
//     );
//   }
// }

/*
return Material(
      elevation: widget.elevation,
      color: Colors.white,
      shadowColor: Colors.white,

      borderOnForeground: true,
      // clipBehavior: Clip.hardEdge,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical(top: Radius.elliptical(10, 5))),
      shape: new RoundedRectangleBorder(
        // side: BorderSide( color: Colors.grey, width:0.2),
        // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(10, 10))
        borderRadius: BorderRadius.vertical(top: Radius.circular(7))
      ),
      // shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children()
      )
    );

Container(
  color: Theme.of(context).backgroundColor,
  child:  Center(
    child: CircularProgressIndicator(strokeWidth: 1,valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))
  )
)

ClipRRect(
  // borderRadius: BorderRadius.circular(40.0),
  // borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
  borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 5)),

  child: Container(
    // height: 800.0,
    width: double.infinity,
    // margin: EdgeInsets.only(top: 1),
    // margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
    // padding: EdgeInsets.only(top: 1),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 50)),
      // border: Border.all(color: Colors.blue),
      boxShadow: [
        new BoxShadow(color: Colors.grey, offset: Offset(0, -1),spreadRadius: 1,blurRadius:5)
      ]
    ),
    child:
  ),
);
*/