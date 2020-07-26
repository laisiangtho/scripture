import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bible/core.dart';
import 'package:bible/component.dart';
import 'package:bible/widget.dart';

/// start/nav: 1234567
/// setstate: 167
/// keepAlive: 7

part 'view.dart';
part 'bar.dart';
part 'bottom.dart';
part 'gesture.dart';
part 'option.dart';
part 'book.dart';
part 'chapter.dart';

class Main extends StatefulWidget {

  // static of context.findAncestorStateOfType<State<View>>();
  // static FrogColor of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<FrogColor>();
  // static State<Main> of(BuildContext context) => context.findAncestorStateOfType<View>();
  // static State<Main> of(BuildContext context) => context.findAncestorStateOfType<View>();
  static bool of(BuildContext context) => View().hasNotResult;

  Main({Key key}) : super(key: key);
  @override
  View createState() => new View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  final core = Core();
  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();

  final keyBookButton = new GlobalKey();
  final keyChapterButton = new GlobalKey();
  final keyOptionButton = new GlobalKey();

  List<int> verseSelectionList = new List();
  bool hasBookmark = false;

  Future<BIBLE> _dataResult;
  Future<BIBLE> getResult() => _dataResult=hasNotResult?_newResult:_dataResult;
  Future<BIBLE> get _newResult => core.verseChapter().whenComplete((){
    core.hasBookmark().then((value) {
      setState(() {
        hasBookmark = value;
      });
      core.analyticsBible(bible.book.first.info);
    });
  });

  BIBLE get bible => core.verseChapterBible;
  bool get hasNotResult => core.verseChapterBibleIsEmpty();
  bool get isNotReady => hasNotResult && core.userBible == null && core.userBibleList.length == 0;

  CollectionBible get bibleInfo => core.getCollectionBible;
  CollectionBible get tmpbible => bible?.info;
  DefinitionBook get tmpbook => bible?.book?.first?.info;
  CHAPTER get tmpchapter => bible?.book?.first?.chapter?.first;
  List<VERSE> get tmpverse => bible?.book?.first?.chapter?.first?.verse;

  void _localNameAndChapterRefresh() {
    getResult().whenComplete(() {
      core.analyticsRead();
    });
    controller.animateTo(
      controller.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300)
    );
  }

  void setChapterPrevious() {
    core.chapterPrevious.then((value){
      _localNameAndChapterRefresh();
    }).catchError((e){
      print('setChapterPrevious $e');
    }).whenComplete((){

    });
  }

  void setChapterNext() {
    core.chapterNext.then((value){
      _localNameAndChapterRefresh();
    }).catchError((e){
      print('setChapterNext $e');
    });
  }

 void setChapter(int id) {
    if (id == null) return;
    core.chapterId = id;
    _localNameAndChapterRefresh();
  }

  void setBook(int id) {
    if (id == null) return;
    core.chapterBook(id).then((value){
      _localNameAndChapterRefresh();
    }).catchError((e){
      // print('chapterBook $e');
    });
  }

  // verseSelection verseSelectionList
  void verseSelection(int id) {
    // print('selectVerse from it parent $id');
    int index = verseSelectionList.indexWhere((i) => i == id);
    if (index >= 0){
      verseSelectionList.removeAt(index);
    } else {
      verseSelectionList.add(id);
    }
    setState(() {});
  }

  // Future<void> getSelectedVerse () {
  //   // List<String> list = [];
  //   // return store.getVerseChapter.then((List<VERSE> e){
  //   //   this.selectedVerse..sort((a, b) => a.compareTo(b))..forEach((id) {
  //   //     var o = e.where((i)=> i.verse == id).single;
  //   //     list.add(o.verse+': '+o.verseText);
  //   //   });
  //   //   return list.join("\n");
  //   // });
  //   // this.getSelectedVerse.then((e){
  //   //   Clipboard.setData(new ClipboardData(text: e)).whenComplete((){
  //   //   });
  //   // });
  //   // VERSE verse = verseList[index];
  //   // bool isSelected = selectedVerse.indexWhere((i)=>i==verse.verse) >= 0;
  //   // selectedVerse.remove(verse.verse);
  //   // selectedVerse.add(verse.verse);

  //   // return core.getChapterCurrent.then((DeleteChapterTmp chapter){
  //   //   this.selectedVerse..sort((a, b) => a.compareTo(b))..forEach((id) {
  //   //     var o = chapter.listVerse.where((i)=> i.verse == id).single;
  //   //     list.add(o.verse+': '+o.verseText);
  //   //   });
  //   //   return list.join("\n");
  //   // });
  // }

  void setFontSize(bool increase) {
    double tmp = core.fontSize;
    if (increase){
      tmp++;
    } else {
      tmp--;
    }
    setState(() {
      core.fontSize = tmp.clamp(10.0, 40.0);
    });
  }

  void setBookmark(){
    if (isNotReady) return null;
    core.addBookmarkTest().then((value) {
      setState(() {
        hasBookmark = value;
      });
    });
  }
  void showBookList(){
    if (isNotReady) return null;
    Navigator.of(context).push(PageRouteBuilder<int>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      // barrierColor: Colors.white.withOpacity(0.3),
      pageBuilder: (BuildContext context,x, y) => PopBookList(
        mainContext: keyBookButton.currentContext.findRenderObject()
      )
    )).then((e){
      setBook(e);
    });
  }

  void showChapterList(){
    if (isNotReady) return null;
    Navigator.of(context).push(PageRouteBuilder<int>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      // barrierColor: Colors.white.withOpacity(0.3),
      pageBuilder: (BuildContext context,x, y) => PopChapterList(
        mainContext: keyChapterButton.currentContext.findRenderObject(),
        bible: bible,
      )
    )).then((e){
      setChapter(e);
    });
  }

  void showOptionList(){
    if (isNotReady) return null;
    Navigator.of(context).push(PageRouteBuilder<int>(
      opaque: false,
      barrierDismissible: true,
      transitionsBuilder: (BuildContext _, Animation<double> x, Animation<double> y, Widget child) => new FadeTransition(opacity: x, child: child),
      pageBuilder: (BuildContext _,x, y) => PopOptionList(
        mainContext: keyOptionButton.currentContext.findRenderObject(),
        setFontSize: setFontSize,
      )
    )).whenComplete((){
      core.writeCollection();
    });
  }

  @override
  void initState(){
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){});
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

}
