part of 'main.dart';

mixin _Suggest on _State<Main> {
  // bool get shrinkResult => o.verseCount > 300;
  // bool get shrinkResult => o.suggest.totalVerse > 300;
  Widget _suggestBlock(CacheBible o) {
    final shrinks = o.suggest.totalVerse > 300;
    return CustomScrollView(
      key: PageStorageKey('search-suggest-${o.query}'),
      controller: scrollController,
      slivers: [
        ViewLists(
          itemBuilder: (BuildContext _, int bookIndex) {
            // return _suggestItem(index, o.raw.elementAt(index));
            OfBook book = o.suggest.book.elementAt(bookIndex);
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text(book.info.name),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(book.info.name.toUpperCase()),
                ),
                _suggestChapter(book.chapter, shrinks),
              ],
            );
          },
          itemCount: o.suggest.book.length,
          onEmpty: ViewFeedbacks.message(
            label: lang.searchNoMatch,
          ),
        ),
      ],
    );
  }

  Widget _suggestChapter(List<OfChapter> chapters, bool shrinks) {
    final bool shrinkChapter = (chapters.length > 1 && shrinks);
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
            _suggestVerse(chapter.verse, shrinks),
          ],
        );
      },
    );
  }

  Widget _suggestVerse(List<OfVerse> verses, bool shrinks) {
    final bool shrinkVerse = (verses.length > 1 && shrinks);
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
