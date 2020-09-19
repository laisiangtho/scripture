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
      future: getResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return WidgetMessage(message: snapshot.error.toString());
        }

        if (snapshot.hasData) {
          if (snapshot.data && bible.verseCount > 0) {
            core.addKeyword(this.searchQuery.trim());
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
            // Container(
            //   margin: EdgeInsets.only(top:10,bottom:5),
            //   child: Text(chapter.name),
            // ),

            // if(shrinkChapter) GridView(
            //   // children: <Widget>[],
            //   // crossAxisCount: 7,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
            //   // childAspectRatio: 2.0,
            //   padding: EdgeInsets.all(15.0),
            //   shrinkWrap: true,
            //   primary: false,
            //   children: chapters.where((e) => e.id  != chapter.id).map(
            //     (e) => Container(
            //       alignment: Alignment.center,
            //       child: RawMaterialButton(
            //         onPressed: null,
            //         elevation: 2.0,
            //         fillColor: Colors.white,
            //         child: Text(core.digit(e.id)),
            //         // padding: EdgeInsets.all(15.0),
            //         shape: CircleBorder(),
            //       ),
            //     )
            //   ).toList(),
            // ),
            // if(shrinkChapter) SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   padding: EdgeInsets.all(15.0),
            //   child: Row(
            //     children: chapters.where((e) => e.id  != chapter.id).map(
            //       (e) => RawMaterialButton(
            //         onPressed: (){},
            //         elevation: 2.0,
            //         fillColor: Colors.white,
            //         child: Text(core.digit(e.id)),
            //         padding: EdgeInsets.all(15.0),
            //         shape: CircleBorder(),
            //       )
            //     ).toList(),
            //   )
            // ),
            if(shrinkChapter) SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chapters.where((e) => e.id  != chapter.id).map(
                  (e) => SizedBox(
                    width: 50,
                    child: FlatButton(
                      child: Text(
                        // core.digit(e.id),
                        e.name,
                        semanticsLabel: 'chapter: '+e.name,
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                      color: Colors.grey[300],
                      // textColor: Colors.white,
                      textColor: Colors.black45,
                      padding: EdgeInsets.all(7),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: new CircleBorder(),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.all(
                      //     Radius.elliptical(3, 20)
                      //   )
                      // ),
                      onPressed: () => toBible(bookId,e.id)
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
                onPressed: ()=>toBible(bookId,chapter.id)
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
