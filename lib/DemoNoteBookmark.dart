import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Store.dart';
import 'Note.dart';

class DemoNoteBookmark extends StatefulWidget {
  DemoNoteBookmark({
    Key key
  }) : super(key: key);

  @override
  _DemoNoteBookmarkState createState() => _DemoNoteBookmarkView();
}

abstract class _DemoNoteBookmarkState extends State<DemoNoteBookmark> with TickerProviderStateMixin{

  final GlobalKey<AnimatedListState> keyAnimatedListBookmark = GlobalKey<AnimatedListState>();
  Store store = new Store();

  @override
  void initState() {
    super.initState();
    // store.scrollController?.addListener(() => setState(() {}));
  }
}

class _DemoNoteBookmarkView extends _DemoNoteBookmarkState {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
        actions: <Widget>[
        ]
      ),
      body: FutureBuilder(
        future: store.bible,
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            return bookmarks();
          } else if (e.hasError) {
            if (store.identify.isEmpty){
              return WidgetEmptyIdentify(task: ' to\nview ',message: 'bookmarks');
            } else {
              return WidgetError(message: e.error.toString());
            }
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  Widget bookmarks(){
    return FutureBuilder(
      future: store.testingBookmark(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) => bookmarksSnapshot(snapshot)
    );
  }

  Widget bookmarksSnapshot(result){
    if (result.hasError) {
      return new Center(
        child: WidgetError(message: result.error)
      );
    }

    if (result.hasData) {
      if (result.data.length > 0) {
        return Container(
          child: AnimatedList(
            key: keyAnimatedListBookmark,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            initialItemCount: result.data.length,
            itemBuilder: (context, index, animation) => bookmarkBuildItem(context, result.data,index,animation),
          ),
        );
      } else {
        return new Center(
          child: WidgetEmptyIdentify(atLeast:'collection of\n',enable:'Bookmarks',task: ' &\nother ',message: 'library')
        );
      }
    }
    return new Center(child: Text('????'),);
  }

  Widget bookmarkBuildItem(BuildContext context, List o,int index, Animation<double> animation) {
    return BookmarkContainer(
      animation: animation,
      bookmark: o[index],
      // selected: _selectedItem == _list[index],
      onTap: () {
        Map<String,dynamic> removedItem = o.removeAt(index);
        if (removedItem != null) {
          keyAnimatedListBookmark.currentState.removeItem(index, (BuildContext context, Animation<double> animation) {

            return bookmarkRemovedItem(removedItem, context, animation);
            // store.removeCollectionBookmark(index);
          });
          setState(() {
            store.removeCollectionBookmark(index);
          });
        }
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget bookmarkRemovedItem(Map<String,dynamic> removedItem,BuildContext context,  Animation<double> animation) {
    return new BookmarkContainer(
      bookmark: removedItem,
      animation: animation,
    );
  }
}

class BookmarkContainer extends StatelessWidget {
  const BookmarkContainer({
    Key key,
    @required this.animation,
    this.onTap,
    @required this.bookmark,
    // @required this.item,
    this.selected = false,
  }) : assert(animation != null),
      //  assert(item != null && item >= 0),
       assert(selected != null),
       super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  // final int item;
  final Map<String,dynamic> bookmark;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected) textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 128.0,
            child: Card(
              // color: Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text(bookmark['bookName']+' '+bookmark['chapter'].toString(),style: textStyle,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}