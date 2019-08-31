
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'dart:math';
import 'dart:ui';

import 'Common.dart';

import 'StoreModel.dart';
import 'Bible.dart';

import 'PopupBook.dart';
import 'PopupChapter.dart';
import 'SheetOption.dart';
import 'PopupOption.dart';

class BibleView extends BibleState{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: store.activeName(),
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            collectionGenerate(e);
            isCollectionBookmark();
            test();
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
      bottomNavigationBar: bottomStack()
    );
  }

  Stack bottomStack() {
    double defaultBottom = store.contentBottomPadding + 10;
    double offsetVertical = -30*store.offset;
    double offsetBottom = defaultBottom-(defaultBottom*store.offset);
    // double offsetBottom = defaultBottom*store.offset;
    RawMaterialButton chapterNavigation(IconData icon, BorderRadius radius, Function onPressed){
      return new RawMaterialButton(
        elevation: 0,
        highlightElevation: 0.0,
        fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
        shape: new RoundedRectangleBorder(borderRadius: radius),
        constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: new Icon(icon,color: Colors.white),
        onPressed: () => onPressed()
      );
    }
    return Stack(
      children: <Widget>[
        Positioned(
          bottom:offsetBottom,
          left:offsetVertical,
          child: chapterNavigation(
            Icons.chevron_left,
            new BorderRadius.horizontal(right: Radius.elliptical(10, 20)),
            setPreviousChapter
          )
        ),
        Positioned(
          bottom: offsetBottom,
          right:offsetVertical,
          child: chapterNavigation(
            Icons.chevron_right,
            new BorderRadius.horizontal(left: Radius.elliptical(10, 20)),
            setNextChapter
          )
        ),
        Positioned(
          top: 100,
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
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(20, 70))),
            child: selectedOption()
          ):Container()
        )
      ]
    );

  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: store.scrollController,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true, floating: true, delegate: WidgetHeaderSliver(bar,minHeight: 20)),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          sliver: futureBuilderSliver()
        )
      ]
    );
  }

  double setChapterDrag;
  double initialX;
  double initialY;
  double dragDistance;

  Widget futureBuilderSliver(){
    return new FutureBuilder(
      future: store.getVerseChapter,
      builder: (BuildContext context, AsyncSnapshot<List<VERSE>> snap) {
        if (snap.hasError) {
          return new SliverFillRemaining(
            child: WidgetError(message: snap.error.toString())
          );
        }
        if (snap.hasData) {
          return SliverToBoxAdapter(
            child: GestureDetector(
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data.length,
                padding: EdgeInsets.symmetric(vertical: 7.0),
                // padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) => _verses(snap.data,index)
              ),
              onHorizontalDragStart:(e){
                initialX = e.globalPosition.dx;
              },
              onHorizontalDragUpdate:(e){
                dragDistance = e.localPosition.dx - initialX;
                if (e.delta.dx < 0) dragDistance = initialX - e.localPosition.dx;
                if (dragDistance >= 50.0){
                  // initialX = e.localPosition.dx;
                  setChapterDrag = e.delta.dx;
                }
              },
              // onHorizontalDragCancel: (){},
              onHorizontalDragEnd:(e){
                if (dragDistance >= 50.0){
                  if (setChapterDrag > 0) setPreviousChapter(); else setNextChapter();
                }
              }
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

  Widget _verses(List<VERSE> verseList, index){
    VERSE verse = verseList[index];
    bool isSelected = selectedVerse.indexWhere((i)=>i==verse.verse) >= 0;

    return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
      // dense: true,
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
          textScaleFactor: 0.20,
          text:TextSpan(
            // text:  titleText,
            style: Theme.of(context).textTheme.display4,
            children: <TextSpan>[
              TextSpan(
                text: verse.verseTitle.isNotEmpty?'\n   ${verse.verseTitle}\n\n'.toUpperCase():'',
                style: TextStyle(color: Colors.grey, fontSize: 80)
              ),
              TextSpan(text: '   '),
              TextSpan(
                text: store.digit(verse.verse),
                style: TextStyle(color: Colors.black45, fontSize: 90)
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: verse.verseText,
                style: TextStyle(
                  // color: isSelected?Colors.red:null,
                  // backgroundColor: isSelected?Colors.grey:null,
                  backgroundColor: isSelected?Theme.of(context).backgroundColor:null,
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
      pageBuilder: (BuildContext context,x, y) => PopupBook(mainContext: keyBookButton.currentContext.findRenderObject())
    )).then((e){
      setBookChapter(e);
      store.analyticsScreen('booksPopup','BookPopup');
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
      pageBuilder: (BuildContext context, x, y) => PopupChapter(mainContext: keyChapterButton.currentContext.findRenderObject(),chapterCount:activeName.chapterCount)
    )).then((e){
      setChapter(e);
      store.analyticsScreen('chapterPopup','ChapterPopup');
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoButton(
          // padding: EdgeInsets.all(7),
          child: Icon(Icons.content_copy,size:19),
          onPressed:(){
            this.getSelectedVerse.then((e){
              Clipboard.setData(new ClipboardData(text: e)).whenComplete((){
              });
            });
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
          // padding: EdgeInsets.all(0),
          child: Icon(Icons.cancel, size:19),
          onPressed:(){
            setState((){
              selectedVerse.clear();
            });
          }
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){

    double width = MediaQuery.of(context).size.width/2;
    // double commaWidth=1.0, chapterWidth=50.0, taskWidth=width - (commaWidth + chapterWidth);
    Widget titleContainer({key,double width:100,String title,Function onPress, BorderRadius borderRadius}){
      return Container(
        key:key,
        constraints: BoxConstraints(maxWidth: width, minWidth:30.0),
        child: CupertinoButton(
          color: Colors.grey[200].withOpacity(shrink),
          minSize: 30,
          padding: EdgeInsets.symmetric(vertical:0, horizontal:15*shrink),
          borderRadius: borderRadius,
          child: Text(
            title,maxLines: 1,overflow: TextOverflow.ellipsis, textScaleFactor: max(0.6, shrink),
            style: TextStyle(
              color: Color.lerp(Colors.black87, Colors.black54, shrink), fontSize: 18
            )
          ),
          onPressed: onPress
        )
      );
    }

    return Stack(
      children: <Widget>[
        Align(
          widthFactor: 1,
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            // padding: EdgeInsets.zero,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 7),
            // padding: EdgeInsets.lerp(EdgeInsets.symmetric(vertical: 0,horizontal: 0), EdgeInsets.symmetric(vertical: 0,horizontal: 0), shrink),
            minSize: 30,
            child:Icon(isChapterBookmarked?Icons.bookmark:Icons.bookmark_border,color:isChapterBookmarked?Colors.red:Colors.grey[300],size: (10*shrink)+20),
            onPressed: () {
              store.addCollectionBookmark().then((e){
                setState((){});
              });
            }
          )
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              titleContainer(
                key: keyBookButton,
                width: width,
                title: activeName.bookName,
                onPress: ()=>booksPopup(shrink),
                borderRadius: new BorderRadius.horizontal(left:Radius.circular(30))
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 1,
                child:Opacity(
                  opacity: stretch,
                  child:  Text(',',style: TextStyle(color: Colors.grey))
                )
              ),
              titleContainer(
                key: keyChapterButton,
                title: store.digit(store.chapterId),
                onPress: ()=>chapterPopup(shrink),
                borderRadius: new BorderRadius.horizontal(right:Radius.circular(30))
              )
            ]
          )
        ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Icon(Icons.format_size,color:Colors.grey[300],size: (10*shrink)+20)
        // )
      ]
    );
  }
}