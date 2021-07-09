// import 'dart:math';

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
// import 'package:lidea/idea.dart';

import 'package:bible/core.dart';
import 'package:bible/widget.dart';
import 'package:bible/icon.dart';
import 'package:bible/type.dart';
import 'package:bible/inherited.dart';

import 'package:bible/view/home/main.dart' as Home;

part 'bar.dart';
part 'view.dart';
part 'sheet.dart';
part 'sheetParallel.dart';
part 'booklist.dart';
part 'chapterlist.dart';
part 'optionlist.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  late Core core;
  // late Future<DefinitionBible> initiator;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  // final keySheet = new GlobalKey();
  final keyBookButton = new GlobalKey();
  final keyChapterButton = new GlobalKey();
  final keyOptionButton = new GlobalKey();

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    // initiator = core.scripturePrimary.init();
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

  // DefinitionBible get bibleInfo => core.collectionPrimary;
  BIBLE get bible => core.scripturePrimary.verseChapter;
 // BIBLE get bible => core.verseChapterData;
  // CollectionBible get tmpbible => bible?.info;
  DefinitionBook get tmpbook => bible.book.first.info;
  CHAPTER get tmpchapter => bible.book.first.chapter.first;
  List<VERSE> get tmpverse => tmpchapter.verse;

  void setChapterPrevious() {
    core.chapterPrevious.catchError((e){
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setChapterNext() {
    core.chapterNext.catchError((e){
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setChapter(int? id) {
    if (id == null) return;
    core.chapterChange(chapterId: id).catchError((e){
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setFontSize(bool increase) {
    double size = core.collection.fontSize;
    if (increase){
      size++;
    } else {
      size--;
    }
    setState(() {
      core.collection.fontSize = size.clamp(10.0, 40.0);
    });
  }

  List<int> verseSelectionList = [];
  // verseSelection verseSelectionList
  void verseSelection(int id) {
    // debugPrint('selectVerse from it parent $id');
    int index = verseSelectionList.indexWhere((i) => i == id);
    if (index >= 0){
      verseSelectionList.removeAt(index);
    } else {
      verseSelectionList.add(id);
    }
    setState(() {});
  }
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
    debugPrint('share???');
  }

  void showSnack(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds:500)
      )
    );
  }

  scrollToPosition(double? pos)  {
    if (pos == null){
      pos = scrollController.position.minScrollExtent;
    }
    scrollController.animateTo(pos, duration: new Duration(milliseconds: 700), curve: Curves.ease);
  }
  Future scrollToIndex(int id,{bool isId:false}) async {
    double scrollTo = 22.0;
    if (id > 0) {
      final offsetList = tmpverse.where(
        // (e) => tmpverse.indexOf(e) < index
        // (e) => isId?e.id < id:tmpverse.indexOf(e) < id
        (e) => e.id < id
      ).map<double>((e) {
        final key = e.key as GlobalKey;
        if (key.currentContext != null){
          final render = key.currentContext!.findRenderObject() as RenderBox;
          return render.size.height;
        }
        return 0.0;
      });
      if (offsetList.length > 0){
        scrollTo = offsetList.reduce((a,b )=>a+b) + scrollTo;
      }

      debugPrint('scrollTo: $scrollTo');
    }

    scrollToPosition(scrollTo);
    // scrollController.animateTo(scrollTo, duration: new Duration(milliseconds: 700), curve: Curves.ease);
    // Scrollable.ensureVisible(abc.key.currentContext);
  }
}