import 'package:flutter/material.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-persistent';
  static String label = 'Persistent';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  @override
  bool get persistent => true;

  @override
  double get height => kTextTabBarHeight;

  Core get core => App.core;
  Preference get preference => App.preference;
  Scripture get primaryScripture => core.scripturePrimary;
  ScrollController? get primaryScroll => primaryScripture.scroll;
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  // void setChapter(int? id) {
  //   if (id == null) return;
  //   core.chapterChange(chapterId: id).catchError((e) {
  //     showSnack(e.toString());
  //   }).whenComplete(() {
  //     scrollToPosition(0);
  //   });
  // }

  void setChapterPrevious() {
    core.chapterPrevious.catchError((e) {
      showSnack(e.toString());
    });
  }

  void setChapterNext() {
    core.chapterNext.catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  late final RouteNotifier notifier = RouteNotifier();

  // void copyVerseSelection() {
  //   primaryScripture.getSelection().then(Share.share);
  // }

  @override
  List<Widget> slivers() {
    Map<String, dynamic> nestArguments = {
      'presistentToggle': scrollToggle,
    }..addAll(state.asMap);

    return <Widget>[
      SliverFillRemaining(
        // hasScrollBody: false,
        // fillOverscroll: true,
        child: NestedView(
          delegate: PersistentDelegates(
            bridge: notifier,
            name: rootPath(Main.route),
            // arguments: state.arguments,

            arguments: nestArguments,
          ),
        ),
      ),
    ];
  }
}
