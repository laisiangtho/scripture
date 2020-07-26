part of 'main.dart';

mixin _Suggest on _State {

  Widget suggest() {
    if (this.searchQuery.isEmpty) {
      return _suggestionKeyword();
    }
    return FutureBuilder(
      future: getResult(),
      builder: (BuildContext context, AsyncSnapshot<BIBLE> snapshot) {
        if (snapshot.hasError) {
          print('error');
          return WidgetMessage(message: snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data.book.length > 0) {
            // return _suggestionSingle(snapshot.data);
            return _suggestionMulti(snapshot.data);
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

  // Widget _suggestionSingle(BIBLE bible) {
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

  Widget _suggestionMulti(BIBLE bible) {
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
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: chapters.length,
      itemBuilder: (context, chapterIndex){
        CHAPTER chapter = chapters[chapterIndex];
        return new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text(chapter.name),
            Container(
              margin: EdgeInsets.symmetric(vertical:10),
              child: Text(chapter.name, style: TextStyle(color:Colors.grey),),
            ),
            // Text(chapter.verse.map((e) => e.id).join(', ')),
            _suggestionVerse(chapter.verse)
          ]
        );
      }
    );
  }

  Widget _suggestionVerse(List<VERSE> verses) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      // itemCount: verses.length,
      itemCount: 1,
      itemBuilder: (context, index){
        VERSE verse = verses[index];
        return new WidgetVerse(
          verse:verse,
          keyword: this.searchQuery,
          alsoInVerse: (verses.length > 1)?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
        );
      }
    );
  }


  Widget _suggestionKeyword(){
    return SliverPadding(
      padding: EdgeInsets.only(top: 2),
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
