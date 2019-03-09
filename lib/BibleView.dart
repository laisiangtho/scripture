import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Bible.dart';
import 'package:laisiangtho/WidgetShaped.dart';
import 'package:laisiangtho/WidgetCommon.dart';
// import 'package:laisiangtho/BibleSearch.dart';
// import 'package:laisiangtho/BibleBarTitle.dart';
// import 'package:laisiangtho/BibleBarBackground.dart';
// import 'package:laisiangtho/BibleVerseReader.dart';

// RoundedRectangleBorder
// class _names extends CircleBorder {}
class _TestdWidgetBorder extends RoundedRectangleBorder {
  _TestdWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side);
  final double padding;

  @override
  // Path getOuterPath(Rect rect, {TextDirection textDirection}) {
  //   return Path()
  //     ..moveTo(rect.width - 20.0 , rect.top)
  //     ..lineTo(rect.width - 30.0, rect.top - 10.0)
  //     ..lineTo(rect.width - 40.0, rect.top)
  //     ..addRRect(borderRadius
  //         .resolve(textDirection)
  //         .toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
  // }

  // Path getOuterPath(Rect rect, {TextDirection textDirection}) {
  //     // var secondControlPoint = Offset(rect.width - (rect.width / 3.25), rect.height - 65);
  //     // var secondEndPoint = Offset(rect.width, rect.height - 40);
  //     var secondControlPoint = Offset(rect.width,50.0);
  //     var secondEndPoint = Offset(rect.width, 40);
  //   return Path()
  //     // ..moveTo(rect.width - 20.0 , rect.top)
  //     // ..lineTo(rect.width - 30.0, rect.top - 10.0)
  //     // ..lineTo(rect.width - 40.0, rect.top)
  //     // ..moveTo(rect.width + 15 - 20.0,rect.top)
  //     // ..lineTo(rect.width + 15, rect.top + 20.0)
  //     // ..lineTo(rect.width + 15, rect.top)
  //     // ..lineTo(rect.width- 50, rect.top)
  //     // ..lineTo(rect.width, rect.top)
  //     // ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
  //     // ..close()
  //     ..addRRect(borderRadius .resolve(textDirection).toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)))
  //     ..close();
  // }
  // NOTE circle curve with fixed margin 10 for left and right
  /*
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
      double wPa = 15.0;
      double wH = rect.width + wPa;
      var secondControlPoint = Offset(wH - 14,rect.top + 16);
      var secondEndPoint = Offset(wH, rect.top + 18);
    return Path()
      ..moveTo(wH, rect.top)
      ..lineTo(wH - 13, rect.top)
      ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
      ..addRRect(borderRadius .resolve(textDirection).toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height)))
      ..close();
  }
  */
  // NOTE arrow up
  /*
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.width - 20.0 , rect.top)
      ..lineTo(rect.width - 30.0, rect.top - 10.0)
      ..lineTo(rect.width - 40.0, rect.top)

      ..addRRect(borderRadius .resolve(textDirection).toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height)))
      ..close();
  }
  */
  // NOTE fold left
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
      double wPa = 30.0;
    return Path()
      ..moveTo(0, rect.top + wPa)
      ..lineTo(wPa, rect.top)
      ..lineTo(0, rect.top)

      ..addRRect(borderRadius .resolve(textDirection).toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height)))
      ..close();
  }
  /*
  Path getOuterPath(Rect size, {TextDirection textDirection}) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  */
}

// class _BottomWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = new Path();
//     path.lineTo(0.0, size.height - 20);

//     var firstControlPoint = Offset(size.width / 4, size.height);
//     var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);

//     var secondControlPoint =
//         Offset(size.width - (size.width / 3.25), size.height - 65);
//     var secondEndPoint = Offset(size.width, size.height - 40);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);

//     path.lineTo(size.width, size.height - 40);
//     path.lineTo(size.width, 0.0);

