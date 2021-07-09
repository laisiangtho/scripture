import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:bible/core.dart';
import 'package:bible/widget.dart';
import 'package:bible/icon.dart';
import 'package:bible/type.dart';
import 'package:bible/inherited.dart';

part 'bar.dart';
part 'suggest.dart';
part 'result.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;
  late Future<DefinitionBible> initiator;

  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  String previousQuery ='';
  BIBLE get bible => core.scripturePrimary.verseSearch;
  bool get shrinkResult => bible.verseCount > 300;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    initiator = core.scripturePrimary.init();
    previousQuery = core.collection.searchQuery;
    Future.microtask(() {
      textController.text = previousQuery;
    });
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';

    // scrollController = ScrollController()..addListener(() {});
    focusNode.addListener(() {
      // if(focusNode.hasFocus) {
      //   textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      // }
      // context.read<Core>().nodeFocus = focusNode.hasFocus;
      core.nodeFocus = focusNode.hasFocus;
    });

    // textController.addListener(() {
    //   // suggestionQuery = textController.text.replaceAll(RegExp(' +'), ' ').trim();
    //   // core.collection.searchQuery = suggestionQuery;
    //   // core.suggestionQuery = suggestionQuery;
    //   core.notify();
    //   // debugPrint('textupdate $suggestionQuery');
    // });

  }


  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // String keywordTrim(String words) {
  //   return words.replaceAll(RegExp(' +'), ' ').trim();
  // }

  String get searchQuery => core.collection.searchQuery;
  set searchQuery(String str) {
    core.collection.searchQuery = str.replaceAll(RegExp(' +'), ' ').trim();
    core.notify();
  }

  bool onDelete(String str) => core.collection.historyDeleteByWord(str);

  void onClear() {
    textController.clear();
    searchQuery = '';
  }

  void onCancel() {
    searchQuery = previousQuery;
    textController.text = searchQuery;
    focusNode.unfocus();
  }

  void onSuggest(String str) {
    // Future.microtask(() {
    //   // core.suggestionQuery = keyWords(str);
    //   // core.suggestionGenerate(keyWords(str));
    // });
    // String word = keywordTrim(str);
    // core.searchQuery = word;
    // core.collection.searchQuery = word;
    // core.notify();
    searchQuery = str;
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    searchQuery = str;
    previousQuery = str;
    // core.collection.searchQuery = previousQuery;
    this.focusNode.unfocus();
    if (textController.text != str) {
      textController.text = str;
    }

    Future.microtask(() {
      // context.read<Core>().definitionQuery = word;
      // context.read<Core>().definitionGenerate(word);
      // core.definitionGenerate(word);
    }).whenComplete(() {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 800));
    });

    Future.delayed(Duration.zero, () {
      core.collection.historyUpdate(searchQuery);
    });
    core.analyticsSearch(searchQuery);
  }

  void onNav(int book, int chapter) {
    // debugPrint('book $book chapter $chapter');
    NotifyNavigationButton.navigation.value = 1;
    // core.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      core.chapterChange(bookId: book, chapterId: chapter);
    });
  }
}

class View extends _State with _Bar, _Suggest, _Result {

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
      child: Selector<Core,bool>(
        selector: (_, e) => e.nodeFocus,
        builder: (BuildContext context, bool focus, Widget? child) => scroll(),
      )
    );
  }

  Widget scroll() {
    return CustomScrollView(
      controller: scrollController,
      // primary: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        bar(),
        body()
        // _suggestNoQuery()
      ]
    );
  }

  Widget body(){
    return VerseInheritedWidget(
      size: core.collection.fontSize,
      lang: core.scripturePrimary.info.langCode,
      child: focusNode.hasFocus?suggest():result()
    );
  }

}
