part of 'main.dart';

mixin _Result on _State {
  Widget result(){
    return Selector<Core,BIBLE>(
      selector: (_, e) => e.scripturePrimary.verseSearch,
      builder: (BuildContext context, BIBLE o, Widget? child) {
        if (searchQuery.isEmpty){
          return _resultNoQuery();
        } else if (o.verseCount > 0){
          return _resultBook();
        } else {
          return _resultNoMatch();
        }
      }
    );
  }

  Widget _resultNoQuery(){
    return WidgetMessage(
      message: 'try with a word or two',
    );
  }

  Widget _resultNoMatch(){
    return WidgetMessage(
      message: 'result: not found',
    );
  }

  Widget _resultBook() {
    return new SliverList(
      key: UniqueKey(),
      delegate: SliverChildBuilderDelegate((BuildContext context, int bookIndex) {
          BOOK book = bible.book[bookIndex];
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                // margin: EdgeInsets.only(top:10),
                padding: EdgeInsets.all(10),
                // color: Colors.red,
                child: Text(
                  book.info.name.toUpperCase(),
                  semanticsLabel: 'book: '+book.info.name,
                  style:TextStyle(
                    fontSize: 22, //17
                    fontWeight: FontWeight.w400,
                    // shadows: <Shadow>[
                    //   Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                    // ]
                  )
                ),
              ),
              _resultChapter(book.chapter, book.info.id)
            ]
          );
        },
        childCount: bible.book.length
      )
    );
  }

  Widget _resultChapter(List<CHAPTER> chapters, int bookId) {
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter?1:chapters.length;
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      // itemCount: chapters.length,
      itemCount: shrinkChapterTotal,
      itemBuilder: (context, chapterIndex){
        CHAPTER chapter = chapters[chapterIndex];
        return new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if(shrinkChapter) SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chapters.where((e) => e.id  != chapter.id).map(
                  (e) => SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      child: Text(
                        e.name,
                        semanticsLabel: 'chapter: '+e.name,
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                      elevation: 0.0,
                      padding: EdgeInsets.all(10),
                      fillColor: Colors.grey[300],
                      shape: CircleBorder(),
                      onPressed: ()=> onNav(bookId,e.id)
                    ),
                  )
                ).toList(),
              )
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                child: Text(
                  chapter.name,
                  semanticsLabel: chapter.name,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                padding: EdgeInsets.all(10),
                fillColor: Colors.white,
                shape: CircleBorder(),
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(
                //     Radius.elliptical(3, 20)
                //   )
                // ),
                onPressed: () => onNav(bookId,chapter.id)
              ),
            ),

            _resultVerse(chapter.verse)

          ]
        );
      }
    );
  }

  Widget _resultVerse(List<VERSE> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse?1:verses.length;
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
      // itemCount: 1,
      itemBuilder: (context, index){
        VERSE verse = verses[index];
        return new WidgetVerse(
          verse:verse,
          keyword: this.searchQuery,
          // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
          alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => e.name).join(', '):''
        );
      }
    );
  }

}