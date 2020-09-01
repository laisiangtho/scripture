part of 'main.dart';

mixin _Suggest on _State {

  Widget suggest() {
    if (this.searchQuery.isEmpty) {
      return _suggestionKeyword();
    }
    return FutureBuilder(
      future: getResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return WidgetMessage(message: snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data) {
            return _suggestionBook();
          } else if (this.searchQuery.isNotEmpty) {
            return WidgetContent(atLeast: 'found no contain\nof ',enable:this.searchQuery,task: '\nin ',message:bibleInfo?.name);
          } else {
            return _suggestionKeyword();
          }
        } else {
          return _suggestionKeyword();
        }
      }
    );
  }

  Widget _suggestionBook() {
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int bookIndex) {
          BOOK book = bible.book[bookIndex];
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text(book.info.name),
              Container(
                margin: EdgeInsets.symmetric(vertical:10),
                child: Text(book.info.name.toUpperCase()),
              ),
              _suggestionChapter(book.chapter)
            ]
          );
        },
        childCount: bible.book.length
      )
    );
  }

  Widget _suggestionChapter(List<CHAPTER> chapters) {
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter?1:chapters.length;
    return ListView.builder(
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
            if(shrinkChapter) Padding(
              padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
              child: Text(
                // chapters.map((e) => e.id).join(', '),
                // chapters.where((e) => e.id  != chapter.id).map((e) => core.digit(e.id)).join(', '),
                chapters.where((e) => e.id  != chapter.id).map((e) => e.name).join(', '),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:Colors.grey,
                  fontSize: 13.0
                ),
              ),
            ),

            // if(shrinkChapter) Container(
            //   child: RichText(
            //     text: TextSpan(
            //       text:'...',
            //       children: chapters.where((e) => e.id  != chapter.id).map(
            //         (e) => TextSpan(
            //           text: core.digit(e.id)
            //         )
            //       ).toList(),
            //       // children: <InlineSpan>[ TextSpan(text:'')]
            //       style: TextStyle(
            //         color:Colors.grey,
            //         fontSize: 13.0
            //       )
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),

            // if(shrinkChapter) GridView(
            //   // children: <Widget>[],
            //   // crossAxisCount: 7,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
            //   // childAspectRatio: 2.0,
            //   padding: EdgeInsets.all(15.0),
            //   shrinkWrap: true,
            //   primary: false,
            //   children: chapters.where(
            //     (e) => e.id  != chapter.id).map(
            //       (e) => RawMaterialButton(
            //         onPressed: null,
            //         elevation: 2.0,
            //         fillColor: Colors.white,
            //         child: Text(core.digit(e.id)),
            //         // padding: EdgeInsets.all(15.0),
            //         shape: CircleBorder(),
            //       )
            //     ).toList(),
            // ),

            // if(shrinkChapter) Row(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   // children: <Widget>[],
            //   children: chapters.where(
            //     (e) => e.id  != chapter.id).map(
            //       (e) => RawMaterialButton(
            //         onPressed: () {},
            //         elevation: 2.0,
            //         fillColor: Colors.white,
            //         child: Text(core.digit(e.id)),
            //         padding: EdgeInsets.all(15.0),
            //         shape: CircleBorder(),
            //       )
            //     ).toList(),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(vertical:10),
              child: Text(
                chapter.name,
                style: TextStyle(
                  color:Colors.black54,
                  fontSize: 18
                ),
              ),
            ),

            _suggestionVerse(chapter.verse)

          ]
        );
      }
    );
  }

  Widget _suggestionVerse(List<VERSE> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse?1:verses.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
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


  Widget _suggestionKeyword(){
    return SliverPadding(
      // padding: EdgeInsets.only(top: 2),
      padding: EdgeInsets.symmetric(vertical: 5),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _suggestionKeywordBuilder(context, keywordSuggestion[index],index),
          childCount: keywordSuggestion.length,
          // addAutomaticKeepAlives: true
        ),
      ),
    );
  }
  Widget _suggestionKeywordBuilder(BuildContext context, CollectionKeyword keyword, int index){

    return Dismissible(
      key: Key(keyword.word),
      onDismissed: (direction) {
        setState(() {
          keywordSuggestion.removeAt(index);
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Removed"),
            duration: Duration(milliseconds:5),
          )
        );
        core.writeCollection();
      },
      background: Container(
        alignment: Alignment(0.9,0),
        // color: Colors.red,
        child: Text('Remove',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.red,))
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:5,vertical:2),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(
            // Radius.elliptical(3, 3)
            Radius.elliptical(7, 100)
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 0.0,
              color: Theme.of(context).backgroundColor,
              spreadRadius: 0.6,
              offset: Offset(0.0, .0),
            )
          ]
        ),
        child: new ListTile(
          leading: const Icon(Icons.subdirectory_arrow_right,color: Colors.black26,size: 18.0,),
          // contentPadding: EdgeInsets.zero,
          title: RichText(
            strutStyle: StrutStyle(),
            text: TextSpan(
              text: keyword.word.substring(0, searchQuery.length),
              style: TextStyle(color: Colors.red,height: 1.0,fontSize: 18),
              children: <TextSpan>[
                TextSpan(
                  text: keyword.word.substring(searchQuery.length),
                  style: TextStyle(color: Colors.black)
                )
              ]
            )
          ),
          onTap: () => this.inputSubmit(keyword.word)
        ),
      )
    );
  }

}
