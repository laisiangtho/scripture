import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/idea.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:bible/core.dart';
import 'package:bible/icon.dart';
import 'package:bible/type.dart';
import 'package:bible/widget.dart';

// part 'SuggestionView.dart';
// part 'DefinitionView.dart';
// part 'DefinitionNone.dart';
// part 'SuggestionNone.dart';
// part 'HomeView.dart';
// part 'HomeNone.dart';
// import 'demo.dart';

part 'bar.dart';
part 'view.dart';
part 'refresh.dart';
part 'modal.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  final scrollController = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  final viewNotifyNavigation = NotifyNavigationButton.navigation;

  final List<String> themeName = ["System","Light","Dark"];

  bool isSorting = false;

  // final List<int> _items = List<int>.generate(20, (int index) => index);
  // List<MapEntry<dynamic, BookType>> get _items => core.collection.boxOfBook.toMap().entries.toList();
  // List<BookType> get _items => core.collection.boxOfBook.toMap().values.toList();
  GlobalKey<SliverReorderableListState> _reorderablelistKey = GlobalKey<SliverReorderableListState>();

  late Core core;

  // late TextEditingController textController;
  // late FocusNode focusNode;
  // late String searchQuery;
  // final core = Core();

  @override
  void initState() {
    super.initState();
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';
    core = context.read<Core>();
    // Future.microtask(() {
    //   textController.text = core.suggestionQuery;
    // });

    // scrollController = ScrollController()..addListener(() {});
    focusNode.addListener(() {
      // if(focusNode.hasFocus) {
      //   textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      // }
      context.read<Core>().nodeFocus = focusNode.hasFocus;
    });

    // textController.addListener(() {
    //   final word = textController.text.replaceAll(RegExp(' +'), ' ').trim();
    //   core.suggestionQuery = word;
    // });
  }

  @override
  dispose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // String keyWords(String words) {
  //   return words.replaceAll(RegExp(' +'), ' ').trim();
  // }

  // void onCancel() {
  //   focusNode.unfocus();
  // }

  // void onSuggest(String str) {
  //   Future.microtask(() {
  //     // core.suggestionQuery = keyWords(str);
  //     // core.suggestionGenerate(keyWords(str));
  //   });
  // }

  // // NOTE: used in bar, suggest & result
  // void onSearch(String str) {
  //   final word = keyWords(str);
  //   this.focusNode.unfocus();

  //   Future.microtask(() {
  //     // context.read<Core>().definitionQuery = word;
  //     // context.read<Core>().definitionGenerate(word);
  //     // core.definitionGenerate(word);
  //   }).whenComplete(() {
  //     scrollController.animateTo(scrollController.position.minScrollExtent,
  //         curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 800));
  //   });

  //   Future.delayed(Duration.zero, () {
  //     core.historyAdd(word);
  //   });
  // }
  void toBible(BookType bible) async {
    // if (core.primaryId != bible.identify){
    //   setState(() {
    //     core.primaryId = bible.identify;
    //   });
    // }
    // controller.master.bottom.pageChange(1);
    if (Navigator.canPop(context)){

      if (core.collection.parallelId != bible.identify){
        core.collection.parallelId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message ='a momment please';
      }
      viewNotifyNavigation.value = 1;
      core.scriptureParallel.init().whenComplete(
        (){
          core.message ='';
        }
      );
      Navigator.of(context).pop();
    } else {
      if (core.collection.primaryId != bible.identify){
        core.collection.primaryId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message ='a momment please';
      }
      viewNotifyNavigation.value = 1;
      core.scripturePrimary.init().whenComplete(
        (){
          core.message ='';
        }
      );

      // Scripture scripture = core.scripturePrimary;
      // if (scripture.isReady) {
      //   if (core.message.isNotEmpty){
      //     core.message ='';
      //   }
      // } else {
      //   core.message ='a momment plase';
      // }
      // if (core.collection.primaryId != bible.identify){
      //   core.collection.primaryId = bible.identify;
      // }
      // debugPrint('reader: ${core.scripturePrimary.isReady}');
      // core.scripturePrimary.init().catchError((e){
      //   debugPrint('scripturePrimary: $e');
      // }).whenComplete(
      //   (){
      //     core.message ='';
      //     debugPrint('reader: done');
      //   }
      // );
    }
    // core.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
  }
}
