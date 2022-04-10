import 'package:flutter/material.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

// import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'state.dart';
part 'swipe.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/bible';
  static const icon = LideaIcon.book;
  static const name = 'Bible';
  static const description = '...';

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
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight],
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      PullToAny(
        onUpdate: core.updateBookMeta,
      ),
      ValueListenableBuilder(
        valueListenable: collection.boxOfBooks.listen(),
        builder: bookList,
      ),
    ];
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    return WidgetListBuilder(
      key: _kList,
      itemBuilder: (BuildContext context, int index) => bookContainer(index, box.getAt(index)!),
      itemCount: box.length,
      itemReorderable: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        if (oldIndex == newIndex) return;

        // final oldItem = box.getAt(oldIndex)!.copyWith(order:oldIndex);
        // final newItem = box.getAt(newIndex)!.copyWith(order:newIndex);
        // box.putAt(oldIndex, newItem);
        // box.putAt(newIndex, oldItem);

        // final items = box.toMap().values.toList();
        final items = box.values.toList();
        items.insert(newIndex, items.removeAt(oldIndex));
        box.putAll(items.asMap());
      },
    );
  }

  Widget bookContainer(int index, BooksType book) {
    return SwipeForMore(
      key: Key('$index'),
      child: Card(
        // elevation: 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: bookItem(index, book),
      ),
      menu: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            // color: Theme.of(context).primaryColorLight,
            color: Theme.of(context).focusColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: WidgetButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const WidgetLabel(
              icon: LideaIcon.dotHoriz,
            ),
            message: preference.text.more,
            onPressed: () => showOptions(book),
          ),
        ),
      ],
    );
  }

  Widget bookItem(int index, BooksType book) {
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == collection.primaryId;
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DefaultTextStyle(
          child: Text(book.name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
                // color: isAvailable?Colors.black:Colors.grey,
              ),
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Icon(
              Icons.favorite,
              size: 18,
              color: book.selected
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              minWidth: 37.0,
              // minHeight: 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            margin: const EdgeInsets.only(right: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: isAvailable
                  ? isPrimary
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColorDark
                  : Theme.of(context).disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 12,
                    color: isAvailable ? Theme.of(context).primaryColor : null,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              book.shortname,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: dragController,
            builder: (context, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: dragAnimation.isCompleted ? dragHandler(index) : child!,
              );
            },
            child: Text(
              book.year.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: isAvailable ? null : Theme.of(context).hintColor,
                  ),
            ),
          ),
        ],
      ),
      onTap: () => toBible(index, book),
    );
  }

  Widget dragHandler(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Icon(
          Icons.drag_handle_rounded,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
