import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Bible.dart';
import 'package:laisiangtho/WidgetShaped.dart';
import 'package:laisiangtho/WidgetCommon.dart';
import 'package:laisiangtho/BibleSearch.dart';
// import 'package:laisiangtho/BibleBarTitle.dart';
// import 'package:laisiangtho/BibleBarBackground.dart';
// import 'package:laisiangtho/BibleVerseReader.dart';

class BibleView extends BibleState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: store.titleName,
        builder: (BuildContext context, AsyncSnapshot<ModelChapter> e) {
          if (e.hasData){
            infoGenerate(e);
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
    return new SafeArea(
      // top: false,
      // bottom: false,
      // minimum: const EdgeInsets.symmetric(vertical:50),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildHeader(), _buildStack()
          ]
        ),
      )
    );
  }

  Widget _buildHeader() {
    return new Row(
      children: <Widget>[
        new InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            // color: Colors.red,
            // decoration: new BoxDecoration(
            //   // border: new Border.all(width: 1.0, color: Colors.black),
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
            height:50,
            child: Icon(Icons.arrow_back_ios, size: 23)
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
            new IconButton(
              padding: EdgeInsets.all(0),
              icon: new Icon(Icons.search),
              color: Colors.grey,
              onPressed: (){
                showSearch(context: context, delegate: new BibleSearch());
              }
            )
          ]
        ),

      ]
    );
  }

  Widget _buildStack(){
    return new Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 10, left: 15, right: 15,bottom:0),
        padding: EdgeInsets.all(3),
        decoration: new BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(2)),
          borderRadius: new BorderRadius.vertical(top: Radius.circular(2.0)),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Colors.grey[200], offset: Offset(0, 0),spreadRadius: 10,blurRadius: 10)
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
  }

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
        right: 38,
        top: -10,
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