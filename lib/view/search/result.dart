part of 'main.dart';

mixin _Result on _State<Main> {
  // bool get shrinkResult => bible.verseCount > 300;
  // bool get shrinkResult => bible.result.totalVerse > 300;

  // SearchCache cacheResult = SearchCache();

  void toRead(int book, int chapter) {
    app.chapterChange(bookId: book, chapterId: chapter).whenComplete(() {
      if (mounted) {
        context.go('/read');
      }
    });
  }

  Widget _resultEmptyQuery() {
    return ViewFeedbacks(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              app.preference.of(context).aWordOrTwo,
            ),
            Text(
              primaryScripture.info.name,
              style: style.bodySmall,
            ),
            Text(
              primaryScripture.info.shortname,
              style: style.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultEmpty() {
    return ViewFeedbacks(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              app.preference.of(context).searchNoMatch,
            ),
            Text(
              primaryScripture.info.name,
              style: style.bodySmall,
            ),
            Text(
              primaryScripture.info.shortname,
              style: style.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Sticky
  Widget _resultBlock(CacheBible o) {
    final shrinks = o.result.totalVerse > 300;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomScrollView(
        key: PageStorageKey('search-result-${o.query}'),
        controller: scrollController,
        slivers: [
          for (var index = 0; index < o.result.book.length; index++)
            ofBook(o.result.book.elementAt(index), shrinks),
        ],
      ),
    );
  }

  Widget _resultWords(CacheBible o) {
    //  core.app.preference.of(context).favorite('true');
    //  core.preference.language('noMatchInVerse');
    return CustomScrollView(
      key: PageStorageKey('search-empty-${o.query}'),
      slivers: [
        ViewSections(
          // headerTitle: Text(
          //   'did not match any verses with ABC, but found some words that you might',
          //   style: style.titleSmall,
          // ),
          headerTitle: Paragraphs(
            text: preference.language('noMatchInVerse'),
            decoration: [
              TextSpan(
                text: o.query,
                semanticsLabel: 'keyword',
                style: TextStyle(color: theme.indicatorColor),
              ),
            ],
            style: style.titleSmall!.copyWith(
              color: theme.hintColor,
            ),
          ),
          child: ViewCards.fill(
            child: ViewLists.separator(
              separator: (_, index) {
                return const ViewDividers();
              },
              itemBuilder: (_, index) {
                String word = o.words.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.arrow_outward_sharp),
                  title: Text(word),
                  onTap: () => onSearch(word),
                );
                // return const Placeholder();
              },
              itemCount: o.words.length,
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

  // List of Book
  Widget ofBook(OfBook book, bool shrinks) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        // SliverAppBar.medium
        SliverAppBar(
          pinned: true,
          primary: false,
          elevation: 0,
          shadowColor: theme.dividerColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 35,
          // leading: Center(
          //   child: Text(
          //     // primaryScripture.digit(iB + 1),
          //     primaryScripture.digit(book.info.id),
          //     textAlign: TextAlign.center,
          //     style: style.labelMedium,
          //   ),
          // ),
          title: Text(
            book.info.name.toUpperCase(),
            style: style.titleMedium,
            semanticsLabel: 'book: ${book.info.name}',
          ),
          // titleSpacing: 20,
          // toolbarHeight: 40,
        ),
        ofChapter(book, shrinks),
      ],
    );
  }

  // List of Chapter
  Widget ofChapter(OfBook book, bool shrinks) {
    final List<OfChapter> chapters = book.chapter;
    final int totalChapter = chapters.length;
    final bool shrinkChapter = (totalChapter > 1 && shrinks);
    final int shrinkChapterTotal = shrinkChapter ? 1 : totalChapter;
    // final int linkChapter = shrinkChapter ? totalChapter : 1;

    return ViewLists(
      // key: UniqueKey(),
      // padding: const EdgeInsets.symmetric(vertical: 30),
      // padding: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 30, bottom: 20),
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
                            // fillColor: active ? theme.focusColor : theme.primaryColor,
                            // fillColor: theme.primaryColor,
                            fillColor: active ? theme.focusColor : theme.primaryColor,
                            // fillColor: theme.focusColor,
                            // shape: const CircleBorder(),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            onPressed: () {
                              toRead(book.info.id, e.id);
                            },
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
                // fillColor: active ? theme.focusColor : theme.primaryColor,
                fillColor: theme.primaryColor,
                // fillColor: theme.focusColor,
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
                  style: style.labelMedium,
                ),
              ),
            ofVerse(chapter.verse, shrinks),
          ],
        );
      },
      itemCount: shrinkChapterTotal,
    );
  }

  Widget ofVerse(List<OfVerse> verses, bool shrinks) {
    final bool shrinkVerse = (verses.length > 1 && shrinks);
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

// class SearchCache {
//   String keyword;
//   String iso;
//   Widget? child;
//   SearchCache({
//     this.keyword = "",
//     this.iso = "",
//     this.child,
//   });

//   bool isEmpty(CacheBible o) {
//     return keyword != o.query || iso != o.result.info.langCode;
//   }
// }
