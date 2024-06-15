import 'package:flutter/material.dart';

import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'leaf-title';
  static String label = 'Title';
  static IconData icon = Icons.signpost_rounded;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  // late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  Scripture get scripture => App.core.scripturePrimary;
  CacheTitle get title => scripture.title;

  Iterable<OfBook> books = [];
  List<TitleReadOnly> itemTitle = [];
  List<OfBook> itemBooks = [];
  List<OfChapter> itemChapters = [];
  int bookId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaData();
  }

  // Todo: might not needed
  void _mediaData() {
    // App.viewData.fromContext = MediaQuery.of(context);
    bookId = scripture.bookCurrent.info.id;
    if (state.hasArguments) {
      bookId = state.asMap['book'] as int;
    }

    // items = title.book.where((e) => e.info.id == id);
    // for (var item in title.result.book) {
    //   if (item.info.id == bookId) {
    //     itemBooks.add(item);
    //   }
    // }
    // bookId = bookId
    books = title.result.book.where((e) => e.info.id == bookId);

    debugPrint('bookId $bookId');

    // itemChapters = books.map((e) => e.chapter).first;
    // final abc = books.map((e) => e.chapter).first;

    if (books.isNotEmpty) {
      for (var chapter in books.map((e) => e.chapter).first) {
        itemChapters.add(chapter);
      }
    }
    if (books.isNotEmpty) {
      for (var chapter in books.map((e) => e.chapter).first) {
        for (var item in chapter.verse) {
          itemTitle.add(
            TitleReadOnly(
              bookId: bookId,
              chapterId: chapter.id,
              verseId: item.id,
              title: item.title,
            ),
          );
        }
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _controller.dispose();
  // }
}

mixin _Header on _State {
  Widget backOrHome() {
    final parent = Navigator.of(context, rootNavigator: true);
    final self = Navigator.of(context);

    final selfCanPop = self.canPop();
    // return OptionButtons(
    //   navigator: selfCanPop ? self : parent,
    //   label: selfCanPop ? App.preference.text.back : App.preference.text.cancel,
    //   type: selfCanPop ? 'back' : 'cancel',
    // );
    if (selfCanPop) {
      return OptionButtons.back(
        navigator: self,
        label: App.preference.text.back,
      );
    }
    return OptionButtons.cancel(
      navigator: parent,
      label: App.preference.text.cancel,
    );
  }

  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kTextTabBarHeight,
      left: [
        backOrHome(),
      ],
      primary: ViewHeaderTitle.dual(
        label: App.preference.text.title('true'),
        // header: '....',
        // header: title.result.book.first.info.name,
        // header: itemBooks.first.info.name,
        // header: title.result.book.first.info.name,
        header: books.first.info.name,
        // header: title.result.book.first.info.name,
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
        backgroundColor: Theme.of(context).primaryColor,
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        child: _header(),
      ),
      body: Views(
        heroController: HeroController(),
        child: CustomScrollView(
          // controller: _controller,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      // ViewHeaderSliver(
      //   pinned: true,
      //   heights: const [kTextTabBarHeight],
      //   // overlapsBackgroundColor: state.theme.primaryColor,
      //   backgroundColor: state.theme.primaryColor,
      //   overlapsBorderColor: state.theme.dividerColor,
      //   // overlapsForce: true,
      //   // padding: const EdgeInsets.symmetric(horizontal: 7),
      //   builder: _header,
      // ),
      // ViewSections(
      //   sliver: true,
      //   duration: const Duration(milliseconds: 200),
      //   onAwait: const ViewFeedbacks.await(),
      //   onEmpty: const ViewFeedbacks.empty(),
      //   show: items.isNotEmpty,
      //   child: titleList(),
      // ),

      // for (var index = 0; index < title.book.length; index++) ofBook(title.book.elementAt(index)),
      // for (var index = 0; index < itemBooks.length; index++) ofBook(itemBooks.elementAt(index)),
      // for (var index = 0; index < title.book.length; index++)
      //   SliverToBoxAdapter(
      //     child: Text(title.book.elementAt(index).info.name),
      //   ),

      // if (bookId > 0)
      //   SliverToBoxAdapter(
      //     child: Text('$bookId'),
      //   )
      // else
      //   SliverToBoxAdapter(
      //     child: Text('$bookId < 0'),
      //   )

      // for (var index = 0; index < itemChapters.length; index++)
      //   ofChapterGroup(itemChapters.elementAt(index)),
      // for (final chapter in itemChapters) ofChapterGroup(chapter),
      ViewLists.separator(
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
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        separator: (BuildContext _, int index) {
          return const ViewDividers();
        },
        itemBuilder: (BuildContext _, int index) {
          final verse = itemTitle.elementAt(index);
          return ListTile(
            leading: SizedBox(
              width: 45,
              child: Text(
                // '${verse.chapterId}:${verse.verseId}',
                scripture.digit('${verse.chapterId}:${verse.verseId}'),
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
                'book': verse.bookId,
                'chapter': verse.chapterId,
              });
            },
          );
        },
        itemCount: itemTitle.length,
      )
    ];
  }

  Widget ofChapterGroup(OfChapter chapter) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        // SliverAppBar.medium
        SliverAppBar(
          pinned: true,
          primary: false,
          elevation: 19,
          shadowColor: state.theme.dividerColor,
          automaticallyImplyLeading: false,
          // leading: Center(
          //   child: Text(
          //     // primaryScripture.digit(iB + 1),
          //     primaryScripture.digit(book.info.id),
          //     textAlign: TextAlign.center,
          //     style: state.textTheme.labelMedium,
          //   ),
          // ),
          title: Text(
            'Chapter ${chapter.name}',
            style: state.textTheme.titleMedium,
            semanticsLabel: ' : ${chapter.name}',
          ),
          // titleSpacing: 20,
          // toolbarHeight: 40,
        ),
        ofVerse(bookId, chapter),
      ],
    );
  }

  // List of Book
  Widget ofBook(OfBook book) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        // SliverAppBar.medium
        SliverAppBar(
          pinned: true,
          primary: false,
          elevation: 19,
          shadowColor: state.theme.dividerColor,
          automaticallyImplyLeading: false,
          // leading: Center(
          //   child: Text(
          //     // primaryScripture.digit(iB + 1),
          //     primaryScripture.digit(book.info.id),
          //     textAlign: TextAlign.center,
          //     style: state.textTheme.labelMedium,
          //   ),
          // ),
          title: Text(
            book.info.name.toUpperCase(),
            style: state.textTheme.titleMedium,
            semanticsLabel: 'book: ${book.info.name}',
          ),
          // titleSpacing: 20,
          // toolbarHeight: 40,
        ),
        ofChapter(book),
      ],
    );
  }

  // List of Chapter
  Widget ofChapter(OfBook book) {
    final List<OfChapter> chapters = book.chapter;
    final int totalChapter = chapters.length;

    return ViewLists(
      // key: UniqueKey(),
      itemBuilder: (context, index) {
        final OfChapter chapter = chapters.elementAt(index);
        /*
        return Column(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RawMaterialButton(
              elevation: 0.7,
              padding: const EdgeInsets.all(8),
              // fillColor: Colors.grey[300],
              // fillColor: active ? state.theme.focusColor : state.theme.primaryColor,
              fillColor: state.theme.primaryColor,
              // fillColor: state.theme.focusColor,
              // shape: const CircleBorder(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              // constraints: const BoxConstraints(minWidth: 50.0, minHeight: 30.0),
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).maybePop({
                  'book': book.info.id,
                  'chapter': chapter.id,
                });
              },
              child: Text(
                chapter.name,
                semanticsLabel: 'chapter: ${chapter.name}',
                style: state.textTheme.labelMedium,
              ),
            ),
            ofVerse(chapter.verse),
          ],
        );
        */
        return ofVerse(book.info.id, chapter);
      },
      itemCount: totalChapter,
    );
  }

  Widget ofVerse(int bookId, OfChapter chapter) {
    final List<OfVerse> verses = chapter.verse;
    final int totalVerses = verses.length;
    return ViewCards.fill(
      child: ViewLists.separator(
        separator: (BuildContext _, int index) {
          return const ViewDividers();
        },
        itemBuilder: (BuildContext _, int index) {
          OfVerse verse = verses.elementAt(index);
          return ListTile(
            title: Text(verse.title),
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).maybePop({
                'book': bookId,
                'chapter': chapter.id,
              });
            },
          );
        },
        itemCount: totalVerses,
      ),
    );
  }
}
