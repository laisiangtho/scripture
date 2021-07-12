part of 'main.dart';

mixin _Bar on _State {

  void showBookList(){
    // if (isNotReady) return null;
    // if(keyBookButton.currentContext!=null) return;

    Navigator.of(context).push(PageRouteBuilder<Map<String?, int?>>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      // barrierColor: Colors.white.withOpacity(0.4),
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      pageBuilder: (BuildContext context,x, y) => PopBookList(
        render: keyBookButton.currentContext!.findRenderObject() as RenderBox

      )
    )).then((e){
      // debugPrint(e);
      if (e != null){
      core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
      }
      // setBook(e);
    });
  }

  void showChapterList(){
    // if (isNotReady) return null;
    Navigator.of(context).push(PageRouteBuilder<int>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      // barrierColor: Colors.white.withOpacity(0.4),
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      pageBuilder: (BuildContext context,x, y) => PopChapterList(
        render: keyChapterButton.currentContext!.findRenderObject() as RenderBox
      )
    )).then((e){
      setChapter(e);
    });
  }

  void showOptionList(){
    // if (isNotReady) return null;
    Navigator.of(context).push(PageRouteBuilder<int>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      pageBuilder: (BuildContext _,x, y) => PopOptionList(
        render: keyOptionButton.currentContext!.findRenderObject() as RenderBox,
        setFontSize: setFontSize
      )
    )).whenComplete((){
      // core.writeCollection();
    });
  }

  Widget bar() {
    // debugPrint(kToolbarHeight);
    // debugPrint(MediaQuery.of(context).padding.top);
    return new SliverPersistentHeader(
      pinned: true,
      floating:false,
      delegate: new ViewHeaderDelegate(
        _barMain,
        // maxHeight: widget.barMaxHeight
        // maxHeight: 80,
        // minHeight: 55
        minHeight: 30 //40
      )
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    double width = MediaQuery.of(context).size.width/2;

    return ViewHeaderDecoration(
      overlaps: stretch > 0.3,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(-1,0),
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 2),
              child: Tooltip(
                message: 'bookmark toggle',
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 7),
                  minSize: 30,
                  // child: Icon(
                  //   LaiSiangthoIcon.bookmark,
                  //   // color:hasBookmark?Colors.red:Colors.grey,
                  //   size: (20*shrink).clamp(15, 20).toDouble()
                  // ),
                  child: Selector<Core, bool>(
                    selector: (_, e) => e.scripturePrimary.bookmarked,
                    builder: (BuildContext context, bool hasBookmark, Widget? child) => Icon(
                      // LaiSiangthoIcon.bookmark,
                      hasBookmark?Icons.bookmark_added:Icons.bookmark_add,
                      color:hasBookmark?Colors.red:Colors.grey,
                      size: (28*shrink).clamp(20, 28).toDouble()
                    )
                  ),
                  onPressed: core.bookmarkSwitchNotify
                ),
              )
            )
          ),
          // Align(
          //   // alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,-.1), stretch)!,
          //   // alignment: Alignment(-.8,0),
          //   alignment: Alignment(0,0),
          //   child: _barTitle(shrink)
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     _barSortButton()
          //   ]
          // ),
          Align(
            alignment: Alignment.center,
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  // key:Key('book-button'),
                  key:keyBookButton,
                  constraints: BoxConstraints(maxWidth: width, minWidth:30.0),
                  child: Selector<Core, String>(
                    selector: (_, e) => e.scripturePrimary.bookName,
                    builder: (BuildContext context, String bookName, Widget? child) => _barButton(
                      label: "select Book",
                      // value: '#',
                      value: bookName,
                      radius: new BorderRadius.horizontal(left:Radius.circular(30)),
                      padding: EdgeInsets.only(left: 8*shrink, right:3),
                      shrink: shrink,
                      stretch: stretch,
                      onPressed: showBookList
                    )
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  width: 1,
                  child:Opacity(
                    opacity: stretch,
                    child:  Text('|')
                  )
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  key:keyChapterButton,
                  constraints: BoxConstraints(maxWidth: 100.0, minWidth:30.0),
                  child: Selector<Core, String>(
                    selector: (_, e) => e.scripturePrimary.chapterName,
                    builder: (BuildContext context, String chapterName, Widget? child) => _barButton(
                      label: "select Chapter",
                      // value: '#',
                      value: chapterName,
                      radius: new BorderRadius.horizontal(right:Radius.circular(30)),
                      // padding: EdgeInsets.symmetric(horizontal:7*shrink),
                      padding: EdgeInsets.only(left: 0,right: 3*shrink),
                      shrink: shrink,
                      stretch: stretch,
                      onPressed: showChapterList
                    )
                  )
                )
              ]
            )
          ),
          Align(
            // alignment: Alignment(.95,-1),
            alignment: Alignment(1,0),
            child: Padding(
              padding: EdgeInsets.only(top: 5, right: 2),
              child: Tooltip(
                message: 'Sort available Bible list',
                child: CupertinoButton(
                  key:keyOptionButton,
                  padding: EdgeInsets.zero,
                  // padding: EdgeInsets.symmetric(vertical:10,horizontal:10),
                  // color: Colors.blue,
                  child: new Icon(
                    // Icons.home,
                    LaiSiangthoIcon.text_size,
                    // color: this.isSorting?Colors.red:null,
                    // size: 18,
                    size: (20*shrink).clamp(18, 20).toDouble()
                  ),
                  onPressed: showOptionList
                ),
              )
            )
          ),
        ]
      )
    );
  }

  Widget _barButton({
    required double stretch,
    required double shrink,
    required BorderRadius radius,
    required EdgeInsets padding,
    required String label,
    required String value,
    required void Function()? onPressed
    }){
    return Tooltip(
      message: label,
      child: CupertinoButton(
        // color: (stretch<=0.5)?null:Colors.grey[400].withOpacity(stretch),
        // color: (shrink>1.0)?null:Theme.of(context).backgroundColor.withOpacity(stretch),
        // color: (shrink<1.0)?null:Theme.of(context).backgroundColor.withOpacity(shrink.clamp(0.0, 0.3)),
        color: Theme.of(context).backgroundColor.withOpacity((shrink-0.7).clamp(0.0, 0.3)),
        minSize: 33,
        // minSize: (33*stretch).clamp(25.0, 33.0),
        padding: padding,
        // padding: EdgeInsets.symmetric(horizontal:7*shrink),
        // padding: EdgeInsets.zero,
        borderRadius: radius,
        // borderRadius: new BorderRadius.horizontal(left:Radius.circular(30)),
        child: Text(
          // localChapter?.name?.bookName??'....',
          // key:ValueKey<int>(localChapter?.name?.bookId??0),
          // tmpbook?.name??'....',
          value,
          // key:ValueKey<int>(tmpbook?.id??0),
          // semanticsLabel: tmpbook?.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // textScaleFactor: max(0.7, stretch),
          textAlign: TextAlign.center,
          style: TextStyle(
            // color: Color.lerp(Theme.of(context).backgroundColor, Theme.of(context).primaryColor, shrink),
            // color: Color.lerp(null, Theme.of(context).primaryColor, shrink),
            // color: Color.lerp(Colors.black87, Colors.black54, shrink),
            fontSize: 16,
            height: 1.33
          )
        ),
        onPressed: onPressed
      ),
    );
  }

  // Widget _barTitle(double shrink){
  //   return Text(
  //     '...read',
  //     style: TextStyle(
  //       fontFamily: "sans-serif",
  //       // color: Color.lerp(Colors.white, Colors.white24, stretch),
  //       // color: Colors.black,
  //       fontWeight: FontWeight.w400,
  //       // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
  //       // fontSize:35 - (16*stretch),
  //       // fontSize:(25*shrink).clamp(25.0, 35.0),
  //       fontSize:20,
  //       // shadows: <Shadow>[
  //       //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
  //       // ]
  //     )
  //   );
  // }

}
