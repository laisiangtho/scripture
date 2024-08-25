import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recto-merge';
  static String label = 'Merge';
  static IconData icon = Icons.merge;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  Scripture get scripture => app.scripturePrimary;

  List<SnapOut> snap = [];

  int bookId = 0;
  String bookName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaData();
  }

  // Todo: might not needed
  void _mediaData() {
    bookId = scripture.bookCurrent.info.id;
    if (state.hasArguments) {
      final ob = state.asMap['book'];
      if (ob != null) {
        bookId = ob as int;
      }
    }

    // Iterable<OfBook> books = scripture.title.result.book.where((e) => e.info.id == bookId);
    // Iterable<OfBook> books = scripture.merge.result.book.where((e) => e.info.id == bookId);
    Iterable<OfBook> books = scripture.merge.result.book;

    if (books.isNotEmpty) {
      for (var b in books) {
        for (var c in b.chapter) {
          for (var item in c.verse) {
            snap.add(
              SnapOut(
                bookId: b.info.id,
                chapterId: c.id,
                verse: item,
              ),
            );
          }
        }
      }
      // for (var chapter in books.map((e) => e.chapter).first) {
      //   for (var item in chapter.verse) {
      //     snap.add(
      //       SnapOut(
      //         bookId: bookId,
      //         chapterId: chapter.id,
      //         verse: item,
      //       ),
      //     );
      //   }
      // }
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
          back: preference.text.back,
          cancel: preference.text.cancel,
        ),
      ],
      primary: const ViewHeaderTitle.custom(
        child: Icon(Icons.merge),
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
                scripture.digit('${verse.id}-${verse.merge}'),
                textAlign: TextAlign.center,
                style: state.textTheme.labelSmall?.copyWith(
                  color: state.theme.hintColor,
                ),
              ),
            ),
            title: Text(
              // 'verse.title',
              scripture.bookById(obj.bookId).info.name,
              style: state.textTheme.titleMedium,
            ),
            trailing: Text(
              scripture.digit(obj.chapterId),
              textAlign: TextAlign.center,
              style: state.textTheme.labelSmall?.copyWith(
                color: state.theme.hintColor,
              ),
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
        onEmpty: const ViewFeedbacks.await(),
      )
    ];
  }
}
