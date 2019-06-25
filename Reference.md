LayoutBuilder
```dart
return LayoutBuilder(
  builder: (context, constraints) {
    return Stack();
  }
);
```

## Navigator -> MaterialPageRoute
```dart
Navigator.push(context, MaterialPageRoute(builder: (context) {
  return Scaffold(
    appBar: AppBar(title: Text(tag)),
    body: Text('body')
  );
}));
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
/*
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
*/

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

 // _showBottomSheet(BuildContext context) {
  //   showBottomSheet<void>(context: context, builder:_bottomSheetBuilder).closed.whenComplete(() {
  //     if (mounted) {
  //       setState(() {
  //       });
  //     }
  //   });
  // }
  // Widget _bottomSheetBuilder() {
  //   return Container(
  //       height: 300.0,
  //       width: 300,
  //       color: Colors.red,
  //       child: Text('done'),
  //     );
  // }

    // scaffoldKey.currentState.setState((){
    //   store.bottomSheetShow = true;
    // });
    // bottomSheet
    // setState((){
    //   store.bottomSheetShow = true;
    // });
    // scaffoldKey.currentState.s
    // print('Open showSheetInfo');
    // widget.scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() {});
    // widget.scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() {});
    // scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() {
    //   setState((){
    //     store.bottomSheetShow = false;
    //   });
    // });

    // scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book));
    // showBottomSheet(context: context, builder:(BuildContext context) => SheetInfo(book)).closed.whenComplete(() {
    //   setState((){
    //     store.bottomSheetShow = false;
    //   });
    // });
    // Scaffold.of(context).showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() {
    //   setState((){
    //     store.bottomSheetShow = false;
    //   });
    // });
    // bottomSheet.close()
    // bottomSheet.closed.whenComplete(() => setState(() {
    //   print('Close showSheetInfo');
    // }));
    // widget.bottomSheet();

Widget titleContainer({Alignment alignment,double width,String title,Function onPress, BorderRadius borderRadius}){
      return Container(
        alignment: alignment,
        constraints: BoxConstraints(maxWidth: width,minWidth: 60.0),
        child: CupertinoButton(
          color: Colors.grey[200].withOpacity(shrink),
          minSize: 28,
          padding: EdgeInsets.symmetric(vertical:0, horizontal:10*shrink),
          borderRadius: borderRadius,
          child: Text(
            title,maxLines: 1,overflow: TextOverflow.clip, textScaleFactor: max(0.7, shrink),
            // textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.lerp(Colors.black87, Colors.black54, shrink), fontSize: 16
            )
          ),
          onPressed: onPress
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Align(
          widthFactor: 1,
          child: Opacity(
            opacity: 1,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 30,
              child:Icon(isChapterBookmarked?Icons.bookmark:Icons.bookmark_border,color:isChapterBookmarked?Colors.red:Colors.grey[300],size: (10*shrink)+20),
              onPressed: () {
                store.addCollectionBookmark().then((e){
                  setState((){});
                });
              }
            )
          )
        ),
        titleContainer(
          alignment: Alignment.centerRight,
          width: (width-30),
          title: activeName.bookName,
          onPress: ()=>booksPopup(shrink),
          borderRadius: new BorderRadius.horizontal(left:Radius.circular(30))
        ),
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth:shrink),
          child:Opacity(
            opacity: stretch,
            child:  Text(',',style: TextStyle(color: Colors.grey))
          )
        ),
        titleContainer(
          alignment: Alignment.centerLeft,
          width: 69,
          title: store.digit(store.chapterId),
          onPress: ()=>chapterPopup(shrink),
          borderRadius: new BorderRadius.horizontal(right:Radius.circular(30))
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: width-70,
          ),
          child: new ButtonTheme(
            padding: EdgeInsets.zero,
            child: new ButtonBar(
              // alignment: MainAxisAlignment.center,
              children: <Widget>[
                // Align(
                //   widthFactor: shrink,
                //   child: Opacity(
                //     opacity: shrink,
                //     child: CupertinoButton(
                //       padding: EdgeInsets.zero,
                //       minSize: 30,
                //       child:Icon(CupertinoIcons.info,color:Colors.grey,size: (8*shrink)+15),
                //       onPressed: () {
                //         print('info');
                //       }
                //     )
                //   )
                // ),
                // Align(
                //   widthFactor: shrink,
                //   child: Opacity(
                //     opacity: shrink,
                //     child: CupertinoButton(
                //       padding: EdgeInsets.zero,
                //       minSize: 30,
                //       child:Icon(CupertinoIcons.search,color:Colors.grey,size: (8*shrink)+15),
                //       onPressed: () {
                //         print('search');
                //       }
                //     )
                //   )
                // ),
                // Align(
                //   widthFactor: shrink,
                //   child: Opacity(
                //     opacity: shrink,
                //     child: CupertinoButton(
                //       padding: EdgeInsets.zero,
                //       minSize: 30,
                //       child:Icon(Icons.format_size,color:Colors.grey,size: (8*shrink)+15),
                //       onPressed: () => optionPopup(shrink)
                //     )
                //   )
                // )
              ]
            )
          )
        )
      ]
    );