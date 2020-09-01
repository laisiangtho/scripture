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
        // primaryBible:bible,
        nextChapter: setChapterNext,
        previousChapter: setChapterPrevious,
        verseSelectionList: verseSelectionList,
        verseSelectionCopy: verseSelectionCopy,
        scrollToIndex: scrollToIndex,
      )
    );
  }

  Widget _scrollView_nested_ok() {
    return NestedScrollView(
      controller: controller,
      headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle:NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: sliverPersistentHeader(),
          ),
        ];
      },
      body:Builder(
        builder: (BuildContext context) => CustomScrollView(
          // controller: controller,
          primary: true,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              // sliver: sliverPersistentHeader(),
            ),
            new SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              sliver: isNotReady?_readChapter:_loadChapter
            )
          ],
        ),
      )
    );
  }

  Widget _scrollView() {
    return NestedScrollView(
        controller: controller,
        // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // print(innerBoxIsScrolled);
          return <Widget>[
            sliverPersistentHeader(),
            // SliverOverlapAbsorber(
            //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            //   sliver: SliverAppBar(
            //     backgroundColor: Colors.transparent,
            //     elevation: 0,
            //     title: Text('widgetTitle'),
            //     actions: <Widget>[
            //       CupertinoButton(
            //         onPressed: null,
            //         child:Icon(Icons.linear_scale),
            //       )
            //     ]
            //   )
            // ),
            // new SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) => Container(
            //       child: Text('test $index'),
            //     ),
            //     childCount: 20,
            //     // addAutomaticKeepAlives: true
            //   ),
            // )
          ];
        },
        body:isNotReady?_readChapter:_loadChapter
    );
  }

  Widget _scrollView_() {
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
            return WidgetMsg(message: 'A moment...');
          case ConnectionState.active:
            return WidgetMsg(message: 'loading..');
          case ConnectionState.none:
            return WidgetMsg(message: 'getting ready...');
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
      return WidgetMsg(message: snapshot.error.toString());
    }
    if (snapshot.hasData) {
      if (snapshot.data) {
        return _loadVerse();
      } else {
        // NOTE: no Book is loaded for reading
        return WidgetMsg(message: 'Something went wrong');
      }
    } else {
      return WidgetMsg(message: 'A moment');
    }
  }

  Widget _loadVerse(){
    // print(4);
    return chapterGesture(
      child: ListView.builder(
        key: UniqueKey(),
        addAutomaticKeepAlives: true,
        // physics: ScrollPhysics(),
        // shrinkWrap: true,
        // primary: true,
        // controller: autoScrollController,
        // controller: controller,
        itemCount: tmpverse.length,
        padding: EdgeInsets.symmetric(vertical: 7.0),
        itemBuilder: (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
      )
    );
  }

  Widget _inheritedVerse(BuildContext context, int index, VERSE verse){
    return VerseInheritedWidget(
      key: verse.key,
      size: core.fontSize,
      lang: core.collectionLanguagePrimary.name,
      selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
      child: WidgetVerse(
        verse: verse,
        selection: verseSelection,
      )
    );
  }

}
