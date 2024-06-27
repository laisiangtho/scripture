part of 'main.dart';

class _Result extends StatefulWidget {
  const _Result();

  @override
  State<_Result> createState() => _ResultView();
}

class _ResultView extends StateAbstract<_Result> {
  Scripture get primaryScripture => core.scripturePrimary;

  CacheBible get bible => primaryScripture.verseSearch;
  // bool get shrinkResult => bible.verseCount > 300;
  bool get shrinkResult => bible.result.totalVerse > 300;

  SearchCache cacheResult = SearchCache();

  String get searchQuery => data.searchQuery;
  set searchQuery(String ord) {
    data.searchQuery = ord;
  }

  void onSearch(String ord) {
    data.searchQuery = ord;
  }

  void toRead(int book, int chapter) {
    core.chapterChange(bookId: book, chapterId: chapter).whenComplete(() {
      route.pushNamed('read');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewDelays.milliseconds(
      milliseconds: 250,
      onAwait: const ViewFeedbacks.await(),
      builder: (_, __) {
        return Selector<Core, CacheBible>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, CacheBible o, Widget? child) {
            // return resultWords();
            if (o.query.isEmpty) {
              return resultEmpty();
            }
            if (o.result.ready) {
              return resultBlocks();
            }
            if (o.words.isNotEmpty) {
              return resultWords();
            }

            return resultNone();
          },
        );
      },
    );
  }

