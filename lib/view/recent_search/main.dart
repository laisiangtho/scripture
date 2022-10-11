import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'recent-search';
  static String label = 'Recent search';
  static IconData icon = LideaIcon.listNested;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('recent-search->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
        ),
        child: ValueListenableBuilder(
          valueListenable: boxOfRecentSearch.listen(),
          builder: (BuildContext _, Box<RecentSearchType> __, Widget? ___) {
            return CustomScrollView(
              controller: _controller,
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
        heights: const [kToolbarHeight, 100],
        overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.shadowColor,
        builder: _header,
      ),
      // listContainer(),
      ViewSection(
        show: boxOfRecentSearch.isNotEmpty,

        placeHolder: SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(App.preference.text.recentSearchCount(0)),
          ),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
        //   child: Material(
        //     type: MaterialType.card,
        //     color: Theme.of(context).primaryColor,
        //     shape: RoundedRectangleBorder(
        //       side: BorderSide(
        //         color: Theme.of(context).shadowColor,
        //         width: 0.5,
        //       ),
        //     ),
        //     child: _recentBlock(items),
        //   ),
        // ),
        // child: Card(
        //   // clipBehavior: Clip.hardEdge,
        //   child: _recentBlock(items),
        // ),
        child: ViewBlockCard.fill(
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

    return ViewListBuilder(
      primary: false,
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(
          primary: false,
        );
      },
      itemCount: items.length,
      duration: kThemeChangeDuration,
      itemVoid: SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(App.preference.text.recentSearchCount(0)),
        ),
      ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        title: Text(
          // history.value.word,
          item.word,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        trailing: Text(
          // App.core.scripturePrimary.digit(bookmark.chapterId),
          item.hit.toString(),
          style: const TextStyle(fontSize: 18),
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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
