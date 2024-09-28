import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/icon.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends CommonStates<Main> with TickerProviderStateMixin {
  Scripture get primaryScripture => app.scripturePrimary;
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  Scripture get parallelScripture => app.scriptureParallel;
  List<OfVerse> get parallelVerse => parallelScripture.verse;

  late final headerHeight = kTextTabBarHeight;

  // late final Future<OfBible> initiator = parallelScripture.init();

  // @override
  // void initState() {
  //   super.initState();
  // }

  void _showParallelList() {
    // AppRoutes.showParallelList(context);
    // home/bible
    // Navigator.of(context, rootNavigator: true).pushNamed('/launch/bible');
    // Navigator.of(context, rootNavigator: true).pushNamed('/home/bible');
    // app.route.page.go('/read', extra: {'parallel': true});

    app.route.page.push('/bible', extra: {'parallel': true});
  }

  void setChapterPrevious() {
    app.chapterPrevious.catchError((e) {
      showSnack(e.toString());
    });
  }

  void setChapterNext() {
    app.chapterNext.catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  late final screenWidth = MediaQuery.of(context).size.width;
  late final buttonWidth = screenWidth / 4;
}

mixin _Header on _State {
  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: headerHeight,

      // primary: ViewHeaderTitle.fixed(
      //   // alignment: Alignment.lerp(
      //   //   const Alignment(0, 0),
      //   //   const Alignment(0, 0),
      //   //   vhd.snapShrink,
      //   // ),
      //   label: lang.book('true'),
      // ),
      primary: buttonList(),
    );
  }

  Widget buttonList() {
    // final a1 = MediaQuery.of(context).size.width;
    // final width = a1 / 4;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        buttonItem(
          width: buttonWidth,
          message: lang.previousTo(lang.chapter('false')),
          onPressed: setChapterPrevious,
          child: const ViewMarks(icon: LideaIcon.chapterPrevious, iconSize: 22),
        ),
        buttonItem(
          width: buttonWidth,
          message: lang.nextTo(lang.chapter('false')),
          onPressed: setChapterNext,
          child: const ViewMarks(icon: LideaIcon.chapterNext, iconSize: 22),
        ),
        buttonItem(
          width: buttonWidth,
          message: lang.compareTo(lang.parallel),
          onPressed: state.param.map['scrollToggle'],
          child: const ViewMarks(icon: LideaIcon.language, iconSize: 20),
        ),
        buttonItem(
          width: buttonWidth,
          message: lang.title("true"),
          onPressed: () {
            final msh = app.route.showModalSheet<Map<String, dynamic>?>(
              child: app.route.sheetConfig(
                name: '/recto-title',
              ),
            );

            msh.then((e) {
              if (e != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
                });
              }
            });
          },
          child: ViewMarks(
            // icon: Icons.linear_scale_rounded,
            icon: Icons.signpost_rounded,
            iconColor: theme.primaryColorDark.withOpacity(0.6),
            iconSize: 20,
          ),
        ),
        buttonItem(
          width: buttonWidth,
          onPressed: () {
            final msh = app.route.showModalSheet<Map<String, dynamic>?>(
              child: app.route.sheetConfig(
                name: '/recto-merge',
              ),
            );

            msh.then((e) {
              if (e != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
                });
              }
            });
          },
          message: 'Verse merges',
          child: ViewMarks(
            icon: Icons.merge,
            iconColor: theme.primaryColorDark.withOpacity(0.6),
            iconSize: 20,
          ),
        ),
        // buttonItem(
        //   width: buttonWidth,
        //   child: const ViewMarks(icon: Icons.more_horiz, iconSize: 20),
        // ),
      ],
    );
  }

  Widget buttonItem({
    required double width,
    required Widget child,
    void Function()? onPressed,
    String? message,
  }) {
    return ViewButtons(
      constraints: BoxConstraints(minWidth: width, maxWidth: width),
      padding: EdgeInsets.zero,
      message: message,
      tooltip: false,
      onPressed: onPressed,
      child: child,
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: ViewBars(
        height: headerHeight,
        // forceOverlaps: false,
        // forceStretch: true,
        // backgroundColor: theme.primaryColor,
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,
        overlapsBorderWidth: 0.2,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.primaryColor,
            theme.scaffoldBackgroundColor,
          ],
        ),
        child: _header(),
      ),
      body: Views(
        child: FutureBuilder<OfBible>(
          future: parallelScripture.init(),
          builder: (BuildContext context, AsyncSnapshot<OfBible> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return body();
              default:
                // return Center(
                //   child: Text(lang.aMoment),
                // );
                return ViewFeedbacks.message(
                  label: lang.aMoment,
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
      slivers: <Widget>[
        ViewHeaderSliver(
          pinned: false,
          floating: false,
          // pinned: true,
          // floating: true,
          // heights: const [kTextTabBarHeight - 15],
          // overlapsBorderColor: theme.dividerColor,

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
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  // ViewButtons(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('recto-title');
                  //   },
                  //   child: const ViewLabels(
                  //     icon: Icons.abc_outlined,
                  //   ),
                  // ),

                  ViewButtons(
                    message: lang.chooseTo(lang.bible('false')),
                    onPressed: _showParallelList,
                    child: const ViewLabels(
                      icon: Icons.linear_scale,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // const SliverToBoxAdapter(
        //   child: Text('????'),
        // ),
        StreamBuilder(
          initialData: data.boxOfSettings.fontSize(),
          stream: data.boxOfSettings.watch(key: 'fontSize'),
          builder: (BuildContext _, e) {
            return Selector<Core, CacheBible>(
              selector: (_, e) => e.scriptureParallel.read,
              builder: (BuildContext _, CacheBible i, Widget? child) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext _, int index) => _inheritedVerse(parallelVerse.elementAt(index)),
                    childCount: parallelVerse.length,
                    // addAutomaticKeepAlives: true
                  ),
                );
              },
              // builder: (BuildContext _, CacheBible message, Widget? child) => SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext _, int index) => _inheritedVerse(parallelVerse.elementAt(index)),
              //     childCount: parallelVerse.length,
              //     // addAutomaticKeepAlives: true
              //   ),
              // ),
            );
            // return ViewCards(
            //   sliver: true,
            //   child: Text('test: ${parallelVerse.length}'),
            // );
            // return const SliverToBoxAdapter(
            //   child: Text('????'),
            // );
          },
        ),
      ],
    );
  }

  Widget _inheritedVerse(OfVerse verse) {
    return VerseWidgetInherited(
      // key: verse.key,
      size: data.boxOfSettings.fontSize().asDouble,
      scripture: parallelScripture,
      verseId: verse.id,
      child: VerseItemWidget(
        verse: verse,
        onPressed: primaryScripture.scrollToIndex,
      ),
    );
  }
}
