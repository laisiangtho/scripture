part of 'main.dart';

class View extends _State with _Bar, _Refresh, _Info {

  bool reorderCallback(Key item, Key newPosition) {
    int _draggingIndex = _indexOfKey(item);
    int _newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (_newPositionIndex % 2 == 1) return false;

    final _draggedItem = collectionBibleList[_draggingIndex];
    setState(() {
      // debugPrint("Reordering $item -> $newPosition");
      collectionBibleList.removeAt(_draggingIndex);
      collectionBibleList.insert(_newPositionIndex, _draggedItem);
    });
    return true;
  }
  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return collectionBibleList.indexWhere((CollectionBible d) => ValueKey<String>(d.identify) == key);
  }

  void reorderDone(Key item) {
    core.writeCollection();
    // final draggedItem = collection.bible[_indexOfKey(item)];
    // debugPrint("Reordering finished for ${draggedItem.name}}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: ReorderableList(
          onReorder: this.reorderCallback,
          onReorderDone: this.reorderDone,
          decoratePlaceholder: (Widget item, double opacity){
            return DecoratedPlaceholder(widget: item, offset: opacity);
          },
          child: _reorder(),
        ),
      )
    );
  }

  Widget _reorder() {
    return ScrollPage(
      controller: controller,
      // depth:1,
      child: _view(),
    );
  }

  // Widget _nested() {
  //   return NestedScrollView(
  //     // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
  //       return <Widget>[
  //         new HomeBar(core: this),
  //         // new HomeRefresh(
  //         //   refresh: ()=>Future.delayed(Duration(seconds: 2)),
  //         //   controller: controller
  //         // ),
  //         // new SliverToBoxAdapter(child: Text('???'))
  //       ];
  //     },
  //     body: _view()
  //   );
  // }


  Widget _view() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      semanticChildCount: 3,
      slivers: <Widget>[
        sliverPersistentHeader(),
        sliverRefresh(),
        new SliverPadding(
          padding: EdgeInsets.only(top:7.0,bottom: MediaQuery.of(context).padding.bottom+5.0),
          sliver: SliverAnimatedList(
            key: sliverAnimatedListKey,
            // initialItemCount: collection.bible.length,
            initialItemCount: collectionBibleList.length,
            itemBuilder: booksItem
          )
        )
      ]
    );
  }

  Widget booksItem(BuildContext context, int index, Animation<double> animation){
    CollectionBible collectionBible = collectionBibleList[index];
    return new SlideableAnimatedList(
      key: ValueKey<String>(collectionBible.identify),
      animation: animation,
      // controller: animatedListController,
      menu: booksItemWidget(collectionBible),
      right: <Widget>[
        Tooltip(
          message: 'More',
          child: new CupertinoButton(
            child: new Icon(
              CustomIcon.dot_horiz,color: Colors.grey,
            ),
            onPressed: () => this.showInfo(collectionBible)
          ),
        )
      ]
    );
  }

  Widget booksItemWidget(CollectionBible collectionBible){
    bool isAvailable = collectionBible.available > 0;
    bool isPrimary = collectionBible.identify == core.primaryId;
    // bool isParallel = collectionBible.identify == core.parallelId;
    return ReorderableItem(
      key: ValueKey<String>(collectionBible.identify),
      childBuilder: (BuildContext context, ReorderableItemState state){
        // if (state == ReorderableItemState.dragProxy ||
        //     state == ReorderableItemState.dragProxyFinished) {
        //       backgroundColor = Theme.of(context).backgroundColor;
        // }
        Widget dragHandle = this.isSorting
          ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
              decoration: new BoxDecoration(
                color: Color(0x08000000)
              ),
              child: Icon(CustomIcon.drag_handle, color: Colors.red, size: 25.0)
            )
          ):Container();
        return Container(
          // padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
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
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: new ListTile(
                // dense: true,
                selected: isPrimary,
                enabled: true,
                title: Text(
                  collectionBible.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  semanticsLabel: collectionBible.name,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 20,
                    fontWeight: isAvailable?FontWeight.w400:FontWeight.w300,
                    // color: isAvailable?Colors.black:Colors.grey,
                    height: collectionBible.language.name=='my'?2.0:1.2
                  )
                  // style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18,color: isAvailable?Colors.black:Colors.grey)
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.all(5),
                      // width: 50.0,
                      constraints: BoxConstraints(
                        minWidth: 40.0,
                      ),
                      padding: EdgeInsets.symmetric(vertical:4),
                      // margin: EdgeInsets.only(top:5),
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // color: isAvailable?isCurrent?Colors.grey:Colors.grey[400]:Colors.grey[200]
                        color: isAvailable?isPrimary?Colors.black54:Colors.grey:Colors.grey[200]
                        // isCurrent?Colors.blue[300]:
                      ),
                      child: Text(
                        collectionBible.language.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:isAvailable?Colors.white:Colors.grey[400],
                          fontSize: 10,
                        )
                        // style: Theme.of(context).textTheme.caption.copyWith(
                        //   color:isAvailable?Colors.white:Colors.grey[400],
                        //   // fontSize: 10,
                        //   // height: 13
                        // )
                      )
                    ),
                    Text(' '),
                    Text(collectionBible.shortname,style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 15,
                        height: collectionBible.language.name=='my'?1.5:1.0
                      )
                    )
                  ]
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(collectionBible.year.toString(),
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 16,color: isAvailable?Colors.black:Colors.grey[400],
                        // fontWeight: FontWeight.w300,
                      )
                    ),
                    Icon(CustomIcon.right_open,color: isAvailable?Colors.grey:Colors.grey[200], size: 22),
                    dragHandle
                  ]
                ),
                onTap:()=>isAvailable?this.toBible(collectionBible):this.showInfo(collectionBible)
              )
            )
          )
        );
      }
    );
  }
}