//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class BibleView extends BibleState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      // backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.white,
      // backgroundColor: Colors.grey[50],
      body: FutureBuilder(
        future: store.titleName,
        builder: (BuildContext context, AsyncSnapshot<ModelChapter> e) {
          if (e.hasData){
            infoGenerate(e);
            return _body();
          } else if (e.hasError) {
            return WidgetError(message: e.error);
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  Widget _body() {
    return new SafeArea(
      // top: false,
      // bottom: false,
      // minimum: const EdgeInsets.symmetric(vertical:50),
      child: Container(
        // color: Theme.of(context).backgroundColor,
        // child: new Column(
        //   mainAxisSize: MainAxisSize.max,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     _header(), _stack()
        //   ]
        // ),
        child: new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                // padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black,width: 0.1)),
                color: Colors.grey[50],
                  // boxShadow: [
                  //   new BoxShadow(color: Colors.grey[300], offset: Offset(0, -1),spreadRadius: 1,blurRadius: 2)
                  // ],

                ),
                child:  _header()
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              bottom: 0,
              // child:Center(
              //   child: ClipPath(
              //     child: Image.network('https://fd204d43461da5218393-0b3ca8ff9ad90f3780bc876f4d2d02ae.ssl.cf1.rackcdn.com/uploads/2018/07/AV_Landscape-Hero-Contour-2993-1276x800.jpg'),
              //     clipper: _BottomWaveClipper(),
              //   ),
              // ),

              child: Container(
                // alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 0, left: 27, right: 27,bottom:2),
                // padding: EdgeInsets.all(2),
                padding: EdgeInsets.only(left: 0, right: 0),
                decoration:  ShapeDecoration(
                  //  radius: BorderRadius.all(Radius.circular(2)),
                  // borderRadius: new BorderRadius.vertical(top: Radius.circular(2.0)),
                  color: Colors.white,
                  shape: _TestdWidgetBorder(
                    padding:0.0,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  // clipper: BottomWaveClipper(),
                  // shadows: [
                  //   new BoxShadow(color: Colors.grey[200], offset: Offset(0, -1),spreadRadius: 5,blurRadius: 10)
                  // ]
                ),

                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    _stackVerses(), _stackChapters(), _stackBooks(), _stackStories(), _stackTmp()
                  ]
                )
              )
            ),

            // Positioned(
            //   top: 17,
            //   left:-13,
            //   child: new RawMaterialButton(
            //     constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
            //     onPressed: () {},
            //     child: Center(
            //       child: new Icon(
            //         Icons.arrow_drop_down,
            //         color: Colors.blue,
            //         size: 12.0,
            //       ),
            //     ),
            //     shape: new CircleBorder(),
            //     elevation: 0.2,
            //     fillColor: Colors.transparent,
            //     padding: const EdgeInsets.all(0.0),

            //   ),
            // ),
            Positioned(
              top: 20,
              right: - 10,
              child: new RawMaterialButton(
                constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
                onPressed: () {},
                child: Center(
                  child: new Icon(
                    Icons.bookmark,
                    color: Colors.blue,
                    size: 12.0,
                  ),
                ),
                // shape: new BeveledRectangleBorder(),
                shape: new RoundedRectangleBorder(),
                elevation: 0.2,
                fillColor: Colors.transparent,
                padding: const EdgeInsets.all(0.0),
              ),
            )
          //  Container(
          //    child: Text('content'),
          //  )
          ]
        ),
      )
    );
  }
