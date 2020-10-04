import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

import 'package:share/share.dart';

import 'package:bible/core.dart';
import 'package:bible/component.dart';
import 'package:bible/widget.dart';
import 'package:bible/icon.dart';

import 'package:bible/view/home/main.dart' as Home;

part 'view.dart';
part 'bar.dart';
part 'bottomSheet.dart';
part 'bottomSheetParallel.dart';
// part 'bottomSheetMenu.dart';
// part 'bottomSheetAudio.dart';
part 'gesture.dart';
part 'option.dart';
part 'book.dart';
part 'chapter.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  View createState() => new View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  final core = Core();
  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();

  final keyBottom = new GlobalKey();
  final keyBookButton = new GlobalKey();
  final keyChapterButton = new GlobalKey();
  final keyOptionButton = new GlobalKey();
  final keyListView = new GlobalKey();

  List<int> verseSelectionList = new List();
  bool hasBookmark = false;
  String primaryId = '';

  Future<bool> _dataResult;
  Future<bool> get getResult => _dataResult=hasNotResult?_newResult:_dataResult;
  Future<bool> get _newResult async => core.versePrimaryChapter().then((value) async{
    hasBookmark = await core.hasBookmark();
    if (primaryId != core.primaryId){
      primaryId = core.primaryId;
      core.analyticsBible();
    }
    setState(() {});
    return hasNotResult == false;
  });

  // Future<BIBLE> get getResultParallel async => core.verseParallelChapter();

  // Future<bool> _newResult() async{
  //   // await core.verseChapter();
  //   // hasBookmark = await core.hasBookmark();
  //   // if (identify != core.identify){
  //   //   identify = core.identify;
  //   //   core.analyticsBible();
  //   // }
  //   // setState(() {});
  //   // return hasNotResult == false;
  // }

  bool get hasNotResult => core.scripturePrimary.verseChapterDataIsEmpty(
    id: core.primaryId,
    testament: core.testamentId,
    book: core.bookId,
    chapter: core.chapterId
  );
  bool get isNotReady => hasNotResult && core.scripturePrimary.notReady();

  BIBLE get bible => core.scripturePrimary.verseChapterData;
  // bool get hasNotResult => core.verseChapterDataIsEmpty();
  // bool get isNotReady => hasNotResult && core.userBible == null && core.userBibleList.length == 0;

  // BIBLE get bible => core.verseChapterData;
  CollectionBible get bibleInfo => core.collectionPrimary;
  // CollectionBible get tmpbible => bible?.info;
  DefinitionBook get tmpbook => bible?.book?.first?.info;
  CHAPTER get tmpchapter => bible?.book?.first?.chapter?.first;
  List<VERSE> get tmpverse => tmpchapter?.verse;

  void _localNameAndChapterRefresh() {
    getResult.whenComplete(() {
      setState(() {});
      core.analyticsReading();
    });
    controller.animateTo(
      controller.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300)
    );
  }

  // int _tmpIndex = 0;
  void setChapterPrevious() {
    core.chapterPrevious.then((_){
      _localNameAndChapterRefresh();
    }).catchError((e){
      showSnack(e.toString());
    });
    // _tmpIndex--;
    // if (_tmpIndex < 0) _tmpIndex = 0;
    // scrollToIndex(_tmpIndex);
    // controller.master.bottom.toggle(false);
  }

  void setChapterNext() {
    core.chapterNext.then((_){
      _localNameAndChapterRefresh();
    }).catchError((e){
     showSnack(e.toString());
     print(e);
    });

    // _tmpIndex++;
    // if (_tmpIndex > (tmpverse.length-1)) _tmpIndex = 0;
    // scrollToIndex(_tmpIndex);
    // controller.master.bottom.toggle(true);
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
      showSnack(e.toString());
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

  void verseSelectionCopy() {
    List<String> list = [];
    String subject = tmpbook.name+' '+tmpchapter.name;
    list.add(subject);
    this.verseSelectionList..sort((a, b) => a.compareTo(b))..forEach((id) {
      VERSE o = tmpverse.where((i)=> i.id == id).single;
      list.add(o.name+': '+o.text);
    });
    // Clipboard.setData(new ClipboardData(text: list.join("\n"))).whenComplete((){
    //   showSnack('Copied to Clipboard');
    // });
    Share.share(list.join("\n"), subject: subject);
  }

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

  void showSnack(String message){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds:500),
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: Colors.grey,
      )
    );
  }


  Future scrollToIndex(int id,{bool isId:false}) async {
    double scrollTo = 40.0;
    if (id > 0) {
      final offsetList = tmpverse.where(
        // (e) => tmpverse.indexOf(e) < index
        (e) => isId?e.id < id:tmpverse.indexOf(e) < id
      ).map<double>((e) => e.key.currentContext?.size?.height);
      if (offsetList.length > 0){
        scrollTo = offsetList.reduce((a,b )=>a+b) + scrollTo;
      }
    }
    controller.animateTo(scrollTo, duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  void initState(){
    super.initState();
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
