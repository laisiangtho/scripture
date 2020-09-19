part of 'main.dart';

class BottomSheetParallel extends StatefulWidget {
  BottomSheetParallel({
    Key key,
    this.controller,
    this.verseSelectionList,
    this.scrollToIndex,
  }) : super(key: key);
  final ScrollController controller;
  final List<int> verseSelectionList;
  final Future<void> Function(int,{bool isId}) scrollToIndex;

  @override
  BottomSheetParallelState createState() => BottomSheetParallelState();
}

class BottomSheetParallelState extends State<BottomSheetParallel> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final core = Core();


  // String parallelId = '';

  // BIBLE get primaryBible => core.primaryScripture.verseChapterData;
  // CollectionBible get primaryInfo => core.getCollectionPrimary;
  CollectionBible get parallelInfo => core.collectionParallel;
  // String get title => 'Parallel tmp';
  // String get title => primaryInfo.name +''+ primaryInfo.shortname;
  String get widgetTitle => parallelInfo.shortname;

  Future<BIBLE> _dataResult;
  Future<BIBLE> get getResult => _dataResult=hasNotResult?_newResult:_dataResult;
  Future<BIBLE> get _newResult async => core.verseParallelChapter();

  bool get hasNotResult => core.scriptureParallel.verseChapterDataIsEmpty(
    id: core.parallelId,
    testament: core.testamentId,
    book: core.bookId,
    chapter: core.chapterId
  );
  bool get isNotReady => hasNotResult && core.scriptureParallel.notReady();
  // Future<BIBLE> get getResult => core.verseParallelChapter();

  BIBLE get bible => core.scriptureParallel.verseChapterData;
  // bool get hasNotResult => core.verseChapterDataIsEmpty();
  // bool get isNotReady => hasNotResult && core.userBible == null && core.userBibleList.length == 0;

  // BIBLE get bible => core.verseChapterData;
  // CollectionBible get bibleInfo => core.getCollectionBible;
  // CollectionBible get tmpbible => bible?.info;
  // DefinitionBook get tmpbook => bible?.book?.first?.info;
  CHAPTER get tmpchapter => bible?.book?.first?.chapter?.first;
  List<VERSE> get tmpverse => tmpchapter?.verse;

  void verseScroll(int id) {
    widget.scrollToIndex(id,isId:true);
    // print('scroll to: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // controller: widget.controller,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(widgetTitle),
                actions: <Widget>[
                  Tooltip(
                    message: 'Select Parallel',
                    child: CupertinoButton(
                      onPressed: (){
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => new Home.Main(title: 'Parallel',))
                        );
                      },
                      child:Icon(Icons.linear_scale),
                    ),
                  )
                ]
              )
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                ),
                _readChapter,
              ]
            );
          }
        )
      ),
    );
  }

  Widget get _readChapter {
    // NOTE: this method executed when identify is change
    return FutureBuilder<BIBLE>(
      future: getResult,
      builder: (BuildContext context, AsyncSnapshot<BIBLE> snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return WidgetMessage(message: 'A moment...');
          case ConnectionState.active:
            return WidgetMessage(message: 'Loading...');
          case ConnectionState.none:
            // return WidgetMessage(message: 'getting ready...');
          case ConnectionState.done:
          default:
            // return _loadChapterBuilder(snapshot);
            return _loadVerse();
        }
      }
    );
  }

  // Widget get _loadChapter {
  //   print('_loadChapter');
  //   // NOTE: this method executed upon initial or when bookId and chapterId are change
  //   return FutureBuilder<BIBLE>(
  //     future: getResult,
  //     builder: (BuildContext context, AsyncSnapshot<BIBLE> snapshot) => _loadChapterBuilder(snapshot)
  //   );
  // }

  // Widget _loadChapterBuilder(AsyncSnapshot<BIBLE> snapshot){
  //   // // print(3);
  //   // return _loadVerse();
  //   if (snapshot.hasError) {
  //     return _msg(snapshot.error.toString());
  //   }
  //   // return _loadVerse();
  //   print('snapshot.data ${snapshot.data}');
  //   if (snapshot.hasData) {
  //     if (snapshot.data == null) {
  //       // NOTE: no Book is loaded for reading
  //       return _msg('Something went wrong');
  //     } else {
  //       return _loadVerse();
  //     }
  //   } else {
  //     return _msg('A moment, load');
  //   }
  // }

  Widget _loadVerse(){
    // print(4);
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical:10),
      sliver: SliverList(
        key: ValueKey<int>(34),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
          childCount: tmpverse.length,
        ),
      ),
    );
    // return SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
    //     childCount: tmpverse.length,
    //   ),
    // );
    // return new SliverFillRemaining(
    //   child: ListView.builder(
    //     // key: PageStorageKey('parallel-verse'),
    //     // key:ValueKey<int>(23656),
    //     // addAutomaticKeepAlives: true,
    //     // physics: ScrollPhysics(),
    //     // shrinkWrap: true,
    //     // controller: widget.controller,
    //     // primary: false,
    //     itemCount: tmpverse.length,
    //     padding: EdgeInsets.symmetric(vertical: 7.0),
    //     itemBuilder: (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
    //   )
    // );
  }

  Widget _inheritedVerse(BuildContext context, int index, VERSE verse){
    return VerseInheritedWidget(
      size: core.fontSize,
      lang: core.collectionLanguageParallel.name,
      // selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
      child: WidgetVerse(
        verse: verse,
        selection: verseScroll,
        // selection: verseSelection,
      )
    );
  }
}