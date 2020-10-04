part of 'main.dart';

class View extends _State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      body: ScrollPage(
        controller: controller.master,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar)),
        body()
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Bookmark',
        semanticsLabel: 'Bookmark',
        style: TextStyle(fontSize: 20),
      )
    );
    // return Container(
    //   child: Center(child: Text('Bookmark'))
    // );
  }

  Widget body(){
    if (isNotReady || bookmarks.length == 0) {
      return new WidgetContent(atLeast:'collection of\n',enable:'Bookmark',task: ' &\nother ',message: 'library');
    }
    return new SliverPadding(
      padding: EdgeInsets.only(top:7.0,bottom: MediaQuery.of(context).padding.bottom+5.0),
      sliver: new SliverAnimatedList(
        key: core.keyBookmarkList,
        initialItemCount: bookmarks.length,
        itemBuilder: _listItem
      )
    );
  }

  Widget _listItem(BuildContext _, int index, Animation<double> animation){

    CollectionBookmark bookmark = bookmarks[index];
    Key id = ValueKey<String>('${bookmark.bookId}-${bookmark.chapterId}');
    Widget menu = bookmarksItem(bookmark);
    return new SlideableAnimatedList(
      key: id,
      animation: animation,
      // controller: animatedController,
      menu: menu,
      right: <Widget>[
        new CupertinoButton(
          // child: new Icon(Icons.delete,color: Colors.grey, size: 27),
          child: new Icon(
            // Icons.sort,
            CustomIcon.trash,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            // o.removeAt(index);
            core.keyBookmarkList.currentState.removeItem(
              index,
              (_, animation) => new SlideableAnimatedList(
                key: id,
                menu: menu,
                animation: animation
              )
            );
            setState(() {
              core.removeBookmark(index);
            });
          }
        ),
      ]
    );
  }

  Widget bookmarksItem(CollectionBookmark bookmark){
    DefinitionBook book = core.getDefinitionBookById(bookmark.bookId);
    DefinitionTestament testament = core.getDefinitionTestamentById(bookmark.bookId > 39?2:1);
    return Container(
      margin: EdgeInsets.symmetric(horizontal:5,vertical:2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: new BorderRadius.all(
          // Radius.elliptical(3, 20)
          Radius.elliptical(7, 100)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.6,
            offset: Offset(0.0, .0),
          )
        ]
      ),
      child: IntrinsicHeight(
        child: ListTile(
          dense: true,
          title: Text(
            // '${bookmark.bookId} bookmark.info.name',
            book.name,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: 18,
              color: Colors.black,
              // height: 1.4
            )
          ),
          subtitle: Text(testament.name,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontSize: 14,
              color: Colors.grey[500]
            )
          ),
          trailing: Text(core.digit(bookmark.chapterId),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontSize: 18,
              color: Colors.grey[500]
              // height: 1.4
            )
          ),
          onTap: (){
            core.bookId = bookmark.bookId;
            core.chapterId = bookmark.chapterId;
            controller.master.bottom.pageChange(1);
          }
        ),
      ),
    );
  }

}
