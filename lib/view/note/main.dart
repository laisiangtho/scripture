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

  static const route = '/note';
  static const icon = LideaIcon.listNested;
  static const name = 'Note';
  static const description = 'Note';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
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
        heights: const [kToolbarHeight, 50],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      Selector<Core, List<MapEntry<dynamic, BookmarksType>>>(
        selector: (_, e) => e.collection.boxOfBookmarks.entries.toList(),
        builder: listContainer,
        child: messageContainer(preference.text.bookmarkCount(0)),
      ),
      // Selector<Core, List<MapEntry<dynamic, BookmarkType>>>(
      //   selector: (_, e) => e.collection.boxOfBookmark.toMap().entries.toList(),
      //   builder: (BuildContext _, List<MapEntry<dynamic, BookmarkType>> items, Widget? child) {},
      //   child: messageContainer(preference.text.bookmarkCount(0)),
      // ),
    ];
  }

  Widget messageContainer(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget listContainer(
      BuildContext _, List<MapEntry<dynamic, BookmarksType>> box, Widget? placeHolder) {
    return WidgetChildBuilder(
      child: WidgetBlockCard(
        child: WidgetListBuilder(
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return itemContainer(index, box.elementAt(index));
          },
          itemSeparator: (_, index) {
            return const WidgetListDivider();
          },
          itemCount: box.length,
        ),
      ),
      show: box.isNotEmpty,
      placeHolder: placeHolder,
    );
  }

  Dismissible itemContainer(int index, MapEntry<dynamic, BookmarksType> bookmark) {
    final abc = core.scripturePrimary.bookById(bookmark.value.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(bookmark.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: Text(
          // history.value.word,
          abc.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),

        trailing: Text(
          core.scripturePrimary.digit(bookmark.value.chapterId),
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () => onNav(
          bookmark.value.bookId,
          bookmark.value.chapterId,
        ),
      ),
      background: dismissiblesFromRight(),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await onDelete(index);
        } else {
          // Navigate to edit page;
        }
        return null;
      },
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          preference.text.delete,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
