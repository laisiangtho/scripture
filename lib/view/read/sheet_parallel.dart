part of 'main.dart';

class SheetParallel extends StatefulWidget {
  final ScrollController controller;
  final List<int> verseSelectionList;
  final Future<void> Function(int, {bool isId}) scrollToIndex;

  const SheetParallel({
    Key? key,
    required this.controller,
    required this.verseSelectionList,
    required this.scrollToIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetParallelState();
}

class _SheetParallelState extends State<SheetParallel> with TickerProviderStateMixin {
  late final Core core = context.read<Core>();
  late final Future<DefinitionBible> initiator = core.scriptureParallel.init();

  // DefinitionBible get bibleInfo => core.collectionPrimary;
  BIBLE get bible => core.scriptureParallel.verseChapter;
  // BookType get tmpbible => bible.info;
  // DefinitionBook get tmpbook => bible.book.first.info;
  CHAPTER get tmpchapter => bible.book.first.chapter.first;
  List<VERSE> get tmpverse => tmpchapter.verse;

  Preference get preference => core.preference;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  void verseScroll(int id) {
    widget.scrollToIndex(id, isId: true);
  }

  void _showParallelList() {
    AppRoutes.showParallelList(context);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return ViewPage(
      child: FutureBuilder<DefinitionBible>(
        // key: widget.key,
        future: initiator,
        builder: (BuildContext context, AsyncSnapshot<DefinitionBible> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return body();
            default:
              return const Center(
                child: Text('A moment'),
              );
          }
        },
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      primary: false,
      // controller: widget.controller,
      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // physics: const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        // SliverAppBar(
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 0,
        //   // title: Text(tmpbible.name),
        //   title: Selector<Core, BIBLE>(
        //     selector: (_, e) => e.scriptureParallel.verseChapter,
        //     builder: (BuildContext context, BIBLE i, Widget? child) => Text(i.info.name),
        //   ),
        //   actions: <Widget>[
        //     Tooltip(
        //       message: 'Select Parallel',
        //       child: CupertinoButton(
        //         // onPressed: () => Navigator.of(context).push(_showHome()),
        //         onPressed: () => false,
        //         child: const Icon(Icons.linear_scale),
        //       ),
        //     ),
        //   ],
        // ),
        ViewHeaderSliverSnap(
          pinned: false,
          floating: false,
          heights: const [kBottomNavigationBarHeight],
          // overlapsBackgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          // overlapsForce: true,
          builder: (BuildContext _, ViewHeaderData org, ViewHeaderData snap) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<Core, BIBLE>(
                    selector: (_, e) => e.scriptureParallel.verseChapter,
                    builder: (BuildContext _, BIBLE i, Widget? child) => Text(
                      i.info.name,
                      // style: const TextStyle(
                      //   fontSize: 16,
                      // ),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  CupertinoButton(
                    // onPressed: _showBible, //() => Navigator.of(context).push(_showHome()),
                    // child: const Icon(Icons.linear_scale),
                    padding: EdgeInsets.zero,
                    child: WidgetLabel(
                      icon: Icons.linear_scale,
                      message: preference.text.chooseTo(preference.text.bible(false)),
                    ),
                    onPressed: () => _showParallelList(),
                  )
                ],
              ),
            );
          },
        ),
        Selector<Core, BIBLE>(
          selector: (_, e) => e.scriptureParallel.verseChapter,
          builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
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
      ],
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
                title: Selector<Core, BIBLE>(
                  selector: (_, e) => e.scriptureParallel.verseChapter,
                  builder: (BuildContext context, BIBLE i, Widget? child) => Text(i.info.name),
                ),
                actions: <Widget>[
                  Tooltip(
                    message: 'Select Parallel',
                    child: CupertinoButton(
                      // onPressed: () => Navigator.of(context).push(_showHome()),
                      onPressed: () => false,
                      child: const Icon(Icons.linear_scale),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              // primary: true,
              // controller: widget.controller,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                Selector<Core, BIBLE>(
                  selector: (_, e) => e.scriptureParallel.verseChapter,
                  builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _inheritedVerse(VERSE verse) {
    return VerseWidgetInherited(
      // key: verse.key,
      size: core.collection.setting.fontSize,
      lang: core.scriptureParallel.info.langCode,
      selected: false,
      child: WidgetVerse(verse: verse, onPressed: verseScroll),
    );
  }
}
