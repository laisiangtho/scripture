// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/component/scroll.dart';
import 'package:bible/avail.dart';
import 'SearchView.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SearchView();
}

abstract class SearchState extends State<Search> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Search> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final store = Store();
  final int _id = 3;
  // TickerProviderStateMixin, SingleTickerProviderStateMixin
  final controller = ScrollController();
  TextEditingController textController;

  double get offset => store.offset[_id]??0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // controller = ScrollController(
    //   // initialScrollOffset: offset,
    //   // keepScrollOffset: true
    // )..addListener(() {
    //   // store.offset[_id] = controller.position.pixels;
    // });

    textController = TextEditingController(
     text: store.searchQuery
    )..addListener(() {
      setState(() {});
    });



    // controller.master.bottom.heightToggle(true);
    store.focusNode.addListener(() {
      // setState(() {});
      // print('?? ${store.focusNode.hasFocus}');
      controller.master.bottom.toggle(store.focusNode.hasFocus);
      // if(store.focusNode.hasFocus) {
      //   controller.master.bottom.heightNotify.value=0.0;
      // } else {
      //   controller.master.bottom.heightNotify.value=1.0;
      // }

    });
    // textController.
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
    textController.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  // @override
  // void didChangeMetrics() {
  //   store.analyticsSearch(store.searchQuery);
  // }

  String get suggestQuery => this.textController.text;
  // String get searchQuery => store.searchQuery;

  // void showKeyboard() => FocusScope.of(context).requestFocus(store.focusNode);
  void hideKeyboard() => store.focusNode.unfocus();
  void inputClear() => textController.clear();
  void inputCancel() => hideKeyboard();
  void inputSubmit(String word) => store.searchQuery = word;

}
