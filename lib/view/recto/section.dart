import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends CommonStates<Main> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();

  Scripture get scripture => app.scripturePrimary;
  // List<OfBook> get books => scripture.bookList;
  List<OfTestament> get testaments => scripture.testamentList;

  CategoryBible get category => scripture.refs.category;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          label: app.preference.of(context).back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, 0),
          vhd.snapShrink,
        ),
        label: app.preference.of(context).bible('false'),
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
          controller: scrollController,
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
        padding: state.media.viewPadding,
        heights: const [kToolbarHeight],
        // overlapsBackgroundColor: theme.primaryColor,
        // overlapsBorderColor: theme.dividerColor,
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
          title: Text(preference.language('testament-$tId')),
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
        //       title: Text(preference.language('testament-$tId')),
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
                    title: Text(preference.language('section-$sId')),
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
                          preference.digit(context, bId),
                          // scripture.digit(book.id),
                          // book.id.toString(),
                          textAlign: TextAlign.center,
                          style: style.titleSmall,
                        ),
                        title: Text(preference.language('book-$bId')),
                        trailing: ViewMarks(
                          iconLeft: false,
                          icon: LideaIcon.rightOpen,
                          iconSize: 28,
                          iconColor: Theme.of(context).hintColor,
                          label: preference.digit(context, book.totalChapter),
                        ),
                        onTap: () {
                          app.route.showModalSheet<Map<String, dynamic>?>(
                            child: app.route.sheetConfig(
                              name: '/recto-book',
                              extra: {'book': book.id},
                            ),
                          );
                        },
                      );
                    },
                    itemCount: bList.length,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
