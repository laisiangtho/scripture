import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/button.dart';

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
    debugPrint('note->build');

    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: _controller.bottom,
        //   notifier: viewData.bottom,
        // ),
        // child: CustomScrollView(
        //   controller: _controller,
        //   slivers: _slivers,
        // ),
        child: ValueListenableBuilder(
          valueListenable: boxOfBookmarks.listen(),
          builder: (BuildContext _, Box<BookmarksType> __, Widget? ___) {
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
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      listContainer(),
    ];
  }

  Widget listContainer() {
    final items = boxOfBookmarks.entries.toList();
    // items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    // final items = boxOfBookmarks.values.toList();
    // items.sort((a, b) => b.date!.compareTo(a.date!));
    return ViewListBuilder(
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemCount: items.length,
      onEmpty: ViewFeedback.message(
        label: App.preference.text.bookmarkCount(0),
      ),
      itemReorderable: boxOfBookmarks.reorderable,
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
          book.name,
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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
