import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends SheetStates<Main> {
  @override
  late final persistent = true;

  @override
  double get height => kTextTabBarHeight - 7;

  late final Map<String, dynamic> extra = {
    'scrollToggle': scrollToggle,
  }..addAll(state.param.map);

  late final parallelConfig = app.route.parallelConfig(extra: extra);
  // late final parallelConfig = app.route.parallelConfig();

  // Scripture get primaryScripture => app.scripturePrimary;
  // ScrollController? get primaryScroll => primaryScripture.scroll;
  // List<OfVerse> get primaryVerse => primaryScripture.verse;

  // void setChapter(int? id) {
  //   if (id == null) return;
  //   core.chapterChange(chapterId: id).catchError((e) {
  //     showSnack(e.toString());
  //   }).whenComplete(() {
  //     scrollToPosition(0);
  //   });
  // }

  // void setChapterPrevious() {
  //   app.chapterPrevious.catchError((e) {
  //     showSnack(e.toString());
  //   });
  // }

  // void setChapterNext() {
  //   app.chapterNext.catchError((e) {
  //     showSnack(e.toString());
  //   });
  // }

  // void showSnack(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  // void copyVerseSelection() {
  //   primaryScripture.getSelection().then(Share.share);
  // }

  @override
  List<Widget> slivers() {
    return <Widget>[
      SliverFillRemaining(
        // hasScrollBody: false,
        // fillOverscroll: true,
        child: parallelConfig,
      ),
    ];
  }
}
