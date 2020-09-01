# v1

```dart
part of 'main.dart';

class View extends _State with _Bar, _Gesture {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: ScrollPage(
        controller: controller,
        child: _scrollView()
      ),
      // extendBody: true,
      bottomNavigationBar: _BottomSheet(
        // key: ValueKey<int>(112),
        // key: _scaffoldKeyBottom,
        primaryBible:bible,
        nextChapter: setChapterNext,
        previousChapter: setChapterPrevious,
        verseSelectionList: verseSelectionList,
        verseSelectionCopy: verseSelectionCopy,
      )
    );
  }

  Widget _scrollView() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: isNotReady?_readChapter:_loadChapter
        )
      ]
    );
  }

  Widget get _readChapter {
    // NOTE: this method executed when identify is change
    return FutureBuilder<bool>(
      future: getResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return WidgetMessage(message: 'A moment...');
          case ConnectionState.active:
            return WidgetMessage(message: 'loading..');
          case ConnectionState.none:
            return WidgetMessage(message: 'getting ready...');
          case ConnectionState.done:
          default:
            return _loadChapterBuilder(snapshot);
        }
      }
    );
  }

  Widget get _loadChapter {
    // NOTE: this method executed upon initial or when bookId and chapterId are change
    return FutureBuilder<bool>(
      future: getResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => _loadChapterBuilder(snapshot)
    );
  }

  Widget _loadChapterBuilder(AsyncSnapshot<bool> snapshot){
    // // print(3);
    // return _loadVerse();
    if (snapshot.hasError) {
      return WidgetMessage(message: snapshot.error.toString());
    }
    if (snapshot.hasData) {
      if (snapshot.data) {
        return _loadVerse();
      } else {
        // NOTE: no Book is loaded for reading
        return WidgetMessage(message: 'Something went wrong');
      }
    } else {
      return WidgetMessage(message: 'A moment');
    }
  }

  Widget _loadVerse(){
    // print(4);
    // SliverToBoxAdapter
    // SliverFillViewport
    // SliverFillRemaining
    // SliverFillViewport();
    return new SliverToBoxAdapter(
      // fillOverscroll: true,
      // hasScrollBody: true,
      child: chapterGesture(
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          // physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          // controller: autoScrollController,
          // controller: controller,
          itemCount: tmpverse.length,
          padding: EdgeInsets.symmetric(vertical: 7.0),
          itemBuilder: (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
        )
        // child: ScrollablePositionedList.builder(
        //   // scrollDirection: Axis.horizontal,
        //   physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        //   addAutomaticKeepAlives: true,
        //   initialScrollIndex: 0,
        //   itemPositionsListener: itemPositionsListener,
        //   itemCount: tmpverse.length,
        //   // padding: EdgeInsets.symmetric(vertical: 7.0),
        //   itemBuilder: (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
        // )
      ),
    );
  }

  Widget _inheritedVerse(BuildContext context, int index, VERSE verse){
    return AutoScrollTag(
      key: ValueKey<int>(index),
      controller: autoScrollController,
      highlightColor: Colors.red,
      // controller: controller,
      index: index,
      child: VerseInheritedWidget(
        size: core.fontSize,
        lang: core.collectionLanguagePrimary.name,
        selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
        child: WidgetVerse(
          verse: verse,
          selection: verseSelection,
        )
      ),
    );
    // return VerseInheritedWidget(
    //   size: core.fontSize,
    //   lang: core.collectionLanguagePrimary.name,
    //   selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
    //   child: WidgetVerse(
    //     verse: verse,
    //     selection: verseSelection,
    //   )
    // );
  }

}
