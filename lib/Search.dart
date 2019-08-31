import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'StoreModel.dart';
// import 'Store.dart';
// import 'Common.dart';

export 'StoreModel.dart';
export 'Common.dart';

import 'Store.dart';

import 'SearchView.dart';


class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  SearchView createState() => new SearchView();
}

abstract class SearchState extends State<Search> with TickerProviderStateMixin, WidgetsBindingObserver{

  final TextEditingController textController = TextEditingController();
  Store store = new Store();

  @override
  void initState() {
    textController.text = store.searchQuery;
    textController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addObserver(this);
    store.focusNode.addListener((){
      if(store.focusNode.hasFocus) {
        textController.selection = TextSelection(baseOffset: 0, extentOffset: textController.text.length);
      }
    });
    store.analyticsScreen('search','SearchState');
    super.initState();
  }

  @override
  dispose() {
    textController.removeListener(() => setState(() {}));
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  @override
  void didChangeMetrics() {
    store.analyticsSearch(store.searchQuery);
  }

  String get suggestQuery => this.textController.text;
  // String get searchQuery => store.searchQuery;

  void hideKeyboard() => store.focusNode.unfocus();
  void showKeyboard() => FocusScope.of(context).requestFocus(store.focusNode);
  void inputClear() => textController?.clear();
  void inputCancel() => hideKeyboard();
  void inputSubmit(String word) => store.searchQuery = word;

}