import 'package:flutter/material.dart';

import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPreferred.decoration(
        // forceOverlaps: true,
        // child: _header(),
        builder: _header,
      ),
      body: Views(
        child: ValueListenableBuilder(
          valueListenable: boxOfBookmarks.listen(),
          builder: (BuildContext _, Box<BookmarksType> __, Widget? ___) {
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
    final plural = boxOfBookmarks.values.length > 1;
    return [
      ViewSections(
        // duration: const Duration(milliseconds: 400),
        sliver: true,
        show: boxOfBookmarks.isNotEmpty,

        onAwait: const ViewFeedbacks.await(),
        onEmpty: ViewFeedbacks.message(
          label: lang.bookmarkCount(0),
        ),
        headerTitle: Text(
          lang.bookmark(plural.toString()),
          style: style.titleSmall,
        ),
        child: ViewCards.separator(
          child: listContainer(),
        ),
      ),
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
      reorderable: boxOfBookmarks.reorderable,
    );
  }

  Widget itemContainer(int index, MapEntry<dynamic, BookmarksType> item) {
    final book = app.scripturePrimary.bookById(item.value.bookId);
    const direction2RemoveItem = DismissDirection.startToEnd;
    return Dismissible(
      // key: Key(index.toString()),
      // key: Key(item.value.date.toString()),
      key: ValueKey(item),
      direction: direction2RemoveItem,
      background: _dismissibleBackground(),

      confirmDismiss: (direction) async {
        if (direction == direction2RemoveItem) {
          return await onDelete(item.key);
        }
        return false;
      },
      onUpdate: (detail) {
        _itemFavoriteBackgroundNotifier.value = detail.progress;
      },

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CardTheme.of(context).color,
          boxShadow: [
            BoxShadow(
              color: theme.dividerColor,
              offset: const Offset(0, -0.7),
            )
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          title: Text(
            book.info.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          // minLeadingWidth: 10,
          leading: const Icon(Icons.bookmark_added),
          // trailing: Text(
          //   core.scripturePrimary.digit(item.value.chapterId),
          //   // 'chapterId',
          //   style: const TextStyle(fontSize: 18),
          // ),
          trailing: Text(
            app.scripturePrimary.digit(item.value.chapterId),
            // 'chapterId',
            style: theme.textTheme.labelMedium,
          ),
          onTap: () => onNav(item.value.bookId, item.value.chapterId),
        ),
      ),
    );
  }

  Widget _dismissibleBackground() {
    return Container(
      color: theme.disabledColor,
      alignment: Alignment.centerLeft,
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ValueListenableBuilder<double>(
        valueListenable: _itemFavoriteBackgroundNotifier,
        builder: (context, val, child) {
          return Padding(
            padding: EdgeInsets.only(left: 50 * val),
            child: child,
          );
        },
        child: Text(
          lang.delete,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
