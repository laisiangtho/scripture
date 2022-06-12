part of 'main.dart';

class SheetParallel extends StatefulWidget {
  final ScrollController controller;

  final Future<void> Function(int, {bool isId}) scrollToIndex;

  const SheetParallel({
    Key? key,
    required this.controller,
    required this.scrollToIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetParallelState();
}

class _SheetParallelState extends State<SheetParallel> with TickerProviderStateMixin {
  late final Core core = context.read<Core>();
  late final Preference preference = context.read<Preference>();
  late final Future<DefinitionBible> initiator = core.scriptureParallel.init();

  // DefinitionBible get bibleInfo => core.collectionPrimary;
  BIBLE get bible => core.scriptureParallel.verseChapter;
  // BooksType get tmpbible => bible.info;
  // DefinitionBook get tmpbook => bible.book.first.info;
  CHAPTER get tmpchapter => bible.book.first.chapter.first;
  List<VERSE> get tmpverse => tmpchapter.verse;

  @override
  void initState() {
    super.initState();
  }

  void verseScroll(int id) {
    widget.scrollToIndex(id, isId: true);
  }

  void _showParallelList() {
    // AppRoutes.showParallelList(context);
    Navigator.of(context, rootNavigator: true).pushNamed('/launch/bible');
    // core.navigate();
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
              return Center(
                child: Text(preference.text.aMoment),
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
          heights: const [kToolbarHeight],
          builder: (BuildContext _, ViewHeaderData org) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<Core, BIBLE>(
                    selector: (_, e) => e.scriptureParallel.verseChapter,
                    builder: (BuildContext _, BIBLE i, Widget? child) => Text(
                      i.info.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  WidgetButton(
                    message: preference.text.chooseTo(preference.text.bible(false)),
                    onPressed: _showParallelList,
                    child: const WidgetLabel(
                      icon: Icons.linear_scale,
                    ),
                  )
                ],
              ),
            );
          },
        ),
        // Selector<Core, BIBLE>(
        //   selector: (_, e) => e.scriptureParallel.verseChapter,
        //   builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //       (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
        //       childCount: tmpverse.length,
        //       // addAutomaticKeepAlives: true
        //     ),
        //   ),
        // ),
        StreamBuilder(
          initialData: core.collection.boxOfSettings.fontSize(),
          stream: core.collection.boxOfSettings.watch(key: 'fontSize'),
          builder: (BuildContext _, e) {
            return Selector<Core, BIBLE>(
              selector: (_, e) => e.scriptureParallel.verseChapter,
              builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
                  childCount: tmpverse.length,
                  // addAutomaticKeepAlives: true
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget bodyTmp() {
    return Scaffold(
      body: NestedScrollView(
        // controller: widget.controller,
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
                    child: WidgetButton(
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
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                StreamBuilder(
                  initialData: core.collection.boxOfSettings.fontSize(),
                  stream: core.collection.boxOfSettings.watch(key: 'fontSize'),
                  builder: (BuildContext _, e) {
                    return Selector<Core, BIBLE>(
                      selector: (_, e) => e.scriptureParallel.verseChapter,
                      builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
                          childCount: tmpverse.length,
                          // addAutomaticKeepAlives: true
                        ),
                      ),
                    );
                  },
                ),

                // Selector<Core, BIBLE>(
                //   selector: (_, e) => e.scriptureParallel.verseChapter,
                //   builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
                //     delegate: SliverChildBuilderDelegate(
                //       (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
                //       childCount: tmpverse.length,
                //       // addAutomaticKeepAlives: true
                //     ),
                //   ),
                // ),
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
      // size: core.collection.setting.fontSize,
      size: core.collection.boxOfSettings.fontSize().asDouble,
      lang: core.scriptureParallel.info.langCode,
      selected: false,
      child: WidgetVerse(verse: verse, onPressed: verseScroll),
    );
  }
}
