import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:bible/core.dart';
import 'package:bible/widget.dart';
import 'package:bible/icon.dart';
import 'package:bible/type.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;
  late FutureOr<DefinitionBible> initiator;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    initiator = core.scripturePrimary.init();
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void onClearAll(){
    // Future.microtask((){
    //   core.bookmarkClearNotify();
    // });
    // final bool? confirmation = await doConfirmWithDialog(
    //   context: context,
    //   message: 'Do you want to delete this Bookmark?'
    // );
    // if (confirmation != null && confirmation){
    //   onDelete(index);
    //   return true;
    // }
    doConfirmWithDialog(
      context: context,
      message: 'Do you want to delete all Bookmarks?'
    ).then((confirmation) {
      if (confirmation != null && confirmation){
        core.bookmarkClearNotify();
      }
    });
  }

  void onNav(int book, int chapter){
    NotifyNavigationButton.navigation.value = 1;
    Future.delayed(const Duration(milliseconds: 150), () {
      // core.definitionGenerate(word);
      core.chapterChange(bookId: book, chapterId: chapter);
    });
    // Future.delayed(Duration.zero, () {
    //   core.historyAdd(word);
    // });
  }

  void onDelete(int index){
    // Future.microtask((){});
    Future.delayed(Duration.zero, () {
      core.collection.bookmarkDelete(index);
    });
  }
}

class View extends _State with _Bar {

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<DefinitionBible>(
    //   future: initiator,
    //   builder: (BuildContext context, AsyncSnapshot<DefinitionBible> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         return reader();
    //       default:
    //         return WidgetMsg(message: 'A moment',);
    //     }
    //   }
    // );
    return reader();
  }

  Widget reader() {
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: body()
    );
  }

  Widget body() {
    return CustomScrollView(
      // controller: scrollController,
      primary: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        bar(),
        // new SliverToBoxAdapter(
        //   child: Text('abc')
        // ),
        // Selector<Core,String>(
        //   selector: (_, e) => e.store.message,
        //   builder: (BuildContext context, String message, Widget? child) {
        //     return ElevatedButton(
        //        child: Text('Message: $message'),
        //        onPressed: (){
        //          context.read<Core>().store.testUpdate('Yes');
        //        }
        //     );
        //   }
        // )
        Selector<Core,List<MapEntry<dynamic, BookmarkType>>>(
          selector: (_, e) => e.collection.boxOfBookmark.toMap().entries.toList(),
          builder: (BuildContext context, List<MapEntry<dynamic, BookmarkType>> items, Widget? child) {
            if (items.length > 0){
              return listContainer(items);
            }
            return messageContainer();
          }
        ),
      ]
    );
  }

  Widget messageContainer(){
    return new SliverFillRemaining(
      child: WidgetMsg(message: 'No Bookmarks',),
    );
  }

  SliverList listContainer(Iterable<MapEntry<dynamic, BookmarkType>> box){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => itemContainer(index, box.elementAt(index)),
        childCount: box.length>30?30:box.length
      )
    );
  }

  // Widget itemContainer(int index,MapEntry<dynamic, BookmarkType> history){
  //   return Card(
  //     child: Text('index $index'),
  //   );
  // }

  Dismissible itemContainer(int index,MapEntry<dynamic, BookmarkType> bookmark){
    final abc = core.scripturePrimary.bookById(bookmark.value.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(bookmark.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: decoration(
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          title: Text(
            // history.value.word,
            abc.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              // color: Theme.of(context).textTheme.caption!.color,
              color: Theme.of(context).primaryTextTheme.button!.color,

              fontWeight: FontWeight.w300
            ),
          ),
          minLeadingWidth : 10,
          leading: Icon(Icons.bookmark_added),
          // leading: CircleAvatar(
          //   // radius:10.0,
          //   // backgroundColor: Colors.grey.shade800,
          //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //   child: Text(NumberFormat.compact().format(history.value.hit),textAlign: TextAlign.center,),
          // ),
          trailing:Chip(
            // avatar: CircleAvatar(
            //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   backgroundColor: Colors.transparent,
            //   // child: Icon(Icons.sticky_note_2_outlined, color: Theme.of(context).primaryColor,),
            //   child: Text('#',style: TextStyle(color: Theme.of(context).primaryColor,),),
            // ),
            avatar: Text(core.scripturePrimary.digit(bookmark.value.chapterId)),
            label: Text(core.scripturePrimary.digit(abc.chapterCount)),
          ),
          onTap: ()=> onNav(bookmark.value.bookId,bookmark.value.chapterId)
        )
      ),
      background: dismissiblesFromRight(),
      // secondaryBackground: dismissiblesFromLeft(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Do you want to delete "${history.value.word}"?
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            message: 'Do you want to delete this Bookmark?'
          );
          if (confirmation != null && confirmation){
            onDelete(index);
            return true;
          }
          return false;
        } else {
          // Navigate to edit page;
        }
      }
    );
  }

  Widget decoration({required Widget child}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      // margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.1,
            offset: Offset(0.0, .0)
          )
        ]
      ),
      child:child
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      // color: Theme.of(context).highlightColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Icon(
            //   Icons.delete,
            //   color: Colors.white,
            // ),
            Text(
              "Delete",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
