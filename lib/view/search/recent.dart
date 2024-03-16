part of 'main.dart';

class _Recents extends StatefulWidget {
  final Function(String) onSuggest;
  const _Recents({required this.onSuggest});

  @override
  State<_Recents> createState() => _RecentView();
}

abstract class _RecentState extends StateAbstract<_Recents> {
  String get suggestQuery => data.suggestQuery;
  int get lengths => suggestQuery.length;

  bool onDelete(String str) => data.boxOfRecentSearch.delete(str);
}

class _RecentView extends _RecentState {
  @override
  Widget build(BuildContext context) {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.data.boxOfRecentSearch.entries,
      builder: (BuildContext _, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        return ViewSection(
          show: items.isNotEmpty,
          // duration: const Duration(milliseconds: 270),
          headerTitle: ViewLabel(
            alignment: Alignment.centerLeft,
            label: preference.text.recentSearch((items.length > 1).toString()),
          ),

          onAwait: ViewFeedback.message(
            label: App.preference.text.aWordOrTwo,
          ),
          child: ViewBlockCard.fill(
            child: _recentBlock(items),
          ),
        );
      },
    );
  }

  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return ViewListBuilder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _recentContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          leading: Icon(LideaIcon.subRight),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(primary: false);
      },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    debugPrint('lang ${item.value.lang}');
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        leading: const Icon(LideaIcon.subRight),
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
        onTap: () => widget.onSuggest(item.value.word),
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
