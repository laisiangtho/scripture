import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recent-search';
  static String label = 'Recent search';
  static IconData icon = LideaIcon.listNested;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: scrollController.bottom,
        //   notifier: App.viewData.bottom,
        // ),
        child: ValueListenableBuilder(
          valueListenable: boxOfRecentSearch.listen(),
          builder: (BuildContext _, Box<RecentSearchType> __, Widget? ___) {
            return CustomScrollView(
              controller: scrollController,
              slivers: _slivers,
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        //overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.disabledColor,
        builder: _header,
      ),
      // listContainer(),
      ViewSections(
        sliver: true,
        show: boxOfRecentSearch.isNotEmpty,

        onAwait: const ViewFeedbacks.await(),
        onEmpty: ViewFeedbacks.message(
          label: App.preference.text.recentSearchCount(0),
        ),

        child: ViewCards.fill(
          child: listContainer(),
        ),
        // child: ViewBlockCard(
        //   clipBehavior: Clip.hardEdge,
        //   child: _recentBlock(items),
        // ),
      ),
    ];
  }

  Widget listContainer() {
    final items = boxOfRecentSearch.values.toList();
    items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewLists.separator(
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemSnap: const ListTile(
        leading: Icon(LideaIcon.subRight),
      ),
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemCount: items.length,
      duration: kThemeChangeDuration,
    );
  }

  Widget itemContainer(int index, RecentSearchType item) {
    // final abc = App.core.scripturePrimary.bookById(bookmark.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.date.toString()),
      direction: DismissDirection.endToStart,
      background: dismissiblesFromRight(),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // return await onDelete(index);
          return await onDelete(item.word);
        }
        return false;
      },
      child: ListTile(
        //contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        title: Text(
          // history.value.word,
          item.word,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.labelMedium,
        ),
        // textColor: Colors.red,
        // tileColor: Colors.blue,
        // selectedTileColor: Colors.amber,
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        trailing: Text(
          App.core.scripturePrimary.digit(item.hit),
          // item.hit.toString(),
          // style: Theme.of(context).textTheme.labelMedium,
        ),
        onTap: () {
          App.route.pushNamed(
            'home/search',
            arguments: {"keyword": item.word},
          );
        },
      ),
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          App.preference.text.delete,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: state.theme.splashColor,
              ),
        ),
      ),
    );
  }
}
