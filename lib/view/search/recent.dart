part of 'main.dart';

class _Recent extends StatefulWidget {
  const _Recent();

  @override
  State<_Recent> createState() => _RecentView();
}

class _RecentView extends StateAbstract<_Recent> {
  // Scripture get primaryScripture => core.scripturePrimary;

  // BIBLE get bible => primaryScripture.verseSearch;
  // bool get shrinkResult => bible.verseCount > 300;

  // SearchCache cacheResult = SearchCache();

  // String get searchQuery => data.searchQuery;
  // set searchQuery(String ord) {
  //   data.searchQuery = ord;
  // }

  String get suggestQuery => data.suggestQuery;
  set suggestQuery(String ord) {
    data.suggestQuery = ord;
  }

  int get lengths => suggestQuery.length;

  bool onDelete(String str) => data.boxOfRecentSearch.delete(str);

  // void toRead(int book, int chapter) {
  //   core.chapterChange(bookId: book, chapterId: chapter).whenComplete(() {
  //     route.pushNamed('read');
  //   });
  // }

  void onSuggest(String str) {
    suggestQuery = str;

    // on recentHistory select
    // if (_textController.text != str) {
    //   _textController.text = str;
    //   if (_focusNode.hasFocus == false) {
    //     Future.delayed(const Duration(milliseconds: 400), () {
    //       _focusNode.requestFocus();
    //     });
    //   }
    // }
    // Future.microtask(() {
    //   App.core.suggestionGenerate();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.data.boxOfRecentSearch.entries,
      builder: (BuildContext _, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        return ViewSections(
          sliver: true,
          show: items.isNotEmpty,
          // duration: const Duration(milliseconds: 270),
          headerTitle: ViewLabel(
            alignment: Alignment.centerLeft,
            label: preference.text.recentSearch((items.length > 1).toString()),
          ),

          onAwait: ViewFeedbacks.message(
            label: App.preference.text.aWordOrTwo,
          ),
          child: _recentBlock(items),
        );
      },
    );
  }

  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return ViewLists.separator(
      separator: (BuildContext _, int index) {
        return const ViewDividers();
      },
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return RecentItem(
          child: _recentContainer(index, items.elementAt(index)),
        );
      },
      itemSnap: const RecentItem.snap(),
      // separator: (BuildContext context, int index) {
      //   return const ViewSectionDivider();
      // },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      background: _recentDismissibleBackground(),
      // secondaryBackground: _recentListDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
        return null;
      },
      child: ListTile(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        // contentPadding: const EdgeInsets.symmetric(vertical: 5),
        leading: const Icon(Icons.arrow_outward_rounded),
        title: _recentItem(item.value.word),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Wrap(
            //   children: item.value.lang
            //       .map(
            //         (e) => Text(
            //           e,
            //           style: Theme.of(context).textTheme.labelMedium,
            //         ),
            //       )
            //       .toList(),
            // ),
            Chip(
              // avatar: CircleAvatar(
              //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //   backgroundColor: Colors.transparent,
              //   child: Icon(
              //     Icons.saved_search_outlined,
              //     color: Theme.of(context).primaryColor,
              //   ),
              // ),
              backgroundColor: state.theme.indicatorColor,
              label: Text(
                // item.value.hit.toString(),
                App.core.scripturePrimary.digit(item.value.hit),
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
    );
  }

  Widget _recentItem(String word) {
    int hightlight = lengths < word.length ? lengths : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        // style: TextStyle(
        //   fontSize: 20,
        //   color: Theme.of(context).textTheme.bodySmall!.color,
        //   // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
        //   fontWeight: FontWeight.w300,
        // ),
        style: Theme.of(context).textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: Theme.of(context).textTheme.bodyLarge,
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

class RecentItem extends StatelessWidget {
  final Widget? child;
  const RecentItem({
    super.key,
    required this.child,
  });
  const RecentItem.snap({super.key}) : child = null;

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        leading: Icon(Icons.hive_sharp),
      );
    }

    return child!;
  }
}