/*
return new Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 0, left: 7, right: 20,bottom:0),
        padding: EdgeInsets.all(3),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          // borderRadius: new BorderRadius.vertical(top: Radius.circular(2.0)),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Colors.grey[200], offset: Offset(0, 0),spreadRadius: 1,blurRadius: 2)
          ]
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            _stackVerses(), _stackChapters(), _stackBooks(), _stackStories(), _stackTmp()
          ]
        )
      )
    );
*/
  Widget _header() {
    return new Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            // color: Colors.red,
            // decoration: new BoxDecoration(
            //   border: new Border.all(width: 1.0, color: Colors.black),
            //   shape: BoxShape.rectangle,
            //   boxShadow: <BoxShadow>[
            //     BoxShadow(
            //       color: Colors.black,
            //       offset: Offset(0, 0),
            //       blurRadius: 40.0,
            //     ),
            //   ],
            // ),
            // width: 40,
            // height:30,
            child: Icon(Icons.arrow_back_ios)
          ),
          onTap:(){
            Navigator.of(context).pop();
          }
        ),
        new Expanded(
          child: InkWell(
            // ${info.testament} ${info.book}
            child: Text(info.book,maxLines: 1,overflow: TextOverflow.ellipsis),
            onTap: () => _sheetBooks(),
          )
        ),
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Container(
                child: Icon(Icons.keyboard_arrow_left),
              ),
              onTap:()=>setPreviousChapter()
            ),
            InkWell(
              child: Container(
                width: 30,
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(info.chapter,textAlign: TextAlign.center,style: TextStyle(fontSize: 13))
              ),
              onTap:(){
                setState(() {
                  chapterListContainer = !chapterListContainer;
                  if (sheetBooksVisibility == false) Navigator.pop(context);
                });
              }
            ),
            InkWell(
              child: Container(
                child: Icon(Icons.keyboard_arrow_right),
              ),
              onTap:()=>setNextChapter()
            ),
            // InkWell(
            //   child: Container(
            //     child: Icon(Icons.book),
            //   ),
            //   onTap:null
            // ),
            // new IconButton(
            //   padding: EdgeInsets.all(0),
            //   icon: new Icon(Icons.book),
            //   color: Colors.grey,
            //   onPressed: null
            // ),
            // InkWell(
            //   child: Container(
            //     padding: EdgeInsets.symmetric( horizontal: 7),
            //     child: Icon(Icons.search,size: 17),
            //   ),
            //   onTap:()=>showSearch(context: context, delegate: new BibleSearch())
            // ),
            // InkWell(
            //   child: Container(
            //     padding: EdgeInsets.symmetric( horizontal: 7),
            //     child: Icon(Icons.more_horiz,size: 15),
            //   ),
            //   onTap:(){}
            // ),
            // new IconButton(
            //   padding: EdgeInsets.all(0),
            //   icon: new Icon(Icons.search),
            //   // color: Colors.grey,
            //   onPressed: (){
            //     showSearch(context: context, delegate: new BibleSearch());
            //   }
            // )
          ]
        ),

      ]
    );
  }

  // Widget _stack(){
  //   return new Expanded(
  //     child: Container(
  //       alignment: Alignment.topLeft,
  //       margin: EdgeInsets.only(top: 0, left: 7, right: 20,bottom:0),
  //       padding: EdgeInsets.all(3),
  //       decoration: new BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(2)),
  //         // borderRadius: new BorderRadius.vertical(top: Radius.circular(2.0)),
  //         color: Colors.white,
  //         boxShadow: [
  //           new BoxShadow(color: Colors.grey[200], offset: Offset(0, 0),spreadRadius: 1,blurRadius: 2)
  //         ]
  //       ),
  //       child: Stack(
  //         overflow: Overflow.visible,
  //         children: <Widget>[
  //           _stackVerses(), _stackChapters(), _stackBooks(), _stackStories(), _stackTmp()
  //         ]
  //       )
  //     )
  //   );
  // }

  Widget _stackVerses(){
    // return GestureDetector(
    //   child: new SingleChildScrollView(
    //     // key: scaffoldKey,
    //     // controller: scrollController,
    //     scrollDirection: Axis.vertical,
    //     // child: Text('$tmpText \t------ $tmpText \n $tmpText')
    //     child: FutureBuilder<List<ModelVerse>>(
    //       future: store.verseChapter,
    //       builder: (BuildContext context, AsyncSnapshot snapshot) => BibleVerseReader(snapshot: snapshot)
    //     )
    //   )
    // );
    return GestureDetector(
      child: FutureBuilder(
        future: store.verseChapter,
        builder: (BuildContext context, AsyncSnapshot<List<ModelVerse>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData? Container(
            // padding: EdgeInsets.all(4.0),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              // key: scaffoldKey,
              // controller: scrollController,
              // physics: ClampingScrollPhysics(),
              physics: ScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => _verses(snapshot.data[index])
            )
          ):Center(child: CircularProgressIndicator());
        }
      ),
      onVerticalDragEnd:(e){
        print('onVerticalDragEnd');
      },
      onHorizontalDragStart:(e){
        print('onHorizontalDragStart');
      },
      onHorizontalDragUpdate:(e){
        print('onHorizontalDragUpdate');
      },
      onHorizontalDragEnd:(e){
        print('onHorizontalDragEnd');
      }
    );
  }

  Widget _verses(ModelVerse verse){
    return Container(
      // margin: EdgeInsets.symmetric(horizontal:30.0, vertical: 3.0),
      margin: EdgeInsets.symmetric(horizontal:0.0, vertical: 4.0),
      child: RichText(
        text:TextSpan(
          text:  verse.verseTitle!=null?'\n   ${verse.verseTitle}\n\n'.toUpperCase():'',
          style: TextStyle(
            color: Colors.black45,fontWeight: FontWeight.w300,fontSize: 15,
            // decoration: TextDecoration.underline,
            // decorationColor: Colors.grey,
            // decorationStyle: TextDecorationStyle.dotted,
          ),
          children: <TextSpan>[
            TextSpan(text: '   '),
            TextSpan(
              text: store.digit(verse.verse),
              style: TextStyle(
                // inherit: false,
                // color: Colors.grey[500],
                fontSize: 10,
                // background: Paint(),
                // decoration: TextDecoration.underline,
                // decorationColor: Colors.red,
                // decorationStyle: TextDecorationStyle.wavy,
                // shadows: <Shadow>[
                //   Shadow(offset: Offset(0, 0),blurRadius: 1.0,color: Colors.blue)
                // ]
              )
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: verse.verseText,
              style: TextStyle(
                // inherit: false,
                // myanmar only -> height: 0.8,
                color: Colors.black,
                // color: Colors.black,
                // decoration: TextDecoration.underline,
                // decorationColor: Colors.blueAccent,
                // decorationStyle: TextDecorationStyle.dotted,
                shadows: <Shadow>[
                  Shadow(offset: Offset(0, 0),blurRadius: 0.5,color: Colors.grey)
                ]
              )
            ),
          ]
        ),
      )
    );
  }

  Widget _stackChapters(){
    if (chapterListContainer){
      // 150/5*36
      // int _currentChapter = int.parse(info.chapter);
      int _rowActive = store.chapterId;
      // int _rowItems = 7;
      int _rowItems = info.chapterCount;
      int _rowPerItem = _rowItems > 5?5:_rowItems;
      double _rowHeight = _rowItems/_rowPerItem*36;

      return new Positioned(
        right: 10,
        top: 5,
        child: Container(
          child: ShapedChapterList(
            height: _rowHeight,
            child: new GridView.count(
              padding: EdgeInsets.all(0),
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              crossAxisCount: _rowPerItem,
              childAspectRatio: 1,
              children: new List<Widget>.generate(_rowItems, (index) {
                ++index;
                bool isCurrentChapter = _rowActive == index;
                return InkWell(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: isCurrentChapter?Colors.grey[300]:Colors.grey[200],
                      borderRadius: BorderRadius.circular(2)
                    ),
                    child: Center(
                      child: new Text(store.digit(index),
                        style: TextStyle(
                          color: Colors.black87,fontSize: 10,
                          shadows: <Shadow>[
                            Shadow(offset: Offset(0, 2),blurRadius: 8.0,color: Colors.white)
                          ]
                        )
                      )
                      // child: new Text('$index',style: TextStyle(color: Colors.black,fontSize: 11))
                    )
                  ),
                  onTap: ()=>setChapter(index)
                );
              })
            )
          )
        )
      );
    } else {
      return Text('');
    }
  }

  Widget _stackBooks(){
    return Text('');
  }

  Widget _stackStories(){
    return Text('');
  }

  Widget _stackTmp(){
    return Text('');
  }

  void _sheetBooks() {
    if (sheetBooksVisibility) {
      setState(() {
        chapterListContainer = false;
        sheetBooksVisibility = !sheetBooksVisibility;
      });
      scaffoldKey.currentState.showBottomSheet<void>((BuildContext context)=> new WidgetBottomSheet(child: _books(),)).closed.whenComplete(() {
        setState(() {
          sheetBooksVisibility = true;
        });
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _books(){
    return FutureBuilder<List<ModelBook>>(
      future: store.nameList,
      builder: (BuildContext context, AsyncSnapshot<List<ModelBook>> e) {
        if (e.hasError) print(e.error);
        return e.hasData?_booksEngine(e.data):Center(child: CircularProgressIndicator());
        // return e.hasData?Center(child: Text('data'),):Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget _booksEngine(books){
    return ListView.builder(
      // shrinkWrap: true,
      // padding: EdgeInsets.only(top: 0),
      // separatorBuilder: (context, index) => Divider(
      //   color: Colors.grey[400], height: 1, indent: 0,
      // ),
      scrollDirection: Axis.vertical,
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        ModelBook book = books[index];
        return (book.type)?_booksHeader(book):_booksList(book);
      },
    );
  }

  Widget _booksHeader(ModelBook testament){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:7.0, vertical:10),
      child: Text(
        testament.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[500],
          fontWeight: FontWeight.w300
        )
      )
    );
  }

  Widget _booksList(ModelBook book){
    bool isCurrentBook = store.bookId == book.id;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.horizontal(left:Radius.circular(2))
            ),
            width: 40, height: 32,
            child: Center(
              child: Text(store.digit(book.id),style: TextStyle(
                  fontSize: 11, color: Colors.white,
                  // color: Colors.black87,fontSize: 10,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(0, 1),blurRadius: 2.0,color: Colors.grey)
                  ]
                )
              )
            )
          ),
          Expanded(
            child:RaisedButton(
              color: Colors.grey[200],
              textColor: Colors.blue,
              splashColor: Colors.brown,
              disabledColor: Colors.grey[200],
              child: Text(book.name,softWrap: false, maxLines: 1, overflow: TextOverflow.fade,style: TextStyle(
                  fontSize: 11, color: isCurrentBook?Colors.black:Colors.grey,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(0, 0),blurRadius: 12,color: Colors.white10)
                  ]
                )
              ),
              onPressed: (){
                store.chapterBook(book.id).then((_){
                  Navigator.pop(context);
                });
              }
            )
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 10),
            // margin: EdgeInsets.only(right: 10),
            decoration: new BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.horizontal(right:Radius.circular(2))
            ),
            width: 40, height: 32,
            child: Center(
              child: Text(store.digit(book.itemCount),style: TextStyle(
                  fontSize: 11, color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(0, 1),blurRadius: 2.0,color: Colors.grey)
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }
}