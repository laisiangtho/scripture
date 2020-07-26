part of 'main.dart';

mixin _Result on _State {

  Widget result() {
    // sliver: hasNotResult?_loadChapter():_loadVerse()
    if (this.searchQuery.isEmpty) {
      return new WidgetContent(atLeast: 'search\na',enable:' Word ',task: 'or two\nin ',message:'verses');
    }
    // if (hasNotResult == false) {
    //   return _resultBook();
    // }
    return FutureBuilder(
      future: getResult(),
      builder: (BuildContext context, AsyncSnapshot<BIBLE> snapshot) {
        if (snapshot.hasError) {
          return WidgetMessage(message: snapshot.error.toString());
        }

        if (snapshot.hasData) {
          if (snapshot.data.book.length > 0) {
            core.addKeyword(this.searchQuery);
            return new SliverPadding(
              padding: EdgeInsets.symmetric(vertical:10),
              // sliver: _resultSingle(snapshot.data)
              sliver: _resultBook()
              // sliver: _resultBook()
            );
          } else if (this.searchQuery.isNotEmpty) {
            // found no contain/of
            return WidgetContent(atLeast: 'found no match\nof ',enable:this.searchQuery,task: '\nin ',message:bibleInfo.name);
          }
        }
        return new WidgetContent(atLeast: 'search\na',enable:' Word ',task: 'or two\nin ',message:'verses');
      }
    );
  }

  // Widget _resultSingle(BIBLE bible) {
  //   List<VERSE> verses = bible.book.first.chapter.first.verse;
  //   return new SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (BuildContext context, int verseIndex) {
  //         VERSE verse = verses[verseIndex];
  //         return new Column(
  //           children: <Widget>[
  //             Text(verse.name),
  //             Text(verse.text),
  //           ]
  //         );
  //       },
  //       childCount: verses.length
  //     )
  //   );
  // }

  Widget _resultBook() {
    return new SliverList(
      key: UniqueKey(),
      delegate: SliverChildBuilderDelegate((BuildContext context, int bookIndex) {
          BOOK book = bible.book[bookIndex];
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:10),
                child: Text(
                  book.info.name.toUpperCase(),
                  style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    // fontStyle: FontStyle.italic,
                    // color:Colors.red,
                    // backgroundColor: Colors.grey,
                    // backgroundColor: isSelected?Theme.of(context).backgroundColor:null,
                    // background: Paint(),
                    // decoration: isSelected?TextDecoration.underline:TextDecoration.none,
                    // decorationColor: Colors.red,
                    // decorationStyle: TextDecorationStyle.wavy,
                    // decorationThickness: 3.0,
                    shadows: <Shadow>[
                      Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                    ]
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
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      itemCount: chapters.length,
      itemBuilder: (context, chapterIndex){
        CHAPTER chapter = chapters[chapterIndex];
        return new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   margin: EdgeInsets.only(top:10,bottom:5),
            //   child: Text(chapter.name),
            // ),
            FlatButton(
              child: Text(chapter.name),
              onPressed: () {
                core.bookId = bookId;
                core.chapterId = chapter.id;
                controller.master.bottom.pageChange(1);
              },
              color: Colors.grey[400],
              textColor: Colors.white,
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              shape: new CircleBorder(),
            ),
            // Text(chapter.verse.map((e) => e.id).join(', ')),
            _resultVerse(chapter.verse)
          ]
        );
      }
    );
  }

  Widget _resultVerse(List<VERSE> verses) {
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      itemCount: verses.length,
      // itemCount: 1,
      itemBuilder: (context, index){
        VERSE verse = verses[index];
        return new WidgetVerse(
          verse:verse,
          keyword: this.searchQuery
        );
      }
    );
  }

}
