import 'package:flutter/material.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/share.dart';
import 'package:lidea/icon.dart';

import '/widget/verse.dart';
import '../../../app.dart';

part 'content.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-parallel';
  static String label = 'Parallel';
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
  double get height => 48;

  Core get core => App.core;
  Preference get preference => App.preference;

  Scripture get primaryScripture => core.scripturePrimary;
  ScrollController get primaryScroll => primaryScripture.scroll;
  List<VERSE> get primaryVerse => primaryScripture.verse;

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

  void copyVerseSelection() {
    primaryScripture.getSelection().then(Share.share);
  }

  @override
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        // heights: const [kToolbarHeight],
        heights: [height],
        // backgroundColor: theme.primaryColor,
        // backgroundColor: theme.primaryColor,
        // overlapsBorderColor: theme.shadowColor,
        overlapsBorderColor: state.theme.dividerColor,
        // overlapsForce: true,
        builder: buttonList,
      ),
      // const SliverAppBar(
      //   // floating: true,
      //   pinned: true,
      //   // snap: true,
      //   title: Text('sheet stack'),
      // ),
      const SliverFillRemaining(
        fillOverscroll: true,
        child: ParallelContent(),
      ),
    ];
  }

  Widget buttonList(BuildContext _, ViewHeaderData org) {
    return Row(
      key: const ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ViewButton(
          message: preference.text.previousTo(preference.text.chapter('false')),
          onPressed: setChapterPrevious,
          child: const ViewMark(icon: LideaIcon.chapterPrevious, iconSize: 22),
        ),
        ViewButton(
          message: preference.text.nextTo(preference.text.chapter('false')),
          onPressed: setChapterNext,
          child: const ViewMark(icon: LideaIcon.chapterNext, iconSize: 22),
        ),
        ViewButton(
          message: preference.text.compareTo(preference.text.parallel),
          onPressed: scrollAnimateToggle,
          child: const ViewMark(icon: LideaIcon.language, iconSize: 20),
        ),
        ValueListenableBuilder<List<int>>(
          valueListenable: primaryScripture.verseSelection,
          builder: (context, value, _) {
            return ViewButton(
              enable: value.isNotEmpty,
              message: preference.text.share,
              onPressed: copyVerseSelection,
              child: ViewMark(
                icon: LideaIcon.copy,
                iconSize: 20,
                badge: value.isNotEmpty ? value.length.toString() : '',
              ),
            );
          },
        ),
      ],
    );
  }
}
