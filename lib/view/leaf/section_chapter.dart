import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:scripture/core/main.dart';
// import 'package:lidea/sliver_tools.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'section-chapter';
  static String label = 'Chapter';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();

  late final CategoryBook book = state.as<CategoryBook>();

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
        // label: 'Chapter',
        // label: book.name,
        label: App.preference.language('book-${book.id}'),
        data: vhd,
      ),
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('chapter->build');

    return Scaffold(
      primary: true,
      body: Views(
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
        heights: const [kToolbarHeight, 100],
        // overlapsBackgroundColor: state.theme.primaryColor,
        // overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      // SliverList.builder(
      //   itemBuilder: (BuildContext _, int index) {
      //     return ListTile(
      //       title: Text('... $index'),
      //     );
      //   },
      //   itemCount: 50,
      // ),
      chapterWidget(),
    ];
  }

  Widget chapterWidget() {
    return SliverList.builder(
      itemBuilder: (BuildContext _, int index) {
        int verse = book.chapter.elementAt(index);
        // int verse = book.elementAt(index);
        int chapterId = index + 1;

        // final bookName = book.name;
        // final chapterLocale = App.preference.text.chapter('');
        final chapterName = App.preference.digit(chapterId);
        return ListTile(
          // title: Text('$chapterLocale $chapterName'),
          title: Paragraphs(
            text: App.preference.language('chapterName'),
            decoration: [
              TextSpan(
                text: chapterName,
                semanticsLabel: 'chapter',
              ),
            ],
          ),
          trailing: ViewMark(
            // iconLeft: false,
            // icon: LideaIcon.rightOpen,
            // iconSize: 26,
            iconColor: Theme.of(context).hintColor,
            label: App.preference.digit(verse),
          ),
          onTap: () {
            App.route.pushNamed('read');
            App.core.chapterChange(bookId: book.id, chapterId: chapterId);
          },
        );
      },
      itemCount: book.totalChapter,
    );
  }
}
