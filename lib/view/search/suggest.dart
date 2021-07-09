part of 'main.dart';

mixin _Suggest on _State {
  Widget suggest(){
    return Selector<Core,BIBLE>(
      selector: (_, e) => e.scripturePrimary.verseSearch,
      builder: (BuildContext context, BIBLE o, Widget? child) {
        if (o.query.isEmpty){
          return _suggestNoQuery();
        } else if (o.verseCount > 0){
          return _suggestBook();
        } else {
          return _suggestNoMatch();
        }
      }
    );
  }

  Widget _suggestNoQuery(){
    return Selector<Core,Iterable<MapEntry<dynamic, HistoryType>>>(
      selector: (_, e) => e.collection.history(),
      builder: (BuildContext context, Iterable<MapEntry<dynamic, HistoryType>> items, Widget? child) => _suggestHistory(items)
    );
  }

  Widget _suggestNoMatch(){
    return WidgetMessage(
      message: 'suggest: not found',
    );
  }

  Widget _suggestBook() {
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
              _suggestChapter(book.chapter)
            ]
          );
        },
        childCount: bible.book.length
      )
    );
  }

  Widget _suggestChapter(List<CHAPTER> chapters) {
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
            _suggestVerse(chapter.verse)
          ]
        );
      }
    );
  }

  Widget _suggestVerse(List<VERSE> verses) {
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
          keyword: searchQuery,
          // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
          alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => e.name).join(', '):''
        );
      }
    );
  }

  Widget _suggestHistory(Iterable<MapEntry<dynamic, HistoryType>> items){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _suggestHistoryItem(index, items.elementAt(index)),
        childCount: items.length,
      ),
    );
  }

  Dismissible _suggestHistoryItem(int index, MapEntry<dynamic, HistoryType> item){
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: _suggestHistoryDecoration(
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          title: _suggestHistoryWord(item.value.word),
          minLeadingWidth : 10,
          // leading: Icon(Icons.manage_search_rounded),
          leading: Icon(
            CupertinoIcons.arrow_turn_down_right,
            semanticLabel: 'Suggestion'
          ),
          trailing:Chip(
            avatar: CircleAvatar(
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.saved_search_outlined, color: Theme.of(context).primaryColor,),
            ),
            label: Text(item.value.hit.toString()),
          ),
          onTap: ()=>onSearch(item.value.word)
        )
      ),
      background: _suggestHistoryDismissibleBackground(),
      // secondaryBackground: _suggestHistoryDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
      }
    );
  }

  Widget _suggestHistoryWord(String word){
    int hightlight = searchQuery.length < word.length ? searchQuery.length : word.length;
    return RichText(
      // strutStyle: StrutStyle(height: 1.0),
      text: TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.caption!.color,
          // color: Theme.of(context).primaryTextTheme.button!.color,
          fontWeight: FontWeight.w300
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.button!.color
            )
          )
        ]
      )
    );
  }

  Widget _suggestHistoryDecoration({required Widget child}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      // margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.1,
            offset: Offset(0.0, .0)
          )
        ]
      ),
      child:child
    );
  }

  Widget _suggestHistoryDismissibleBackground() {
    return Container(
      // color: Theme.of(context).highlightColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Remove",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}