
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:ui';
// import 'package:meta/meta.dart';

import 'Common.dart';

import 'StoreModel.dart';
// import 'BibleSearch.dart';
import 'Bible.dart';


import 'PopupBook.dart';
import 'PopupChapter.dart';
import 'SheetOption.dart';
import 'PopupOption.dart';

class BibleView extends BibleState{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: widget.key,
      body: FutureBuilder(
        future: store.activeName(),
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            collectionGenerate(e);
            isCollectionBookmark();
            return body();
          } else if (e.hasError) {
            if (store.identify.isEmpty){
              return WidgetEmptyIdentify();
            } else {
              return WidgetError(message: e.error.toString());
            }
          } else {
            return WidgetLoad();
          }
        }
      ),
      extendBody: true,
      bottomNavigationBar: bottomStack(),
      // bottomSheet: bottomStack(),

    );

  }

  Stack bottomStack() {
    // print(doubleAnimation.value*store.offset);
    double navVertical = -25*store.offset;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom:60-(60*store.offset),
          left:navVertical,
          child:new RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            // fillColor: Colors.white,
            fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 20))),
            constraints: BoxConstraints(minHeight: 30, minWidth: 30, maxWidth: 40),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(Icons.chevron_left,color: Colors.white),
            onPressed:()=>setPreviousChapter()
          ),
        ),
        Positioned(
          bottom: 60-(60*store.offset),
          right:navVertical,
          child:new RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            // fillColor: Colors.white,
            fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))),
            // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.all(Radius.elliptical(10, 20))),
            constraints: BoxConstraints(minHeight: 30, minWidth: 30, maxWidth: 40),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(Icons.chevron_right,color: Colors.white,),
            onPressed:()=>setNextChapter()
          ),
        ),
        Positioned(
          top: 70,
          right:0,
          child: selectedVerse.isNotEmpty?Material(
            elevation:0.2,
            // color: Theme.of(context).primaryColor.withOpacity(0.2),
            // color: Colors.red.withOpacity(0.9),
            clipBehavior: Clip.hardEdge,
            // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5,3))),
            // shape: BeveledRectangleBorder(
            //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(46.0)),
            // ),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(2, 2))),
            child: selectedOption()
          ):Container()
        )
      ]
    );
  }
  CustomScrollView body() {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: <Widget>[
        new SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: WidgetHeaderSliver(bar)
        ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: 45),
          sliver: futureBuilderSliver(),
        )
      ]
    );
  }
  Widget futureBuilderSliver(){
    return new FutureBuilder(
      future: store.verseChapter,
      builder: (BuildContext context, AsyncSnapshot<List<VERSE>> snap) {
        if (snap.hasError) {
          return new SliverFillRemaining(
            child: WidgetError(message: snap.error.toString())
          );
        }
        if (snap.hasData) {
          return SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) => _verses(snap.data,index),
              childCount: snap.data.length
            )
          );
        } else {
          return new SliverFillRemaining(
            child:  WidgetLoad()
          );
        }
      }
    );
  }
  Widget futureBuilderWithGesture(){
    return GestureDetector(
      child: FutureBuilder(
        future: store.verseChapter,
        builder: (BuildContext context, AsyncSnapshot<List<VERSE>> snap) {
          if (snap.hasError) print(snap.error);
          return snap.hasData? Container(
            // padding: EdgeInsets.all(4.0),
            child: ListView.builder(
              // padding: EdgeInsets.only(top: 0),
              // scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              // primary: true,
              // key: scaffoldKey,
              // controller: scrollController,
              // physics: ClampingScrollPhysics(),
              physics: ScrollPhysics(),
              // physics: ScrollPhysics(),
              itemCount: snap.data.length,
              itemBuilder: (BuildContext context, int index) => _verses(snap.data,index)
            )
          ):Center(child: CircularProgressIndicator());
        }
      ),
      onVerticalDragUpdate: (drag) {
        if (drag.delta.dy > 10) print('down ${drag.delta.dy}');
        if (drag.delta.dy < -10) print('up ${drag.delta.dy}');
      },
      onHorizontalDragUpdate: (drag) {
        if (drag.delta.dx > 2) setNextChapter();
        if (drag.delta.dx < -2) setPreviousChapter();
      },
      onHorizontalDragEnd: (e){},
      onVerticalDragEnd: (e){},
    );
  }


  Widget _verses(List<VERSE> verseList, index){
    VERSE verse = verseList[index];
    bool isSelected = selectedVerse.indexWhere((i)=>i==verse.verse) >= 0;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      dense: true,
      onTap: () {
        setState(() {
          if (isSelected){
            selectedVerse.remove(verse.verse);
          } else {
            selectedVerse.add(verse.verse);
          }
          bottomSheetOption?.setState((){});
        });
      },
      onLongPress: (isSelected && bottomSheetOption == null)?showSheetOption:null,
      title: AnimatedSize(
        duration: Duration(milliseconds: 300),
        vsync: this,
        curve: Curves.easeOut,
        child: RichText(
          text:TextSpan(
            text:  verse.verseTitle!=null?'\n   ${verse.verseTitle}\n\n'.toUpperCase():'',
            style: TextStyle(
              color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15, height: 0.90
            ),
            children: <TextSpan>[
              TextSpan(text: '   '),
              TextSpan(
                text: store.digit(verse.verse),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45
                )
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: verse.verseText,
                style: TextStyle(
                  color: isSelected?Colors.white:null,
                  backgroundColor: isSelected?Colors.grey:null,
                  // background: Paint(),
                  // decoration: isSelected?TextDecoration.underline:TextDecoration.none,
                  // decorationColor: Colors.red,
                  // decorationStyle: TextDecorationStyle.wavy,
                  // shadows: <Shadow>[
                  //   Shadow(offset: Offset(0, 0),blurRadius: 1.0,color: Colors.red)
                  // ]
                )
              )
            ]
          )
        ),
      )
    );
  }
  void showSheetOption() {
    // Scaffold.of(context).showBottomSheet((BuildContext context) => ??).closed.whenComplete(() {}});
    // scaffoldKey.currentState.showBottomSheet((BuildContext context) => ??).closed.whenComplete(() {}});
    setState(() {
      // selectedVerse
      bottomSheetOption = Scaffold.of(context).showBottomSheet((BuildContext context) => SheetOption(verse:selectedVerse,setState: updateState));
      // .closed.whenComplete(() {
      //   if (mounted) setState(() {});
      // });
      // bottomSheetOption.setState((){});

      bottomSheetOption.closed.whenComplete(() {
        setState(() {
          bottomSheetOption = null;
        });
      });
    });
  }

  void booksPopup (double shrinkOffset) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 0.7),
              end: Offset.zero,
            ).animate(animation),
            child: child
          );
        },
      // barrierColor: Colors.white.withOpacity(0.3),
      pageBuilder: (BuildContext context,x, y) => PopupBook(shrinkOffset: shrinkOffset)
    )).then((e){
      setBookChapter(e);
    });
  }
  void chapterPopup (double shrinkOffset) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.7),
            end: Offset.zero,
          ).animate(animation),
          child: child
        );
      },
      pageBuilder: (BuildContext context, x, y) => PopupChapter(shrinkOffset: shrinkOffset,chapterCount:activeName.chapterCount)
    )).then((e){
      setChapter(e);
    });
  }
  void optionPopup (double shrinkOffset) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.7),
            end: Offset.zero,
          ).animate(animation),
          child: child
        );
      },
      pageBuilder: (BuildContext context, x, y) => PopupOption(shrinkOffset: shrinkOffset)
    )).then((e){
    });
  }


  Widget selectedOption(){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      // verticalDirection: VerticalDirection.up,
      children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.all(0),
          // child: Text('Copy'),
          minSize: 30,
          child: Icon(Icons.content_copy,size:15),
          onPressed:(){
            this.getSelectedVerse.then((e){
              Clipboard.setData(new ClipboardData(text: e)).whenComplete((){
                // Navigator.pop(context,'copy');
              });
            });
            // Clipboard.setData(new ClipboardData(text: _copy));
          }
        ),
        // CupertinoButton(
        //   padding: EdgeInsets.all(0),
        //   minSize: 30,
        //   child: Icon(Icons.bookmark_border,size:15),
        //   onPressed:(){}
        // ),
        // CupertinoButton(
        //   padding: EdgeInsets.all(0),
        //   minSize: 30,
        //   child: Icon(Icons.share,size:15),
        //   onPressed:(){}
        // ),
        CupertinoButton(
          padding: EdgeInsets.all(0),
          minSize: 30,
          child: Icon(Icons.cancel, size:15),
          onPressed:(){
            setState((){
              selectedVerse.clear();
            });
            // Navigator.pop(context,'clear');
          }
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    double width = MediaQuery.of(context).size.width/2;
    // double commaWidth=1.0, chapterWidth=50.0, taskWidth=width - (commaWidth + chapterWidth);
    Widget titleContainer({Alignment alignment,double width,String title,Function onPress, BorderRadius borderRadius}){
      return Container(
        alignment: alignment,
        constraints: BoxConstraints(maxWidth: width),
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
                // print('bookmark');
                // store.getCollectionBookmark().then((e){
                //   print(e);
                // });
                store.addCollectionBookmark().then((e){
                  // print(e);
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
          width: 59,
          title: store.digit(store.chapterId),
          onPress: ()=>chapterPopup(shrink),
          borderRadius: new BorderRadius.horizontal(right:Radius.circular(30))
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: width-60,
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
  }
}