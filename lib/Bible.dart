import 'package:flutter/material.dart';

// import 'dart:math' as math;
// import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
// import 'dart:ui';
// import 'package:meta/meta.dart';

import 'StoreModel.dart';
import 'Store.dart';
import 'BibleView.dart';


class Bible extends StatefulWidget {
  Bible({
    Key key,
    this.scrollController,
    this.offset,
  }) : super(key: key);

  final ScrollController scrollController;
  final double offset;

  @override
  BibleView createState() => new BibleView();
}

abstract class BibleState extends State<Bible> with TickerProviderStateMixin{
  PersistentBottomSheetController<void> bottomSheetOption;
  NAME activeName;
  List<String> selectedVerse=[];
  double shrinkOffsetPercentage=1.0;

  bool isChapterBookmarked=false;

  Store store = new Store();

  @override
  void initState() {
    // selectedVerse.clear();
    widget.scrollController?.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // widget.scrollController?.removeListener(updateState);
    // scrollController?.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void updateState() => setState((){});

  void collectionGenerate (e) => activeName = e.data;

  void isCollectionBookmark () {
    // print('what?');
    store.hasCollectionBookmark().then((yes){
      setState(() {
        isChapterBookmarked = yes;
      });
    });
  }

  void setPreviousChapter() {
    store.chapterPrevious.then((_){
      updateState();
    });
    setScroll();
  }
  void setNextChapter() {
    store.chapterNext.then((_){
      updateState();
    });
    setScroll();
  }
  void setBookChapter(int id) {
    if (id == null) return;
    store.chapterBook(id).then((_){
      updateState();
    });
    setScroll();
  }
  void setChapter(int id) {
    if (id == null) return;
    // store.chapterId = id;
    // Navigator.of(context).pushNamed('bible');
    // Navigator.of(context).pushReplacementNamed('bible');
    // Navigator.of(context).popAndPushNamed('bible');
    // Navigator.of(context).pop('Accept');
    setState(() {
      store.chapterId = id;
    });
    selectedVerse.clear();
    setScroll();
  }
  void setScroll() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }
  get getSelectedVerse {
    List<String> list = [];
    return store.verseChapter.then((List<VERSE> e){
      this.selectedVerse..sort((a, b) => a.compareTo(b))..forEach((id) {
        var o = e.where((i)=> i.verse == id).single;
        list.add(o.verse+': '+o.verseText);
      });
      return list.join("\n");
    });
  }
}