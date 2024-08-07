import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'note';
  static String label = 'Note';
  static IconData icon = LideaIcon.listNested;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ViewBars(
        padding: state.fromContext.viewPadding,
        // forceOverlaps: false,
        // forceStretch: true,
        // backgroundColor: Theme.of(context).primaryColor,
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        child: _headerNormal(),
      ),
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: scrollController.bottom,
        //   notifier: viewData.bottom,
        // ),
        // child: CustomScrollView(
        //   controller: scrollController,
        //   slivers: _slivers,
        // ),

        child: ValueListenableBuilder(
          valueListenable: boxOfBookmarks.listen(),
          builder: (BuildContext _, Box<BookmarksType> __, Widget? ___) {
            // boxOfBookmarks = a;
            // final abc = a;
            // a.l
            // final b = a.values;
            // final c = a.toMap();

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
      // ViewHeaderSliver(
      //   pinned: true,
      //   floating: false,
      //   padding: state.fromContext.viewPadding,
      //   heights: const [kToolbarHeight, kToolbarHeight],
      //   // backgroundColor: state.theme.primaryColor,
      //   overlapsBackgroundColor: state.theme.primaryColor,
      //   overlapsBorderColor: state.theme.dividerColor,
      //   builder: _header,
      // ),
      ViewSections(
        duration: const Duration(milliseconds: 400),
        child: ViewCards.fill(
          margin: const EdgeInsets.only(top: 2),
          child: listContainer(),
        ),
      ),
      // listContainer(),
    ];
  }

  Widget listContainer() {
    // final items = box.toMap().entries.toList();
    final items = boxOfBookmarks.entries.toList();

    // items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    // final items = boxOfBookmarks.values.toList();
    // items.sort((a, b) => b.date!.compareTo(a.date!));
    return ViewLists.reorderable(
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemCount: items.length,
      onEmpty: ViewFeedbacks.message(
        label: App.preference.text.bookmarkCount(0),
        // child: Text('abc'),
      ),
      reorderable: boxOfBookmarks.reorderable,
    );
  }

  Widget itemContainer(int index, MapEntry<dynamic, BookmarksType> item) {
    final book = App.core.scripturePrimary.bookById(item.value.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      background: dismissiblesFromRight(),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await onDelete(item.key);
        }
        return false;
      },

      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: Text(
          book.info.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),

        // trailing: Text(
        //   core.scripturePrimary.digit(item.value.chapterId),
        //   // 'chapterId',
        //   style: const TextStyle(fontSize: 18),
        // ),
        trailing: Text(
          core.scripturePrimary.digit(item.value.chapterId),
          // 'chapterId',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onTap: () => onNav(item.value.bookId, item.value.chapterId),
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
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
