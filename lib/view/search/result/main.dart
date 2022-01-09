import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search/result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  late final scrollController = ScrollController();
  late final Future<void> initiator = core.conclusionGenerate(init: true);

  ViewNavigationArguments get _arguments => widget.arguments as ViewNavigationArguments;
  GlobalKey<NavigatorState> get navigator => _arguments.navigator!;
  ViewNavigationArguments get _parent => _arguments.args as ViewNavigationArguments;
  bool get canPop => _arguments.args != null;
  // bool get canPop => _arguments.canPop;
  // bool get canPop => navigator.currentState!.canPop();
  // bool get canPop => Navigator.of(context).canPop();

  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onSearch(bool status) {
    if (status) {
      // Future.microtask(() {
      //   core.conclusionGenerate().whenComplete(() {
      //     if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
      //       scrollController.animateTo(
      //         scrollController.position.minScrollExtent,
      //         curve: Curves.fastOutSlowIn,
      //         duration: const Duration(milliseconds: 500),
      //       );
      //     }
      //   });
      // });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
    }
  }

  void onNav(int book, int chapter) {
    // debugPrint('TODO: book $book chapter $chapter');
    // NotifyNavigationButton.navigation.value = 1;
    core.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      core.navigate(at: 1);
    });
  }

  BIBLE get bible => core.scripturePrimary.verseSearch;
  bool get shrinkResult => bible.verseCount > 300;
  String get searchQueryCurrent => core.collection.suggestQuery;
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        FutureBuilder(
          future: initiator,
          builder: (BuildContext _, AsyncSnapshot<void> snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return _msg(preference.text.aMoment);
              default:
                // return Selector<Core, ConclusionType>(
                //   selector: (_, e) => e.collection.cacheConclusion,
                //   builder: (BuildContext context, ConclusionType o, Widget? child) {
                //     if (o.query.isEmpty) {
                //       return _msg('no query');
                //     } else if (o.raw.isNotEmpty) {
                //       return _listView(o);
                //     } else {
                //       return _msg('no match');
                //     }
                //   },
                // );
                return Selector<Core, BIBLE>(
                  selector: (_, e) => e.scripturePrimary.verseSearch,
                  builder: (BuildContext context, BIBLE o, Widget? child) {
                    if (o.query.isEmpty) {
                      return _msg(preference.text.aWordOrTwo);
                    } else if (o.verseCount > 0) {
                      return _resultView();
                    } else {
                      return _msg(preference.text.searchNoMatch);
                    }
                  },
                );
            }
          },
        ),
      ],
    );
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _resultView() {
    return SliverList(
      key: UniqueKey(),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int bookIndex) {
          BOOK book = bible.book[bookIndex];
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                // margin: EdgeInsets.only(top:10),
                padding: const EdgeInsets.all(10),
                // color: Colors.red,
                child: Text(
                  book.info.name.toUpperCase(),
                  semanticsLabel: 'book: ' + book.info.name,
                  style: const TextStyle(
                    fontSize: 22, //17
                    fontWeight: FontWeight.w400,
                    // shadows: <Shadow>[
                    //   Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                    // ]
                  ),
                ),
              ),
              _resultChapter(book, book.info.id)
            ],
          );
        },
        childCount: bible.book.length,
      ),
    );
  }

  Widget _resultChapter(BOOK book, int bookId) {
    List<CHAPTER> chapters = book.chapter;
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter ? 1 : chapters.length;
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: chapters.length,
      itemCount: shrinkChapterTotal,
      itemBuilder: (context, chapterIndex) {
        CHAPTER chapter = chapters[chapterIndex];
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (shrinkChapter)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: chapters
                      .where((e) => e.id != chapter.id)
                      .map(
                        (e) => SizedBox(
                          width: 50,
                          child: RawMaterialButton(
                            child: Text(
                              e.name,
                              semanticsLabel: 'chapter: ' + e.name,
                              style: const TextStyle(fontSize: 15),
                            ),
                            elevation: 0.0,
                            padding: const EdgeInsets.all(10),
                            fillColor: Colors.grey[300],
                            shape: const CircleBorder(),
                            onPressed: () => onNav(bookId, e.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: book.info.name,
                child: RawMaterialButton(
                  child: Text(
                    chapter.name,
                    semanticsLabel: chapter.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  elevation: 0.5,
                  padding: const EdgeInsets.all(10),
                  fillColor: Theme.of(context).primaryColor,
                  shape: const CircleBorder(),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(
                  //     Radius.elliptical(3, 20)
                  //   )
                  // ),
                  onPressed: () => onNav(bookId, chapter.id),
                ),
              ),
            ),
            _resultVerse(chapter.verse),
          ],
        );
      },
    );
  }

  Widget _resultVerse(List<VERSE> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse ? 1 : verses.length;
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
      // itemCount: 1,
      itemBuilder: (context, index) {
        VERSE verse = verses[index];
        return VerseWidgetInherited(
          // key: verse.key,
          size: core.collection.fontSize,
          lang: core.scripturePrimary.info.langCode,
          child: WidgetVerse(
            verse: verse,
            keyword: searchQueryCurrent,
            // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
            alsoInVerse: shrinkVerse
                ? verses.where((e) => e.id != verse.id).map((e) => e.name).join(', ')
                : '',
          ),
        );
      },
    );
  }
}
