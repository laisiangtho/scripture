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
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  Scripture get parallelScripture => core.scriptureParallel;
  List<OfVerse> get parallelVerse => parallelScripture.verse;

  late final Future<OfBible> initiator = parallelScripture.init();

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
        child: FutureBuilder<OfBible>(
          // key: widget.key,
          future: initiator,
          builder: (BuildContext context, AsyncSnapshot<OfBible> snapshot) {
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
          // pinned: true,
          // floating: false,
          heights: const [kTextTabBarHeight],
          overlapsBorderColor: Theme.of(context).dividerColor,
          builder: (BuildContext _, ViewHeaderData vhd) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<Core, CacheBible>(
                    selector: (_, e) => e.scriptureParallel.read,
                    builder: (BuildContext _, CacheBible i, Widget? child) => Text(
                      i.result.info.shortname,
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
            return Selector<Core, CacheBible>(
              selector: (_, e) => e.scriptureParallel.read,
              builder: (BuildContext context, CacheBible message, Widget? child) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      _inheritedVerse(parallelVerse.elementAt(index)),
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
        const SliverPadding(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        ),
      ],
    );
  }

  Widget _inheritedVerse(OfVerse verse) {
    return VerseWidgetInherited(
      // key: verse.key,
      size: data.boxOfSettings.fontSize().asDouble,
      lang: parallelScripture.info.langCode,
      verseId: verse.id,
      child: VerseItemWidget(verse: verse, onPressed: primaryScripture.scrollToIndex),
    );
  }
}
