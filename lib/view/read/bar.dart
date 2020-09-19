// import 'package:bible/component.dart';
part of 'main.dart';

mixin _Bar on _State {

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      floating:true,
      pinned: true,
      delegate: new ScrollPageBarDelegate(bar,minHeight: 30)
      // delegate: new ScrollPageBarDelegate(bar)
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    double width = MediaQuery.of(context).size.width/2;
    // print('overlaps $overlaps stretch $stretch shrink $shrink');
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(-.95, 0.0),
          child: Tooltip(
            message: 'bookmark toggle',
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 7),
              minSize: 30,
              child: Icon(
                CustomIcon.bookmark,color:hasBookmark?Colors.red:Colors.grey,
                size: (25*stretch).clamp(15, 25).toDouble()
              ),
              onPressed: setBookmark
            ),
          )
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                key:keyBookButton,
                constraints: BoxConstraints(maxWidth: width, minWidth:30.0),
                child: Tooltip(
                  message: "Tap to select book",
                  child: CupertinoButton(
                    color: (stretch<=0.5)?null:Colors.grey[400].withOpacity(stretch),
                    // minSize: 33,
                    minSize: (33*stretch).clamp(25.0, 33.0),
                    padding: EdgeInsets.symmetric(horizontal:15*stretch),
                    // padding: EdgeInsets.zero,
                    borderRadius: new BorderRadius.horizontal(left:Radius.circular(30)),
                    child: Text(
                      // localChapter?.name?.bookName??'....',
                      // key:ValueKey<int>(localChapter?.name?.bookId??0),
                      tmpbook?.name??'....',
                      key:ValueKey<int>(tmpbook?.id??0),
                      semanticsLabel: tmpbook?.name,
                      maxLines: 1,overflow: TextOverflow.ellipsis,
                      textScaleFactor: max(0.7, stretch),
                      // style: TextStyle(
                      //   color: Color.lerp(Colors.black87, Colors.black54, shrink),
                      //   fontSize: 15,height: 1.3
                      // )
                    ),
                    onPressed: showBookList
                  ),
                )
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 1,
                child:Opacity(
                  opacity: shrink,
                  child:  Text(',',style: TextStyle(color: Colors.grey))
                )
              ),
              // CupertinoButton(
              //   child: Text('t $counter'),
              //   onPressed: _scrollToIndex
              // ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                key:keyChapterButton,
                constraints: BoxConstraints(maxWidth: 100.0, minWidth:30.0),
                child: Tooltip(
                  message: "Tap to select chapter",
                  child: CupertinoButton(
                    color: (stretch<=0.5)?null:Colors.grey[400].withOpacity(stretch),
                    minSize: (33*stretch).clamp(25.0, 33.0),
                    padding: EdgeInsets.symmetric(horizontal:15*stretch),

                    borderRadius: new BorderRadius.horizontal(right:Radius.circular(30)),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds:400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: Text(
                        // localChapter?.chapterName??'#',
                        // key:ValueKey<int>(localChapter?.chapterId??0),
                        tmpchapter?.name??'#',
                        key:ValueKey<int>(tmpchapter?.id??0),
                        semanticsLabel: tmpchapter?.name,
                        maxLines: 1,overflow: TextOverflow.ellipsis, textScaleFactor: max(0.7, stretch),
                        // style: TextStyle(
                        //   color: Color.lerp(Colors.black87, Colors.black54, shrink), fontSize: 15,
                        // )
                      ),
                    ),
                    onPressed: showChapterList
                  ),
                )
              ),
            ]
          )
        ),
        Align(
          alignment: Alignment(.95, 0.0),
          child: Tooltip(
            message: 'Adjust font size',
            child: CupertinoButton(
              key: keyOptionButton,
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 7),
              minSize: 30,
              // child: Icon(
              //   Icons.text_format, color: Colors.grey[300],
              //   size: (30*stretch).clamp(20, 30).toDouble()
              // ),
              child: Icon(
                CustomIcon.text_size, color: Colors.grey,
                size: (25*stretch).clamp(15, 25).toDouble()
              ),
              // child: Text('Aa'),
              onPressed: showOptionList
            ),
          )
        )
      ]
    );
  }

}
/*
  void showBookList(BuildContext context) {
    scaffoldKey.currentState.showBottomSheet(
      (BuildContext context)  => bookListContainer(),
      // elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: Colors.grey[400],
      // backgroundColor: Colors.red
      // context: context,
    )..closed.whenComplete(() {
    });
    Scaffold.showBottomSheet

   showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      // isScrollControlled: false,
      // isDismissible: true,
      context: context,
      builder: (BuildContext context) => bookListContainer()
      // builder: (BuildContext context) => WidgetModalSheet(
      //   child: bookListContainer(),
      // )
    )..whenComplete(() => setState(() {}));
    scaffoldKey.currentState.showBottomSheet(
      (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            // return WidgetSheet(
            //   child: BookMenu(scrollController:scrollController,setBook: setBook),
            // );
            return BookMenu(scrollController:scrollController,setBook: setBook);
          },
        );
      },
      // elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor:  Theme.of(context).primaryColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // clipBehavior: Clip.antiAlias
      // backgroundColor: Colors.red
    ).closed.whenComplete((){
      setState(() {
        print('setstate');
      });
    });
    scaffoldKey.currentState.showBottomSheet(
    // Scaffold.of(context).showBottomSheet(
      (BuildContext context) {
        return DraggableScrollableActuator(
          child: DraggableScrollableSheet(
            key: Key('tmp'),
            expand: false,
            initialChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              // return WidgetSheet(
              //   child: BookMenu(scrollController:scrollController,draggableSheetContext: context, setBook: setBook),
              // );
              return BookMenu(scrollController:scrollController,draggableSheetContext: context, setBook: setBook);
            },
          ),
        );
      },
      // elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor:  Theme.of(context).primaryColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // clipBehavior: Clip.antiAlias
      // backgroundColor: Colors.red

    ).closed.whenComplete((){
      setState(() {
        print('setstate');
      });
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // enableDrag: true,
      useRootNavigator: true,
      elevation: 2.0,
      barrierColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor:  Theme.of(context).primaryColor,
      // backgroundColor:  Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // clipBehavior: Clip.antiAlias
      // backgroundColor: Colors.red
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.905,
          builder: (BuildContext context, ScrollController scrollController) {
            // return WidgetSheet(
            //   child: BookMenu(scrollController:scrollController,setBook: setBook),
            //   // child: bookListLoader(scrollController),
            // );
            return BookMenu(scrollController:scrollController,setBook: setBook);
          },
        );
      },
    ).then((value){
      print('close with $value');
    });
  }
  */