
// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// import '_DemoMenu.dart';

import 'SheetInfo.dart';
import 'Common.dart';
import 'StoreModel.dart';
import 'Home.dart';

class HomeView extends HomeState {

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return collection.book.indexWhere((CollectionBook d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = collection.book[draggingIndex];
    setState(() {
      // debugPrint("Reordering $item -> $newPosition");
      collection.book.removeAt(draggingIndex);
      collection.book.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    store.writeCollection();
    // final draggedItem = collection.book[_indexOfKey(item)];
    // debugPrint("Reordering finished for ${draggedItem.name}}");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // key: widget.scaffoldKey,
      key: scaffoldKey,
      body: ReorderableList(
        onReorder: _reorderCallback,
        onReorderDone: _reorderDone,
        child: FutureBuilder(
        future: store.getCollection(),
        builder: (BuildContext context, AsyncSnapshot<Collection> e){
          if (e.hasData){
            collectionGenerate(e);
            return _body();
          } else if (e.hasError) {
            return WidgetError(message: e.error);
          } else {
            return WidgetLoad();
          }
        })
      )
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: <Widget>[
        new SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: new WidgetHeaderSliver(bar,maxHeight: 140)
        ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: store.bottomBarHeightMax),
          sliver: new SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => BookItem(
                book: collection.book[index],
                isFirst: index == 0,
                isLast: index == collection.book.length - 1,
                isSorting: isSorting,
                showSheetInfo: showSheetInfo,
                showBibleView:toBible
              ),
              childCount: collection.book.length
            )
          )
        )
      ]
    );
  }
  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,0), stretch),
          child: Container(
            child: Text(
              store.appTitle,
              style: TextStyle(
                fontFamily: "sans-serif",
                // color: Color.lerp(Colors.white, Colors.white24, stretch),
                color: Colors.black,
                fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
                fontSize:35 - (18*stretch),
                // shadows: <Shadow>[
                //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
                // ]
              )
            )
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: isUpdating?SizedBox(width:20, height:20,
                child:CircularProgressIndicator(strokeWidth: 1)
              ):new Icon(CupertinoIcons.refresh_circled,color: Colors.grey),
              onPressed: updateCollectionCallBack
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: new Icon(Icons.sort,color: isSorting?Colors.red:Colors.grey),
              onPressed: (){
                if (isSorting) store.writeCollection();
                setState(() {
                  isSorting = !isSorting;
                });
              }
            ),
            // DemoMenu()
          ]
        )
      ]
    );
  }

  void showSheetInfo(CollectionBook book) {
    // widget.scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() {});
    scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) => SheetInfo(book)).closed.whenComplete(() => setState(() { }));
  }
}

class BookItem extends StatelessWidget {
  BookItem({
    this.book,
    this.isFirst,
    this.isLast,
    this.isSorting,
    this.showSheetInfo,
    this.showBibleView
  });

  final CollectionBook book;
  final bool isFirst;
  final bool isLast;
  final bool isSorting;
  final showSheetInfo;
  final showBibleView;

  bool get isAvailable => book.available > 0;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    // if (state == ReorderableItemState.dragProxy ||
    //     state == ReorderableItemState.dragProxyFinished) {
    //   // slightly transparent background white dragging (just like on iOS)
    //   decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    // } else {
    //   bool placeholder = state == ReorderableItemState.placeholder;
    //   decoration = BoxDecoration(
    //       border: Border(
    //         top: isFirst && !placeholder
    //             ? Divider.createBorderSide(context) //
    //             : BorderSide.none,
    //         bottom: isLast && placeholder
    //             ? BorderSide.none //
    //             : Divider.createBorderSide(context)
    //       ),
    //       // color: null
    //       // color: placeholder ? null : Colors.white
    //     );
    // }

    // For iOS dragging mdoe, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = isSorting
        ? ReorderableListener(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: new BoxDecoration(
              color: Color(0x08000000)
            ),
            child: Icon(Icons.reorder, color: Colors.red, size: 20)
          )
        ):Container();
    Widget _item = Container(
      decoration: decoration,
      // decoration: BoxDecoration(
      //   borderRadius: new BorderRadius.all(Radius.circular(7))
      // ),
      child: Opacity(
        // hide content for placeholder
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: IntrinsicHeight(
          child: new ListTile(
            // dense: true,
            // contentPadding: EdgeInsets.symmetric(horizontal: 25),
            // leading: CircleAvatar(
            //   child: Text(
            //     book.language.name.toUpperCase(),
            //     style: Theme.of(context).textTheme.subhead.copyWith(fontSize:14,color: Colors.white)
            //   ),
            //   backgroundColor: isAvailable?Colors.black26:Colors.grey[200],
            //   // foregroundColor: Colors.white,
            // ),
            title: Text(
              book.name, maxLines: 1, overflow: TextOverflow.ellipsis,textScaleFactor:0.7,
              style: Theme.of(context).textTheme.headline.copyWith(height: 0.8,color: isAvailable?Colors.black:Colors.grey)
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Icon(Icons.check_circle, color:isAvailable?Colors.green:Colors.grey[200], size: 15),
                // CircleAvatar(
                //   child: Text(
                //     book.language.name.toUpperCase(),
                //     style: Theme.of(context).textTheme.subhead.copyWith(fontSize:10,color: Colors.white)
                //   ),
                //   backgroundColor: isAvailable?Colors.black26:Colors.grey[200],
                //   foregroundColor: Colors.white,
                // ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAvailable?Colors.grey:Colors.grey[200]
                  ),
                  child: Text(
                    book.language.name.toUpperCase(),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                      color:isAvailable?Colors.white:Colors.black,
                      fontSize: 10
                    )
                  )
                ),
                Text(' '),
                // Icon(Icons.arrow_forward, color:Colors.grey[200], size: 15),
                Text(book.shortname,style: Theme.of(context).textTheme.subhead.copyWith(color:Colors.black,fontSize: 11)),
                // Text(' '),
                // Text(book.language.name.toUpperCase(),style: Theme.of(context).textTheme.subhead.copyWith(color:Colors.black,fontSize: 11)),
              ]
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(book.year.toString(),style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13,color: Colors.black)),
                Icon(Icons.arrow_forward_ios, color: isAvailable?Colors.black:Colors.grey[200], size: 20),
                dragHandle
              ]
            ),
            onTap:()=>isAvailable?showBibleView(book):showSheetInfo(book)
          )
        )
      )
    );
    // Slidable();
    return new Slidable(
      // delegate: new SlidableDrawerDelegate(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _item,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Info',
          // color: Colors.grey,
          // color: Colors.transparent,
          icon: Icons.info,
          foregroundColor: Colors.grey,
          onTap: ()=>showSheetInfo(book)
        )
      ]
    );
  }
  @override
  Widget build(BuildContext context) {
    return ReorderableItem( key: book.key, childBuilder: _buildChild);
  }
}
