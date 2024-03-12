part of 'main.dart';

class ParallelContent extends StatefulWidget {
  const ParallelContent({super.key});

  @override
  State<ParallelContent> createState() => _ContentState();
}

class _ContentState extends State<ParallelContent> {
  Core get core => App.core;
  Preference get preference => App.preference;
  Data get data => core.data;

  Scripture get primaryScripture => core.scripturePrimary;
  List<VERSE> get primaryVerse => primaryScripture.verse;

  Scripture get parallelScripture => core.scriptureParallel;
  List<VERSE> get parallelVerse => parallelScripture.verse;

  late final Future<DefinitionBible> initiator = parallelScripture.init();

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _showParallelList() {
    // AppRoutes.showParallelList(context);
    // home/bible
    // Navigator.of(context, rootNavigator: true).pushNamed('/launch/bible');
    // Navigator.of(context, rootNavigator: true).pushNamed('/home/bible');
    App.route.pushNamed('/read/bible', arguments: {'parallel': true});
    // core.navigate();
  }

  @override
  Widget build(BuildContext context) {
    // return const Text('ParallelBody');
    return Scaffold(
      body: Views(
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
        // child: body(),
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
        ViewHeaderSliver(
          pinned: false,
          floating: false,
          heights: const [kToolbarHeight],
          builder: (BuildContext _, ViewHeaderData vhd) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<Core, BIBLE>(
                    selector: (_, e) => e.scriptureParallel.read,
                    builder: (BuildContext _, BIBLE i, Widget? child) => Text(
                      i.info.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ViewButton(
                    message: preference.text.chooseTo(preference.text.bible('false')),
                    onPressed: _showParallelList,
                    child: const ViewLabel(
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
          initialData: data.boxOfSettings.fontSize(),
          stream: data.boxOfSettings.watch(key: 'fontSize'),
          builder: (BuildContext _, e) {
            return Selector<Core, BIBLE>(
              selector: (_, e) => e.scriptureParallel.read,
              builder: (BuildContext context, BIBLE message, Widget? child) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => _inheritedVerse(parallelVerse[index]),
                  childCount: parallelVerse.length,
                  // addAutomaticKeepAlives: true
                ),
              ),
            );
          },
        ),
        // SliverToBoxAdapter(
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: const Text('.animateTo(defaultInitial)'),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: const Text('Scroll to 0'),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: const Text('Scroll to 300'),
        //   ),
        // ),
      ],
    );
  }

  Widget _inheritedVerse(VERSE verse) {
    return VerseWidgetInherited(
      // key: verse.key,
      size: data.boxOfSettings.fontSize().asDouble,
      lang: parallelScripture.info.langCode,
      selected: false,
      child: WidgetVerse(verse: verse, onPressed: primaryScripture.scrollToIndex),
    );
  }
}
