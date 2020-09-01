# static

```dart
part of 'main.dart';

class BottomSheetParallel extends StatefulWidget {
  BottomSheetParallel({Key key,this.controller}) : super(key: key);

  final ScrollController controller;
  @override
  _BottomSheetParallelState createState() => _BottomSheetParallelState();
}

class _BottomSheetParallelState extends State<BottomSheetParallel> {
  final core = Core();


  // String parallelId = '';

  Future<BIBLE> _dataResult;
  Future<BIBLE> get getResult => _dataResult=hasNotResult?_newResult:_dataResult;
  Future<BIBLE> get _newResult async => core.verseParallelChapter();

  bool get hasNotResult => core.parallelScripture.verseChapterDataIsEmpty(
    id: core.parallelId,
    testament: core.testamentId,
    book: core.bookId,
    chapter: core.chapterId
  );
  bool get isNotReady => hasNotResult && core.parallelScripture.notReady();
  // Future<BIBLE> get getResult => core.verseParallelChapter();

  BIBLE get bible => core.parallelScripture.verseChapterData;
  // bool get hasNotResult => core.verseChapterDataIsEmpty();
  // bool get isNotReady => hasNotResult && core.userBible == null && core.userBibleList.length == 0;

  // BIBLE get bible => core.verseChapterData;
  // CollectionBible get bibleInfo => core.getCollectionBible;
  // CollectionBible get tmpbible => bible?.info;
  // DefinitionBook get tmpbook => bible?.book?.first?.info;
  CHAPTER get tmpchapter => bible?.book?.first?.chapter?.first;
  List<VERSE> get tmpverse => tmpchapter?.verse;

  @override
  // Widget build(BuildContext context) =>Center(child: Text('parallel'));
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverPadding(
          // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,bottom: MediaQuery.of(context).padding.bottom),
          padding: EdgeInsets.zero,
          // sliver: isNotReady?_readChapter:_loadChapter
          sliver: _readChapter()
        )
      ]
    );
  }

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: false,
      floating:false,
      delegate: new ScrollBarDelegate(
        bar,
      )
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return Center(
      // child: Text('Hello'),
      child: FlatButton(
        onPressed: (){
          // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new TestRoute(), maintainState: true));
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => new Home.Main(), maintainState: true)
          ).whenComplete((){
            print('done');
          });
        },
        child: Text('change bible')
      ),
    );
  }

  Widget _readChapter(){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          child: Text('test $index'),
        ),
        addAutomaticKeepAlives: false,
        childCount: 50,
        // addAutomaticKeepAlives: true
      ),
    );
  }

}