import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  // final SettingsController? settings;
  // final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/search/suggest';
  static const icon = LideaIcon.search;
  static const name = 'Suggestion';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

/*
on initState(searchQuery)
  get -> core.collection.searchQuery
onSearch
  set -> core.collection.searchQuery from core.searchQuery
onCancel
  restore -> core.searchQuery from core.collection.searchQuery
  update -> textController.text
*/
abstract class _State extends State<Main> with TickerProviderStateMixin {
  late Core core;

  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ViewNavigationArguments get _arguments => widget.arguments as ViewNavigationArguments;
  // GlobalKey<NavigatorState> get navigator => _arguments.navigator!;
  // ViewNavigationArguments get _parent => _arguments.args as ViewNavigationArguments;
  // bool get canPop => _arguments.args != null;

  late final AnimationController clearController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  ); //..repeat();
  late final Animation<double> clearAnimation = CurvedAnimation(
    parent: clearController,
    curve: Curves.fastOutSlowIn,
  );
  // late final Animation<double> clearAnimation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(clearController);
  // late final Animation clearAnimations = ColorTween(
  //   begin: Colors.red, end: Colors.green
  // ).animate(clearController);

  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    Future.microtask(() {
      // searchQueryCurrent = searchQueryPrevious;
      // textController.text = searchQueryPrevious;
      textController.text = searchQueryCurrent;
    });

    focusNode.addListener(() {
      core.nodeFocus = focusNode.hasFocus;
    });

    scrollController.addListener(() {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        Future.microtask(() {
          toggleClear(false);
        });
      }
    });

    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();

    textController.addListener(() {
      toggleClear(textController.text.isNotEmpty);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    clearController.dispose();
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  String get searchQueryPrevious => core.collection.searchQuery;
  set searchQueryPrevious(String str) {
    core.collection.searchQuery = str;
  }

  String get searchQueryCurrent => core.collection.suggestQuery;
  set searchQueryCurrent(String str) {
    // core.collection.suggestQuery = str.replaceAll(RegExp(' +'), ' ').trim();
    final ord = str.replaceAll(RegExp(' +'), ' ').trim();
    core.notifyIf<String>(searchQueryCurrent, core.collection.suggestQuery = ord);
  }

  void onClear() {
    textController.clear();
    searchQueryCurrent = '';
    core.suggestionGenerate();
  }

  void toggleClear(bool show) {
    if (show) {
      clearController.forward();
    } else {
      clearController.reverse();
    }
  }

  void onCancel() {
    focusNode.unfocus();
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      searchQueryCurrent = searchQueryPrevious;
      textController.text = searchQueryCurrent;
      Navigator.of(context).pop(false);
      // navigator.currentState!.maybePop();
      // Navigator.of(context).maybePop(false);
    });
  }

  void onSuggest(String str) {
    searchQueryCurrent = str;
    // on recentHistory select
    if (textController.text != str) {
      textController.text = str;
      if (focusNode.hasFocus == false) {
        Future.delayed(const Duration(milliseconds: 400), () {
          focusNode.requestFocus();
        });
      }
    }
    Future.microtask(() {
      core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    searchQueryCurrent = str;
    searchQueryPrevious = searchQueryCurrent;
    // Future.microtask(() {});
    // Navigator.of(context).pop(true);

    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      Navigator.of(context).pop(true);
      // _parent.navigator.currentState!.pop(true);
      // navigator.currentState!.pushReplacementNamed('/search/result', arguments: _arguments);
      // navigator.currentState!.popAndPushNamed('/search/result', arguments: _arguments);
    });

    core.conclusionGenerate();

    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    // scrollController.animateTo(
    //   scrollController.position.minScrollExtent,
    //   curve: Curves.fastOutSlowIn, duration: const Duration(milliseconds: 800)
    // );
    // Future.delayed(Duration.zero, () {
    //   core.collection.historyUpdate(searchQuery);
    // });
  }

  bool onDelete(String str) => core.collection.recentSearchDelete(str);

  BIBLE get bible => core.scripturePrimary.verseSearch;
  bool get shrinkResult => bible.verseCount > 300;
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: widget.key,
      body: ViewPage(
        // controller: scrollController,
        child: body(),
      ),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        // bar(),
        Selector<Core, bool>(
          selector: (BuildContext _, Core e) => e.nodeFocus,
          builder: (BuildContext _, bool word, Widget? child) {
            return bar();
          },
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
              return _noQuery();
            } else if (o.verseCount > 0) {
              return _resultView();
            } else {
              return _msg('no match');
            }
          },
        )
      ],
    );
  }

  /*
  Widget _noQuery() {
    return const SliverToBoxAdapter(
      child: Text('suggest: no query'),
    );
  }

  Widget _noMatch() {
    return const SliverToBoxAdapter(
      child: Text('suggest: not found'),
    );
  }

  // listView
  Widget _listView(SuggestionType o) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final snap = o.raw.elementAt(index);
            String word = snap.values.first.toString();
            int hightlight =
                searchQueryCurrent.length < word.length ? searchQueryCurrent.length : word.length;
            return _listItem(word, hightlight);
          },
          childCount: o.raw.length,
        ),
      ),
    );
  }

  Widget _listItem(String word, int hightlight) {
    return ListTile(
      title: RichText(
        // strutStyle: StrutStyle(height: 1.0),
        text: TextSpan(
          text: word.substring(0, hightlight),
          semanticsLabel: word,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodySmall!.color,
            // fontWeight: FontWeight.w500
          ),
          children: <TextSpan>[
            TextSpan(
              text: word.substring(hightlight),
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.labelLarge!.color,
                // fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
      ),
      minLeadingWidth: 10,
      leading: const Icon(CupertinoIcons.arrow_turn_down_right, semanticLabel: 'Suggestion'),
      onTap: () => true,
    );
  }
  */

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _noQuery() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.recentSearch(),
      builder: (BuildContext _a, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? _b) {
        if (items.isNotEmpty) {
          return SliverToBoxAdapter(
            child: _recentList(items),
          );
        }
        return _msg(preference.text.aWordOrTwo);
      },
    );
  }

  Widget _resultView() {
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
          size: core.collection.fontSize,
          lang: core.scripturePrimary.info.langCode,
          child: WidgetVerse(
            verse: verse,
            keyword: searchQueryCurrent,
            // alsoInVerse: shrinkVerse?verses.where((e) => e.id  != verse.id).map((e) => core.digit(e.id)).join(', '):''
            alsoInVerse: shrinkVerse
                ? verses.where((e) => e.id != verse.id).map((e) => e.name).join(', ')
                : '',
          ),
        );
      },
    );
  }

  Widget _recentList(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _recentContainer(index, items.elementAt(index));
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
      ),
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: _recentItem(item.value.word),
        minLeadingWidth: 10,
        // leading: Icon(Icons.manage_search_rounded),
        leading: const Icon(
          CupertinoIcons.arrow_turn_down_right,
          semanticLabel: 'Suggestion',
        ),
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
    int hightlight =
        searchQueryCurrent.length < word.length ? searchQueryCurrent.length : word.length;
    return RichText(
      // strutStyle: StrutStyle(height: 1.0),
      text: TextSpan(
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
      // padding: const EdgeInsets.symmetric(vertical: 0),
      color: Theme.of(context).errorColor,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              preference.text.delete,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
