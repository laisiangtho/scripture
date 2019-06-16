```dart
return LayoutBuilder(
  builder: (context, constraints) {
    return Stack();
  }
);
```
// button.add(
//   new InkWell(
//     splashColor: Colors.transparent,
//     highlightColor: Colors.transparent,
//     child: AnimatedContainer(
//       constraints: BoxConstraints(
//         maxWidth: width,
//         minWidth: width-7,
//         minHeight: double.infinity
//       ),
//       margin: EdgeInsets.symmetric(vertical: 7,horizontal: 2),
//       decoration: BoxDecoration(
//       ),
//       duration: widget.animationDuration,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(item.icon,color: isSelectedButton? Colors.black:Colors.black38,size: 20,),
//         ]
//       )
//     ),
//     onTap: ()=>widget.tap(i)
//   )
// );

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