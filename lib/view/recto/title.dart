import 'package:flutter/material.dart';
// import 'package:scripture/core/main.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recto-title';
  static String label = 'Title';
  static IconData icon = Icons.signpost_rounded;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  // late final ScrollController scrollController = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  Scripture get scripture => core.scripturePrimary;

  List<SnapOut> snap = [];

  int bookId = 0;
  String bookName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaData();
  }

  /// TODO: might not needed
  void _mediaData() {
    // viewData.fromContext = MediaQuery.of(context);
    bookId = scripture.bookCurrent.info.id;
    if (state.hasArguments) {
      // bookId = state.asMap['book'] as int;
      final ob = state.asMap['book'];
      if (ob != null) {
        bookId = ob as int;
      }
    }

    Iterable<OfBook> books = scripture.title.result.book.where((e) => e.info.id == bookId);

    // if (books.isNotEmpty) {
    //   for (var chapter in books.map((e) => e.chapter).first) {
    //     itemChapters.add(chapter);
    //   }
    // }
    if (books.isNotEmpty) {
      for (var chapter in books.map((e) => e.chapter).first) {
        for (var item in chapter.verse) {
          snap.add(
            SnapOut(
              bookId: bookId,
              chapterId: chapter.id,
              verse: item,
              // verseId: item.id,
              // title: item.title,
            ),
          );
        }
      }
    }
    if (books.isNotEmpty) {
      bookName = books.first.info.name;
    } else {
      bookName = scripture.bookById(bookId).info.name;
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   scrollController.dispose();
  // }
}

mixin _Header on _State {
  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kTextTabBarHeight,
      left: [
        OptionButtons.backOrCancel(
          back: App.preference.text.back,
          cancel: App.preference.text.cancel,
        ),
      ],
      primary: ViewHeaderTitle.dual(
        label: preference.text.title('true'),
        header: bookName,
        shrinkMax: 16,
      ),
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: true,
      appBar: ViewBars(
        height: kTextTabBarHeight,
        // forceOverlaps: false,
        forceStretch: true,
        backgroundColor: state.theme.primaryColor,
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        child: _header(),
      ),
      body: Views(
        heroController: HeroController(),
        child: CustomScrollView(
          // controller: scrollController,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewLists.separator(
        sliver: true,
        decoration: BoxDecoration(
          color: CardTheme.of(context).color,
          // boxShadow: [
          //   BoxShadow(
          //     color: CardTheme.of(context).shadowColor!,
          //     blurRadius: 0.2,
          //     spreadRadius: 0.0,
          //     offset: const Offset(0.0, 0.0),
          //   )
          // ],
          border: Border(
            top: BorderSide(
              color: state.theme.dividerColor,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: state.theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        separator: (BuildContext _, int index) {
          return const ViewDividers();
        },
        itemBuilder: (BuildContext _, int index) {
          final obj = snap.elementAt(index);
          final verse = obj.verse;
          return ListTile(
            leading: SizedBox(
              width: 45,
              child: Text(
                // '${verse.chapterId}:${verse.verseId}',
                scripture.digit('${obj.chapterId}:${verse.id}'),
                textAlign: TextAlign.center,
                style: state.textTheme.labelSmall?.copyWith(
                  color: state.theme.hintColor,
                ),
              ),
            ),
            title: Text(
              verse.title,
              style: state.textTheme.titleMedium,
            ),
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).maybePop({
                'book': obj.bookId,
                'chapter': obj.chapterId,
              });
            },
          );
        },
        itemCount: snap.length,

        // onEmpty: const ViewFeedbacks.empty(),
        onEmpty: ViewFeedbacks.message(
          label:
              preference.language('noTitleOnBook').replaceFirst('{{book}}', bookName).replaceFirst(
                    '{{title}}',
                    preference.text.title(''),
                  ),
        ),
      )
    ];
  }
}