  Widget resultWords() {
    // App.preference.text.favorite('true');
    // App.preference.language('noMatchInVerse');
    return CustomScrollView(
      key: PageStorageKey('search-empty-${bible.query}'),
      slivers: [
        ViewSections(
          // headerTitle: Text(
          //   'did not match any verses with ABC, but found some words that you might',
          //   style: state.textTheme.titleSmall,
          // ),
          headerTitle: Paragraphs(
            text: App.preference.language('noMatchInVerse'),
            decoration: [
              TextSpan(
                text: bible.query,
                semanticsLabel: 'keyword',
                style: TextStyle(color: state.theme.hintColor),
              ),
            ],
            style: state.textTheme.titleSmall,
          ),
          child: ViewCards.fill(
            child: ViewLists.separator(
              separator: (_, index) {
                return const ViewDividers();
              },
              itemBuilder: (_, index) {
                String word = bible.words.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.arrow_outward_sharp),
                  title: Text(word),
                  onTap: () => onSearch(word),
                );
                // return const Placeholder();
              },
              itemCount: bible.words.length,
            ),
          ),
          // child: ViewCards.fill(
          //   child: ViewLists.separator(
          //     separator: (_, index) {
          //       return const ViewDividers();
          //     },
          //     itemBuilder: (_, index) {
          //       String word = bible.words.elementAt(index);
          //       return ListTile(
          //         leading: const Icon(Icons.arrow_outward_sharp),
          //         title: Text(word),
          //         onTap: () => onSearch(word),
          //       );
          //       // return const Placeholder();
          //     },
          //     itemCount: bible.words.length,
          //   ),
          // ),
        ),
      ],
    );
  }

  Widget resultEmpty() {
    return CustomScrollView(
      key: const PageStorageKey('search-result-empty'),
      slivers: [
        ViewFeedbacks(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(preference.text.aWordOrTwo),
              Text(
                primaryScripture.info.name,
                style: state.textTheme.bodySmall,
              ),
              Text(
                primaryScripture.info.shortname,
                style: state.textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget resultNone() {
    return CustomScrollView(
      key: const PageStorageKey('search-result-none'),
      slivers: [
        ViewFeedbacks(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(preference.text.aWordOrTwo),
              // const ViewSectionDivider(primary: false),
              Text(
                primaryScripture.info.name,
                style: state.textTheme.bodySmall,
              ),

              Text(
                primaryScripture.info.shortname,
                style: state.textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sticky
  Widget resultBlocks() {
    return CustomScrollView(
      key: PageStorageKey('search-result-${bible.query}'),
      slivers: [
        for (var index = 0; index < bible.result.book.length; index++)
          ofBook(bible.result.book.elementAt(index)),
      ],
    );
  }

  // List of Book
  Widget ofBook(OfBook book) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        // SliverAppBar.medium
        SliverAppBar(
          pinned: true,
          primary: false,
          elevation: 0,
          shadowColor: state.theme.dividerColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 35,
          // leading: Center(
          //   child: Text(
          //     // primaryScripture.digit(iB + 1),
          //     primaryScripture.digit(book.info.id),
          //     textAlign: TextAlign.center,
          //     style: state.textTheme.labelMedium,
          //   ),
          // ),
          title: Text(
            book.info.name.toUpperCase(),
            style: state.textTheme.titleMedium,
            semanticsLabel: 'book: ${book.info.name}',
          ),
          // titleSpacing: 20,
          // toolbarHeight: 40,
        ),
        ofChapter(book),
      ],
    );
  }

  // List of Chapter
  Widget ofChapter(OfBook book) {
    final List<OfChapter> chapters = book.chapter;
    final int totalChapter = chapters.length;
    final bool shrinkChapter = (totalChapter > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter ? 1 : totalChapter;
    // final int linkChapter = shrinkChapter ? totalChapter : 1;

    return ViewLists(
      // key: UniqueKey(),
      // padding: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        final OfChapter chapter = chapters.elementAt(index);
        return Column(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shrinkChapter)
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ViewLists(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext _, int index) {
                      final e = chapters.elementAt(index);
                      final active = e.id == chapter.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 50,
                          child: RawMaterialButton(
                            elevation: 0.3,
                            // padding: const EdgeInsets.symmetric(vertical: 4),
                            // fillColor: Colors.grey[300],
                            // fillColor: active ? state.theme.focusColor : state.theme.primaryColor,
                            // fillColor: state.theme.primaryColor,
                            fillColor: active ? state.theme.focusColor : state.theme.primaryColor,
                            // fillColor: state.theme.focusColor,
                            // shape: const CircleBorder(),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              e.id.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: totalChapter,
                  ),
                ),
              )
            else
              RawMaterialButton(
                elevation: 0.7,
                padding: const EdgeInsets.all(8),
                // fillColor: Colors.grey[300],
                // fillColor: active ? state.theme.focusColor : state.theme.primaryColor,
                fillColor: state.theme.primaryColor,
                // fillColor: state.theme.focusColor,
                // shape: const CircleBorder(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                // constraints: const BoxConstraints(minWidth: 50.0, minHeight: 30.0),
                onPressed: () {
                  toRead(book.info.id, chapter.id);
                },
                child: Text(
                  chapter.name,
                  semanticsLabel: 'chapter: ${chapter.name}',
                  style: state.textTheme.labelMedium,
                ),
              ),
            // SizedBox(
            //   height: 70,
            //   child: ViewLists(
            //     shrinkWrap: true,
            //     primary: false,
            //     scrollDirection: Axis.horizontal,
            //     physics: const ClampingScrollPhysics(),
            //     itemBuilder: (BuildContext _, int index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(8),
            //         child: SizedBox(
            //           width: 50,
            //           child: RawMaterialButton(
            //             elevation: 0.3,
            //             padding: const EdgeInsets.all(8),
            //             // fillColor: Colors.grey[300],
            //             // fillColor: active ? state.theme.focusColor : state.theme.primaryColor,
            //             fillColor: state.theme.primaryColor,
            //             // fillColor: state.theme.focusColor,
            //             // shape: const CircleBorder(),
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(7),
            //               ),
            //             ),
            //             onPressed: () {},
            //             child: Text(
            //               index.toString(),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     itemCount: 12,
            //   ),
            // ),
            ofVerse(chapter.verse),
          ],
        );
      },
      itemCount: shrinkChapterTotal,
    );
  }

  Widget ofVerse(List<OfVerse> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse ? 1 : verses.length;
    return ViewLists(
      shrinkWrap: true,
      itemBuilder: (BuildContext _, int index) {
        OfVerse verse = verses.elementAt(index);
        return VerseWidgetInherited(
          // key: verse.key,
          size: data.boxOfSettings.fontSize().asDouble,
          // lang: primaryScripture.info.langCode,
          scripture: primaryScripture,
          verseId: verse.id,
          child: VerseItemWidget(
            verse: verse,
            keyword: searchQuery,
            // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
            alsoInVerse: shrinkVerse
                ? verses.where((e) => e.id != verse.id).map((e) => e.name).join(', ')
                : '',
          ),
        );
      },
      itemCount: shrinkVerseTotal,
    );
  }
}
