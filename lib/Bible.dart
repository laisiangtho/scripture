import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'StoreModel.dart';
import 'Store.dart';
import 'BibleView.dart';


class Bible extends StatefulWidget {
  Bible({
    Key key
  }) : super(key: key);

  @override
  BibleView createState() => new BibleView();
}

abstract class BibleState extends State<Bible> with TickerProviderStateMixin{
  PersistentBottomSheetController<void> bottomSheetOption;
  GlobalKey keyBookButton = new GlobalKey();
  GlobalKey keyChapterButton = new GlobalKey();
  NAME activeName;
  List<String> selectedVerse=[];

  bool isChapterBookmarked=false;

  Store store = new Store();

  @override
  void initState() {
    // selectedVerse.clear();
    store.scrollController?.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void updateState() => setState((){});

  void collectionGenerate (e) => activeName = e.data;

  void isCollectionBookmark () {
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
      store.scrollController.animateTo(
        store.scrollController.position.minScrollExtent,
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