import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search-result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight],
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        // overlapsForce: true,
        builder: bar,
      ),
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
    ];
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
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
                  semanticsLabel: 'book: ${book.info.name}',
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
                            elevation: 0.0,
                            padding: const EdgeInsets.all(10),
                            fillColor: Colors.grey[300],
                            shape: const CircleBorder(),
                            onPressed: () => onNav(bookId, e.id),
                            child: Text(
                              e.name,
                              semanticsLabel: 'chapter: ${e.name}',
                              style: const TextStyle(fontSize: 15),
                            ),
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
                  child: Text(
                    chapter.name,
                    semanticsLabel: chapter.name,
                    style: const TextStyle(fontSize: 18),
                  ),
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
          size: collection.boxOfSettings.fontSize().asDouble,
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
