import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bible/component.dart';
import 'package:bible/widget.dart';
import 'package:bible/core.dart';
import 'package:bible/icon.dart';

part 'view.dart';
part 'bar.dart';
part 'suggest.dart';
part 'result.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final core = Core();
  final controller = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  Future<bool> _dataResult;
  Future<bool> get getResult => _dataResult=hasNotResult?_newResult():_dataResult;
  Future<bool> _newResult() async{
    await core.versePrimarySearch();
    return hasNotResult == false;
  }

  // Future<BIBLE> getResult() => core.verseSearch();
  // bool get hasNotResult => core.scripturePrimary.verseSearchDataIsEmpty();

  bool get hasNotResult => core.scripturePrimary.verseSearchDataIsEmpty(
    id: core.primaryId,
    testament: core.testamentId,
    book: core.bookId,
    chapter: core.chapterId,
    query: core.searchQuery
  );
  BIBLE get bible => core.scripturePrimary.verseSearchData;
  bool get shrinkResult => bible.verseCount > 300;

  CollectionBible get bibleInfo => core.collectionPrimary;
  List<CollectionKeyword> get keywords => core.collection.keyword;
  List<CollectionKeyword> get keywordSuggestion {
    if (searchQuery.isEmpty){
      return this.keywords;
    } else {
      return this.keywords.where((e)=>e.word.toLowerCase().startsWith(searchQuery.toLowerCase())).toList();
    }
  }

  void toBible(int bookId, int chapterId) {
    core.bookId = bookId;
    core.chapterId = chapterId;
    controller.master.bottom.pageChange(1);
  }

  String get searchQuery => this.textController.text??'';
  // void showKeyboard() => FocusScope.of(context).requestFocus(focusNode);
  void showKeyboard() => focusNode.requestFocus();
  // FocusScope.of(context).unfocus()
  void hideKeyboard() => focusNode.unfocus();
  void inputClear() => textController.clear();
  void inputCancel() => hideKeyboard();
  void inputSubmit(String word) {
    hideKeyboard();
    // core.searchQuery = word;
    this.textController.text = word;
    core.searchQuery = word;
    core.analyticsSearch(this.searchQuery);
  }

  @override
  void initState() {
    super.initState();
    textController.text = core.searchQuery;
    textController.addListener(() {
      setState(() {
        core.searchQuery = searchQuery;
      });
    });
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    controller.dispose();
    focusNode.dispose();
    textController.dispose();
    // textNotifier.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

}
