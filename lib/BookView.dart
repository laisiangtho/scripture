import 'package:flutter/material.dart';
import 'package:laisiangtho/Book.dart';
import 'package:laisiangtho/WidgetCommon.dart';
// import 'dart:math' as math;

class BookView extends BookState {

  Widget _availableButtonWidget() {
    return new IconButton(
      icon: isLoading?SizedBox(width:13, height:13,
        child:CircularProgressIndicator(strokeWidth: 1)
      ):new Icon(this.isAvailable?Icons.delete:Icons.cloud_download),
      // icon: new Icon(Icons.keyboard_capslock),
      color: this.isAvailable?Colors.red:Colors.blueAccent,
      iconSize: 15,
      // onPressed: isLoading?null:availableButtonAction
      onPressed: availableButtonCallBack
    );
  }

  Widget _readButtonWidget() {
    return new RaisedButton.icon(
      // icon: Container(
      //   // padding: EdgeInsets.all(5),
      //   decoration: new BoxDecoration(
      //     // borderRadius: BorderRadius.all(Radius.circular(30)),
      //     // color: Colors.grey[200],
      //     // boxShadow: [
      //     //   new BoxShadow(
      //     //     color: Colors.grey,
      //     //     offset: Offset(-2, 0),
      //     //     spreadRadius: 0.2,
      //     //     blurRadius: 0.7,
      //     //   ),
      //     // ]
      //   ),
      //   child: new Icon(this.isAvailable?Icons.check:Icons.more_horiz)
      // ),
      icon:new Icon(this.isAvailable?Icons.check:Icons.more_horiz),
      elevation: 0,
      color: this.isAvailable?Colors.blue:Colors.grey,
      textColor: Colors.white,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      // label: Text(widget.bible.shortname),
      label: Text(bible.shortname,style: TextStyle(fontWeight: FontWeight.normal)),
      onPressed: null
    );
    // return new InkWell(
    //   child: new Container(
    //     width: 100.0,
    //     height: 50.0,
    //     decoration: new BoxDecoration(
    //       color: Colors.blueAccent,
    //       border: new Border.all(color: Colors.white, width: 2.0),
    //       borderRadius: new BorderRadius.circular(10.0),
    //     ),
    //     child: new Center(child: new Text('read'),),
    //   ),
    //   onTap: () {},
    // );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: store.bookList,
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            booksGenerate(e);
            return _buildBody();
          } else if (e.hasError) {
            return WidgetError(message: e.error);
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  Widget _buildBody() {
    // print(bible.name);
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        SliverAppBar(
          // backgroundColor: Theme.of(context).backgroundColor,
          pinned: true,
          elevation: 0,
          expandedHeight: 100.0,
          titleSpacing: 0,
          title: Text(bible.name,style: TextStyle(
              color: Colors.grey, fontSize: 17, fontFamily: 'Myanmar3', height: 1.2,
              shadows: <Shadow>[
                Shadow(offset: Offset(0, 1),blurRadius:15,color: Colors.white)
              ]
            )
          ),
          flexibleSpace: FlexibleSpaceBar(
            // title: ?,
            background:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 3),
                  padding: new EdgeInsets.symmetric( vertical: 3, horizontal: 10),
                  // alignment: Alignment.topCenter,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey[350]
                  ),
                  child: Text('${bible.year}',
                    style: TextStyle(fontSize: 14,color: Colors.white)
                  )
                ),
                Container(
                  // margin: new EdgeInsets.all(3),
                  padding: new EdgeInsets.symmetric( vertical: 3, horizontal: 10),
                  // alignment: Alignment.topCenter,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.amberAccent
                  ),
                  child: Text('${bible.lang}'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                    )
                  )
                )
              ],
            )
          ),
          leading: IconButton(
            // iconSize: 2,
            icon: new Icon(Icons.arrow_back_ios),
            color: Colors.grey,
            onPressed: ()=>Navigator.of(context).pop(null),
          ),
          actions: <Widget>[_availableButtonWidget()],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              children: <Widget>[_readButtonWidget()]
            ),
            _descriptionWidget()
          ]),
        )
      ],
    );
  }


  Widget _descriptionWidget() {
    return Container(
      margin: new EdgeInsets.all(50),
      padding: new EdgeInsets.all(20),
      // color: Theme.of(context).backgroundColor,
      alignment: Alignment.topCenter,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        boxShadow: [
          new BoxShadow(color: Colors.grey[300],offset: Offset(0, -2),spreadRadius: 1,blurRadius: 2)
        ]
      ),
      child: Text(bible.desc == null?'...${bible.name}':bible.desc, textAlign: TextAlign.center)
    );
  }
}

  // SliverPersistentHeader makeHeader(String headerText) {
  //   return SliverPersistentHeader(
  //     pinned: false,
  //     // floating: true,

  //     delegate: _SliverAppBarDelegate(
  //       minHeight: 30.0,
  //       maxHeight: 50.0,

  //       child: Container(
  //           color: Colors.lightBlue, child: Center(child:
  //               Text(headerText))),
  //     ),
  //   );
  // }

//         makeHeader('Header Section 1'),
//         SliverGrid.count(
//           crossAxisCount: 3,
//           children: [
//             Container(color: Colors.red, height: 150.0),
//             Container(color: Colors.purple, height: 150.0),
//             Container(color: Colors.green, height: 150.0),
//             Container(color: Colors.orange, height: 150.0),
//             Container(color: Colors.yellow, height: 150.0),
//             Container(color: Colors.pink, height: 150.0),
//             Container(color: Colors.cyan, height: 150.0),
//             Container(color: Colors.indigo, height: 150.0),
//             Container(color: Colors.blue, height: 150.0),
//           ],
//         ),
//         makeHeader('Header Section 2'),
        // SliverFixedExtentList(
        //   itemExtent: 150.0,
        //   delegate: SliverChildListDelegate(
        //     [
        //       Container(color: Colors.red),
        //       Container(color: Colors.purple),
        //       Container(color: Colors.green),
        //       Container(color: Colors.orange),
        //       Container(color: Colors.yellow),
        //     ],
        //   ),
        // ),
//         makeHeader('Header Section 3'),

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     @required this.minHeight,
//     @required this.maxHeight,
//     @required this.child,
//   });
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//   @override
//   double get minExtent => minHeight;
//   @override
//   double get maxExtent => math.max(maxHeight, minHeight);
//   @override
//   Widget build(
//       BuildContext context,
//       double shrinkOffset,
//       bool overlapsContent
//   )
//   {
//     return new SizedBox.expand(child: child);
//   }
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }