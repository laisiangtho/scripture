part of 'main.dart';

class SheetParallel extends StatefulWidget {
  final ScrollController controller;
  final List<int> verseSelectionList;
  final Future<void> Function(int,{bool isId}) scrollToIndex;

  SheetParallel({
    Key? key,
    required this.controller,
    required this.verseSelectionList,
    required this.scrollToIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetParallelState();
}

class _SheetParallelState extends State<SheetParallel> with TickerProviderStateMixin {
  late Core core;
  late Future<DefinitionBible> initiator;

  // DefinitionBible get bibleInfo => core.collectionPrimary;
  BIBLE get bible => core.scriptureParallel.verseChapter;
  // BookType get tmpbible => bible.info;
  // DefinitionBook get tmpbook => bible.book.first.info;
  CHAPTER get tmpchapter => bible.book.first.chapter.first;
  List<VERSE> get tmpverse => tmpchapter.verse;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    initiator = core.scriptureParallel.init();
  }

  void verseScroll(int id) {
    widget.scrollToIndex(id,isId:true);
  }

  Route _showHome() {
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => Scaffold(
    //       body: new Home.Main(),
    //     )
    //   )
    // );
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        body: new Home.Main(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return FutureBuilder<DefinitionBible>(
      // key: widget.key,
      future: initiator,
      builder: (BuildContext context, AsyncSnapshot<DefinitionBible> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return body();
          default:
            return WidgetMsg(message: 'A moment',);
        }
      }
    );
  }

  Widget body() {
    return CustomScrollView(
      // primary: true,
      // controller: widget.controller,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          // title: Text(tmpbible.name),
          title: Selector<Core,BIBLE>(
            selector: (_, e) => e.scriptureParallel.verseChapter,
            builder: (BuildContext context, BIBLE i, Widget? child) => Text(i.info.name)
          ),
          actions: <Widget>[
            Tooltip(
              message: 'Select Parallel',
              child: CupertinoButton(
                onPressed: () => Navigator.of(context).push(_showHome()),
                child:Icon(Icons.linear_scale),
              ),
            )
          ]
        ),
        Selector<Core,BIBLE>(
          selector: (_, e) => e.scriptureParallel.verseChapter,
          builder: (BuildContext context, BIBLE message, Widget? child) => new SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
              childCount: tmpverse.length,
              // addAutomaticKeepAlives: true
            ),
          ),
        ),
        // new SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
        //     childCount: tmpverse.length,
        //     // addAutomaticKeepAlives: true
        //   ),
        // )
        // new SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (BuildContext context, int index) => Card(
        //       child: Padding(
        //         padding: EdgeInsets.all(30),
        //         child: Text('index $index'),
        //       ),
        //     ),
        //     childCount: 40,
        //     // addAutomaticKeepAlives: true
        //   ),
        // ),
      ]
    );
  }
  Widget bodyTmp() {
    return Scaffold(
      body: NestedScrollView(
        controller: widget.controller,
        // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // title: Text(tmpbible.name),
                title: Selector<Core,BIBLE>(
                  selector: (_, e) => e.scriptureParallel.verseChapter,
                  builder: (BuildContext context, BIBLE i, Widget? child) => Text(i.info.name)
                ),
                actions: <Widget>[
                  Tooltip(
                    message: 'Select Parallel',
                    child: CupertinoButton(
                      onPressed: () => Navigator.of(context).push(_showHome()),
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
              // primary: true,
              // controller: widget.controller,
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                ),
                Selector<Core,BIBLE>(
                  selector: (_, e) => e.scriptureParallel.verseChapter,
                  builder: (BuildContext context, BIBLE message, Widget? child) => new SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
                      childCount: tmpverse.length,
                      // addAutomaticKeepAlives: true
                    ),
                  ),
                ),
                // new SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
                //     childCount: tmpverse.length,
                //     // addAutomaticKeepAlives: true
                //   ),
                // )
                // new SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (BuildContext context, int index) => Card(
                //       child: Padding(
                //         padding: EdgeInsets.all(30),
                //         child: Text('index $index'),
                //       ),
                //     ),
                //     childCount: 40,
                //     // addAutomaticKeepAlives: true
                //   ),
                // ),
              ]
            );
          }
        )
      ),
    );
  }

  Widget _inheritedVerse(VERSE verse){
    return VerseInheritedWidget(
      // key: verse.key,
      size: core.collection.setting.fontSize,
      lang: core.scriptureParallel.info.langCode,
      selected: false,
      child: WidgetVerse(
        verse: verse,
        onPressed: verseScroll
      )
    );
  }
}