import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'leaf-section';
  static String label = 'Section';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  Scripture get scripture => App.core.scripturePrimary;
  // List<OfBook> get books => scripture.bookList;
  List<OfTestament> get testaments => scripture.testamentList;

  CategoryBible get category => App.core.category;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: App.preference.text.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, 0),
          vhd.snapShrink,
        ),
        label: App.preference.text.bible('false'),
        data: vhd,
      ),
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: true,
      body: Views(
        // snap: Future.delayed(const Duration(milliseconds: 400)),
        // snapAwait: const ViewFeedback.await(primary: false),
        child: CustomScrollView(
          controller: _controller,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        // floating: false,
        // padding: const EdgeInsets.only(top: 30),
        // heights: const [kToolbarHeight, 100],
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        // overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),

      testamentBuilder(1),
      testamentBuilder(2),

      // for (var t in category.testament)
      //   SliverLayoutBuilder(
      //     builder: (_, __) => testamentBuilder(t.id),
      //   ),
    ];
  }

  Widget testamentBuilder(int tId) {
    final tList = category.book.where((e) => e.testament == tId);
    final sList = tList.map((e) => e.section).toSet();

    return SliverCrossAxisGroup(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          primary: false,
          elevation: 0,
          shadowColor: null,
          automaticallyImplyLeading: false,
          title: Text(App.preference.language('testament-$tId')),
          titleSpacing: 20,
          toolbarHeight: 40,
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          // backgroundColor: Colors.blue,
          // flexibleSpace: FlexibleSpaceBar(
          //   background: Container(
          //     color: Colors.red,
          //   ),
          // ),
        ),
        // SliverLayoutBuilder(
        //   builder: (BuildContext context, constraints) {
        //     final scrolled = constraints.scrollOffset > 0;
        //     return SliverAppBar(
        //       pinned: true,
        //       primary: false,
        //       automaticallyImplyLeading: false,
        //       title: Text(App.preference.language('testament-$tId')),
        //       titleSpacing: 20,
        //       toolbarHeight: 40,
        //       titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        //       backgroundColor: scrolled ? Colors.blue : Colors.red,
        //     );
        //   },
        // ),
        for (var sId in sList)
          SliverLayoutBuilder(
            builder: (a, b) {
              final bList = tList.where((e) => e.section == sId);
              return SliverCrossAxisGroup(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    primary: false,
                    automaticallyImplyLeading: false,
                    elevation: 1,
                    shadowColor: Theme.of(context).shadowColor,
                    title: Text(App.preference.language('section-$sId')),
                    titleSpacing: 30,
                    toolbarHeight: 30,
                    titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  ViewLists.separator(
                    separator: (BuildContext _, int index) {
                      return const ViewDividers();
                    },
                    itemBuilder: (BuildContext _, int index) {
                      final book = bList.elementAt(index);
                      final bId = book.id;
                      return ListTile(
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Text(
                          App.preference.digit(bId),
                          // scripture.digit(book.id),
                          // book.id.toString(),
                          textAlign: TextAlign.center,
                          style: state.textTheme.titleSmall,
                        ),
                        title: Text(App.preference.language('book-$bId')),
                        trailing: ViewMark(
                          iconLeft: false,
                          icon: LideaIcon.rightOpen,
                          iconSize: 28,
                          iconColor: Theme.of(context).hintColor,
                          label: App.preference.digit(book.totalChapter),
                        ),
                        onTap: () {
                          // Navigator.of(context)
                          //     .pushNamed('home/leaf-section/section-chapter', arguments: book);
                          // TODO: testing delay
                          route.showSheetModal(
                            context: context,
                            name: 'sheet-bible-navigation/leaf-book',
                            arguments: {'book': book.id},
                            // showDragHandle: true,
                            // isScrollControlled: true,
                          );
                        },
                      );
                    },
                    // separator: (BuildContext context, int index) {
                    //   return const ViewSectionDivider();
                    // },
                    itemCount: bList.length,
                  ),
                  // SliverList.builder(
                  //   itemBuilder: (BuildContext _, int index) {
                  //     final book = bList.elementAt(index);
                  //     final bId = book.id;
                  //     return ListTile(
                  //       leading: Text(
                  //         App.preference.digit(bId),
                  //         // scripture.digit(book.id),
                  //         // book.id.toString(),
                  //         textAlign: TextAlign.center,
                  //         style: state.textTheme.titleSmall,
                  //       ),
                  //       title: Text(App.preference.language('book-$bId')),
                  //       trailing: ViewMark(
                  //         iconLeft: false,
                  //         icon: LideaIcon.rightOpen,
                  //         iconSize: 28,
                  //         iconColor: Theme.of(context).hintColor,
                  //         label: App.preference.digit(book.totalChapter),
                  //       ),
                  //       onTap: () {
                  //         // App.route.pushNamed('read');
                  //         // App.core.chapterChange(bookId: bId);

                  //         // App.route.pushNamed('home/test-section/test-chapter', arguments: {
                  //         //   'book': [1, 3]
                  //         // });

                  //         // App.route
                  //         //     .pushNamed('home/test-section/test-chapter', arguments: book.toMap());
                  //         // App.route.pushNamed('home/test-section/test-chapter', arguments: book);

                  //         Navigator.of(context)
                  //             .pushNamed('home/test-section/test-chapter', arguments: book);

                  //         // if (!App.core.scripturePrimary.isReady) {
                  //         //   App.core.message.value = App.preference.text.aMoment;
                  //         // }

                  //         // App.route.pushNamed('read');
                  //         // core.chapterChange(bookId: bId).whenComplete(() {
                  //         //   if (App.core.message.value.isNotEmpty) {
                  //         //     Future.delayed(const Duration(milliseconds: 1000), () {
                  //         //       App.core.message.value = '';
                  //         //     });
                  //         //   }
                  //         // });

                  //         // Navigator.of(context).pushNamed('read');
                  //         // route.pushNamed('read');
                  //       },
                  //     );
                  //   },
                  //   itemCount: bList.length,
                  // ),
                ],
              );
            },
          ),
      ],
    );
  }
}
