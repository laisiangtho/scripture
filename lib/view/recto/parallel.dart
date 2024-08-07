import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/icon.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recto-parallel';
  static String label = 'Parallel';
  static IconData icon = Icons.ac_unit;
  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  // late final ScrollController _scrollController = ScrollController();
  Scripture get primaryScripture => core.scripturePrimary;
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  Scripture get parallelScripture => core.scriptureParallel;
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
    route.pushNamed('/read/bible', arguments: {'parallel': true});
    // core.navigate();
  }

  void setChapterPrevious() {
    core.chapterPrevious.catchError((e) {
      showSnack(e.toString());
    });
  }

  void setChapterNext() {
    core.chapterNext.catchError((e) {
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
      //   label: preference.text.book('true'),
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
          message: preference.text.previousTo(preference.text.chapter('false')),
          onPressed: setChapterPrevious,
          child: const ViewMarks(icon: LideaIcon.chapterPrevious, iconSize: 22),
        ),
        buttonItem(
          width: buttonWidth,
          message: preference.text.nextTo(preference.text.chapter('false')),
          onPressed: setChapterNext,
          child: const ViewMarks(icon: LideaIcon.chapterNext, iconSize: 22),
        ),
        buttonItem(
          width: buttonWidth,
          message: preference.text.compareTo(preference.text.parallel),
          // onPressed: scrollAnimateToggle,
          onPressed: state.asMap['presistentToggle'],
          child: const ViewMarks(icon: LideaIcon.language, iconSize: 20),
        ),
        buttonItem(
          width: buttonWidth,
          message: preference.text.title("true"),
          onPressed: () {
            route.showSheetModal(
              context: context,
              name: 'sheet-bible-navigation/recto-title',
              arguments: {'book': primaryScripture.bookCurrent.info.id},
            ).then((e) {
              if (e != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
                });
              }
            });
          },
          child: ViewMarks(
            // icon: Icons.linear_scale_rounded,
            icon: Icons.signpost_rounded,
            iconColor: state.theme.primaryColorDark.withOpacity(0.6),
            iconSize: 20,
          ),
        ),
        buttonItem(
          width: buttonWidth,
          onPressed: () {
            route.showSheetModal(
              context: context,
              name: 'sheet-bible-navigation/recto-merge',
              arguments: {'book': primaryScripture.bookCurrent.info.id},
            ).then((e) {
              if (e != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
                });
              }
            });
          },
          child: ViewMarks(
            icon: Icons.merge,
            iconColor: state.theme.primaryColorDark.withOpacity(0.6),
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

  Widget buttonItem(
      {required double width,
      required Widget child,
      void Function()? onPressed,
      String message = ''}) {
    return ViewButtons(
      constraints: BoxConstraints(minWidth: width, maxWidth: width),
      padding: EdgeInsets.zero,
      // message: message,
      onPressed: onPressed,
      child: child,
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: ViewBars(
        height: headerHeight,
        // forceOverlaps: false,
        // forceStretch: true,
        // backgroundColor: state.theme.primaryColor,
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        overlapsBorderWidth: 0.2,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            state.theme.primaryColor,
            state.theme.scaffoldBackgroundColor,
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
      slivers: <Widget>[
        ViewHeaderSliver(
          pinned: false,
          floating: false,
          // pinned: true,
          // floating: true,
          // heights: const [kTextTabBarHeight - 15],
          // overlapsBorderColor: state.theme.dividerColor,

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
                      style: state.theme.textTheme.titleSmall,
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
                    message: preference.text.chooseTo(preference.text.bible('false')),
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
        StreamBuilder(
          initialData: data.boxOfSettings.fontSize(),
          stream: data.boxOfSettings.watch(key: 'fontSize'),
          builder: (BuildContext _, e) {
            return Selector<Core, CacheBible>(
              selector: (_, e) => e.scriptureParallel.read,
              builder: (BuildContext _, CacheBible message, Widget? child) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext _, int index) => _inheritedVerse(parallelVerse.elementAt(index)),
                  childCount: parallelVerse.length,
                  // addAutomaticKeepAlives: true
                ),
              ),
            );
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
