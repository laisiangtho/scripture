part of 'main.dart';

mixin _Suggest on _State {
  Widget suggestView() {
    return CustomScrollView(
      primary: true,
      slivers: [
        // Selector<Core, SuggestionType>(
        //   selector: (_, e) => e.cacheSuggestion,
        //   builder: (BuildContext context, SuggestionType o, Widget? child) {
        //     if (o.emptyQuery) {
        //       return const _Recents();
        //     } else if (o.emptyResult) {
        //       return child!;
        //     } else {
        //       return _suggestBlock(o);
        //     }

        //     // return suggests(o);
        //   },
        //   child: message(App.preference.text.searchNoMatch),
        // ),
        Selector<Core, BIBLE>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, BIBLE o, Widget? child) {
            if (o.query.isEmpty) {
              return const _Recents();
            }
            // o.verseCount > 0
            return _suggestBlock();
            // return message(App.preference.text.searchNoMatch);
          },
        ),
      ],
    );
  }

  Widget _suggestBlock() {
    return ViewListBuilder(
      itemBuilder: (BuildContext _, int bookIndex) {
        // return _suggestItem(index, o.raw.elementAt(index));
        BOOK book = bible.book[bookIndex];
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
      itemCount: bible.book.length,
      onEmpty: ViewFeedback.message(
        label: App.preference.text.searchNoMatch,
      ),
    );
  }

  Widget _suggestChapter(List<CHAPTER> chapters) {
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter ? 1 : chapters.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
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

  Widget _suggestVerse(List<VERSE> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse ? 1 : verses.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
      itemBuilder: (context, index) {
        VERSE verse = verses[index];
        return VerseWidgetInherited(
          // key: verse.key,
          size: data.boxOfSettings.fontSize().asDouble,
          lang: primaryScripture.info.langCode,
          child: WidgetVerse(
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
