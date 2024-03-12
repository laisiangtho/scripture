part of 'main.dart';

mixin _Result on _State {
  Widget resultView() {
    return CustomScrollView(
      primary: true,
      slivers: [
        // Selector<Core, ConclusionType>(
        //   selector: (_, e) => e.cacheConclusion,
        //   builder: (BuildContext context, ConclusionType o, Widget? child) {
        //     if (o.emptyQuery) {
        //       return _resultNoQuery();
        //     } else if (o.emptyResult) {
        //       return child!;
        //     } else {
        //       return _resultBlock();
        //     }
        //   },
        //   child: message(App.preference.text.searchNoMatch),
        // ),
        Selector<Core, BIBLE>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, BIBLE o, Widget? child) {
            if (o.query.isEmpty) {
              // return message(preference.text.aWordOrTwo);
              return _resultNoQuery();
            }
            // o.verseCount > 0
            return _resultBlock();
            // return message(preference.text.searchNoMatch);
          },
        ),
      ],
    );
  }

  Widget _resultNoQuery() {
    return ViewFeedback(
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
    );
  }

  Widget _resultBlock() {
    return ViewListBuilder(
      itemBuilder: (BuildContext _, int bookIndex) {
        // return _suggestItem(index, o.raw.elementAt(index));
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
      itemCount: bible.book.length,
      onEmpty: ViewFeedback.message(
        label: App.preference.text.searchNoMatch,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chapters.map(
                  (e) {
                    final active = e.id == chapter.id;
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          elevation: 0.3,
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
                          onPressed: () => toRead(bookId, e.id),
                          child: Text(
                            e.name,
                            semanticsLabel: 'chapter: ${e.name}',
                            style: TextStyle(
                              fontSize: 15,
                              color: active ? null : state.theme.primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
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
          size: data.boxOfSettings.fontSize().asDouble,
          lang: core.scripturePrimary.info.langCode,
          child: WidgetVerse(
            verse: verse,
            keyword: searchQuery,
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
