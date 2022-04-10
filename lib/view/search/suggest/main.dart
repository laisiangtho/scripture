import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search-suggest';
  static const icon = LideaIcon.search;
  static const name = 'Suggestion';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        // overlapsForce:focusNode.hasFocus,
        // overlapsForce:core.nodeFocus,
        overlapsForce: true,
        // borderRadius: Radius.elliptical(20, 5),
        builder: bar,
      ),

      // Selector<Core, SuggestionType>(
      //   selector: (_, e) => e.collection.cacheSuggestion,
      //   builder: (BuildContext context, SuggestionType o, Widget? child) {
      //     if (o.query.isEmpty) {
      //       return _noQuery();
      //     } else if (o.raw.isNotEmpty) {
      //       return _listView(o);
      //     } else {
      //       return _noMatch();
      //     }
      //   },
      // )
      Selector<Core, BIBLE>(
        selector: (_, e) => e.scripturePrimary.verseSearch,
        builder: (BuildContext context, BIBLE o, Widget? child) {
          if (o.query.isEmpty) {
            return _suggestNoQuery();
          } else if (o.verseCount > 0) {
            return _suggestBlock();
          } else {
            return _msg('no match');
          }
        },
      ),
    ];
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _suggestNoQuery() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.boxOfRecentSearch.entries,
      builder: (BuildContext _a, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? _b) {
        return WidgetBlockSection(
          show: items.isNotEmpty,
          duration: const Duration(milliseconds: 270),
          headerLeading: WidgetLabel(
            label: preference.text.recentSearch(items.length > 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
            child: Material(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).shadowColor,
                  width: 0.5,
                ),
              ),
              child: _recentBlock(items),
            ),
          ),
          placeHolder: _msg(preference.text.aWordOrTwo),
        );
      },
    );
  }

  Widget _suggestBlock() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int bookIndex) {
          BOOK book = bible.book[bookIndex];
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text(book.info.name),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(book.info.name.toUpperCase()),
              ),
              _suggestChapter(book.chapter),
            ],
          );
        },
        childCount: bible.book.length,
      ),
    );
  }

  Widget _suggestChapter(List<CHAPTER> chapters) {
    final bool shrinkChapter = (chapters.length > 1 && shrinkResult);
    final int shrinkChapterTotal = shrinkChapter ? 1 : chapters.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: chapters.length,
      itemCount: shrinkChapterTotal,
      itemBuilder: (context, chapterIndex) {
        CHAPTER chapter = chapters[chapterIndex];
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (shrinkChapter)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  // chapters.map((e) => e.id).join(', '),
                  // chapters.where((e) => e.id  != chapter.id).map((e) => core.digit(e.id)).join(', '),
                  chapters.where((e) => e.id != chapter.id).map((e) => e.name).join(', '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13.0),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                chapter.name,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ),
            _suggestVerse(chapter.verse),
          ],
        );
      },
    );
  }

  Widget _suggestVerse(List<VERSE> verses) {
    final bool shrinkVerse = (verses.length > 1 && shrinkResult);
    final int shrinkVerseTotal = shrinkVerse ? 1 : verses.length;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: verses.length,
      itemCount: shrinkVerseTotal,
      itemBuilder: (context, index) {
        VERSE verse = verses[index];
        return VerseWidgetInherited(
          // key: verse.key,
          size: collection.boxOfSettings.fontSize().asDouble,
          lang: core.scripturePrimary.info.langCode,
          child: WidgetVerse(
            verse: verse,
            keyword: suggestQuery,
            // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
            alsoInVerse: shrinkVerse
                ? verses.where((e) => e.id != verse.id).map((e) => e.name).join(', ')
                : '',
          ),
        );
      },
    );
  }

  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return WidgetListBuilder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _recentContainer(index, items.elementAt(index));
      },
      itemSeparator: (BuildContext context, int index) {
        return const WidgetListDivider();
      },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        leading: const Icon(Icons.north_east_rounded),
        title: _recentItem(item.value.word),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              children: item.value.lang
                  .map(
                    (e) => Text(e),
                  )
                  .toList(),
            ),
            Chip(
              avatar: CircleAvatar(
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.saved_search_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              label: Text(
                item.value.hit.toString(),
              ),
            ),
          ],
        ),
        // trailing: Chip(
        //   avatar: CircleAvatar(
        //     // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     backgroundColor: Colors.transparent,
        //     child: Icon(
        //       Icons.saved_search_outlined,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   ),
        //   label: Text(
        //     item.value.hit.toString(),
        //   ),
        // ),
        onTap: () => onSuggest(item.value.word),
      ),
      background: _recentDismissibleBackground(),
      // secondaryBackground: _recentListDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
        return null;
      },
    );
  }

  Widget _recentItem(String word) {
    int hightlight = suggestQuery.length < word.length ? suggestQuery.length : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.bodySmall!.color,
          // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.labelLarge!.color,
            ),
          )
        ],
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
