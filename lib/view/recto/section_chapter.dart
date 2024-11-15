import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:scripture/core/main.dart';
// import 'package:lidea/sliver_tools.dart';
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

  late final CategoryBook book = state.param.as<CategoryBook>();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts(
      data: vbd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewBarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, 0),
          vbd.snapShrink,
        ),
        // label: 'Chapter',
        // label: book.name,
        label: preference.text('book-${book.id}'),
        data: vbd,
      ),
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Views(
        child: CustomScrollView(
          controller: scrollController,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      // ViewBarSliver(
      //   pinned: true,
      //   // floating: false,
      //   // padding: const EdgeInsets.only(top: 30),
      //   // heights: const [kToolbarHeight, 100],
      //   padding: context.viewPaddingOf,
      //   heights: const [kToolbarHeight, 100],
      //   // overlapsBackgroundColor: theme.primaryColor,
      //   // overlapsBorderColor: theme.dividerColor,
      //   builder: _header,
      // ),
      AppBarSliver.adaptive(
        children: [
          AdaptiveAppBar(
            height: const [kToolbarHeight, 100],
            builder: _headerMobile,
          ),
        ],
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
        // final chapterLocale = lang.chapter('');
        final chapterName = preference.digit(context, chapterId);
        return ListTile(
          // title: Text('$chapterLocale $chapterName'),
          title: Paragraphs(
            text: preference.text('chapterName'),
            decoration: [
              TextSpan(
                text: chapterName,
                semanticsLabel: 'chapter',
              ),
            ],
          ),
          trailing: ViewMarks(
            // iconLeft: false,
            // icon: LideaIcon.rightOpen,
            // iconSize: 26,
            iconColor: Theme.of(context).hintColor,
            label: preference.digit(context, verse),
          ),
          onTap: () {
            app.route.page.go('/read');
            app.chapterChange(bookId: book.id, chapterId: chapterId);
          },
        );
      },
      itemCount: book.totalChapter,
    );
  }
}
