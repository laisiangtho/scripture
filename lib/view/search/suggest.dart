part of 'main.dart';

class _Suggest extends StatefulWidget {
  const _Suggest();

  @override
  State<_Suggest> createState() => _SuggestView();
}

class _SuggestView extends StateAbstract<_Suggest> {
  Scripture get primaryScripture => core.scripturePrimary;

  CacheBible get bible => primaryScripture.verseSearch;
  // bool get shrinkResult => bible.verseCount > 300;
  bool get shrinkResult => bible.suggest.totalVerse > 300;

  String get suggestQuery => data.suggestQuery;
  set suggestQuery(String ord) {
    data.suggestQuery = ord;
    // _textController.text = ord;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ViewDelays.milliseconds(
      // milliseconds: 400,
      onAwait: const ViewFeedbacks.await(),
      builder: (_, __) {
        return Selector<Core, CacheBible>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, CacheBible o, Widget? child) {
            if (o.query.isEmpty) {
              return resultRecents();
            }
            return resultSuggests();
            // return scrollView(o.query.isEmpty ? resultRecent : resultBlock);
          },
        );
      },
    );
  }

  Widget resultRecents() {
    return const CustomScrollView(
      key: PageStorageKey('search-suggest-empty'),
      // controller: scrollController,
      // primary: true,
      // slivers: [_resultSliver],
      slivers: [
        _Recent(),
      ],
    );
  }

  Widget resultSuggests() {
    return CustomScrollView(
      key: PageStorageKey('search-suggest-${bible.query}'),
      // controller: scrollController,
      // primary: true,
      slivers: [
        ViewLists(
          itemBuilder: (BuildContext _, int bookIndex) {
            // return _suggestItem(index, o.raw.elementAt(index));
            OfBook book = bible.suggest.book.elementAt(bookIndex);
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text(book.info.name),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(book.info.name.toUpperCase()),
                ),
                _suggestChapter(book.chapter),
              ],
            );
          },
          itemCount: bible.suggest.book.length,
          onEmpty: ViewFeedbacks.message(
            label: App.preference.text.searchNoMatch,
          ),
        ),
      ],
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('search-suggest'),
      primary: true,
      slivers: [
        SliverToBoxAdapter(
          child: Text('working b:${bible.bookCount} c:${bible.chapterCount} v:${bible.verseCount}'),
        ),
        Selector<Core, BIBLE>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, BIBLE o, Widget? child) {
            if (o.query.isEmpty) {
              // return _Recents(onSuggest: onSuggest);
              return const ViewFeedbacks.message(
                label: 'working _Recents',
              );
            }
            // o.verseCount > 0
            return _suggestBlock();
            // return message(App.preference.text.searchNoMatch);
          },
        ),
      ],
    );
  }
  */

  Widget _suggestChapter(List<OfChapter> chapters) {
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter ? 1 : chapters.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: chapters.length,
      itemCount: shrinkChapterTotal,
      itemBuilder: (context, chapterIndex) {
        OfChapter chapter = chapters.elementAt(chapterIndex);
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (shrinkChapter)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  // chapters.map((e) => e.id).join(', '),
                  // chapters.where((e) => e.id  != chapter.id).map((e) => core.digit(e.id)).join(', '),
                  chapters.where((e) => e.id != chapter.id).map((e) => e.name).join(', '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13.0),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                chapter.name,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ),
            _suggestVerse(chapter.verse),
          ],
        );
      },
    );
  }

  Widget _suggestVerse(List<OfVerse> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse ? 1 : verses.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
      itemBuilder: (context, index) {
        OfVerse verse = verses.elementAt(index);
        return VerseWidgetInherited(
          // key: verse.key,
          size: data.boxOfSettings.fontSize().asDouble,
          // lang: primaryScripture.info.langCode,
          scripture: primaryScripture,
          verseId: verse.id,
          child: VerseItemWidget(
            verse: verse,
            keyword: suggestQuery,
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
