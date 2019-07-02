import 'package:flutter/material.dart';

import 'Note.dart';
import 'SlideableAnimatedList.dart';

class NoteView extends NoteState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: store.bible,
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            return body();
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

  Widget body() {
    return CustomScrollView(
      // controller: store.scrollController,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating: true,delegate: WidgetHeaderSliver(bar)),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          sliver: bookmarksFuture()
        )
      ]
    );
  }

  Row bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Bookmark')
      ]
    );
  }

  Widget bookmarksFuture(){
    return FutureBuilder(
      future: store.testingBookmark(),
      builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) => bookmarksResponse(snapshot)
    );
  }

  Widget bookmarksResponse(result){
    if (result.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: result.error)
      );
    }

    if (result.hasData) {
      if (result.data.length > 0) {
        return SliverToBoxAdapter(
          child: bookmarksAnimatedList(result.data)
        );
      } else {
        return new SliverFillRemaining(
          child: Center(
            child: WidgetEmptyIdentify(atLeast:'collection of\n',enable:'Bookmark',task: ' &\nother ',message: 'library')
          )
        );
      }
    }
    return new SliverFillRemaining();
  }

  Widget bookmarksAnimatedList(List<Map<String,dynamic>> data){
    return AnimatedList(
      key: animatedListKey,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      initialItemCount: data.length,
      itemBuilder: (context, index, animation) => bookmarksItem(context, data,index,animation)
    );
  }

  Widget bookmarksItem(BuildContext context, List<Map<String,dynamic>> o,int index, Animation<double> animation){
    // Map<String,dynamic> item = o[index];
    Key id = Key(store.uniqueIdentify.toString());
    Map<String,dynamic> item = o[index];
    Widget menu = bookmarksItemWidget(item);
    return new SlideableAnimatedList(
      key: id,
      animation: animation,
      menu: menu,
      menuRight: <Widget>[
        new RawMaterialButton(
          elevation: 0,
          highlightElevation: 0.0,
          fillColor: Colors.grey,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.elliptical(100, 100))),
          constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: new Icon(Icons.remove_circle,color: Colors.white, size: 27),
          onPressed: (){
            // o.removeAt(index);
            animatedListKey.currentState.removeItem(index, (BuildContext context, Animation<double> animation) {
                return new SlideableAnimatedList(key: id,menu: menu,animation: animation);
            });
            setState(() {
              store.removeCollectionBookmark(index);
            });
          }
        )
      ]
    );
  }

  Widget bookmarksItemWidget(item){
    return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        item['bookName'],
        maxLines: 1,overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)
      ),
      subtitle: Text(item['testamentName']),
      trailing: Text(item['chapterName'],style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)),
      onTap: (){
        store.bookId = item['book'];
        store.chapterId = item['chapter'];
        this.toBible();
      }
    );
  }
}
