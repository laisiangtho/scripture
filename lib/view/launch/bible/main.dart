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
      PullToActivate(
        onUpdate: core.updateBookMeta,
      ),
      ValueListenableBuilder(
        key: const ValueKey('fe'),
        valueListenable: collection.boxOfBooks.listen(),
        builder: bookList,
      ),
    ];
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    return WidgetListBuilder(
      // key: _kList,
      // primary: false,
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
      menu: <Widget>[
        WidgetButton(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            // color: Theme.of(context).primaryColorLight,
            color: Theme.of(context).focusColor,
          ),
          message: preference.text.more,
          onPressed: () => showOptions(book),
          child: const WidgetLabel(
            icon: LideaIcon.dotHoriz,
          ),
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: bookDecoration(index, book),
      ),
    );
  }

  Widget bookDecoration(int index, BooksType book) {
    bool isAvailable = book.available > 0;
    return Stack(
      children: [
        // Positioned(
        //   top: -18,
        //   right: 0,
        //   child: Transform(
        //     alignment: FractionalOffset.center,
        //     transform: Matrix4.identity()..rotateZ(40),
        //     child: Container(
        //       color: isAvailable
        //           ? book.selected
        //               ? Theme.of(context).highlightColor
        //               : Theme.of(context).disabledColor
        //           : book.selected
        //               ? Theme.of(context).highlightColor
        //               : Colors.transparent,
        //       width: 22,
        //       height: 55,
        //       child: Icon(
        //         Icons.noise_control_off,
        //         size: 24,
        //         color: isAvailable
        //             ? book.selected
        //                 ? Theme.of(context).primaryColor
        //                 : Theme.of(context).primaryColorDark
        //             : Colors.transparent,
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          top: -18,
          right: 0,
          child: ClipPath(
            clipper: CustomTriangleClipper(),
            child: Container(
              width: 60,
              height: 50,
              alignment: const Alignment(1, .3),
              // padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     // Theme.of(context).highlightColor,
                //     Theme.of(context).primaryColor,
                //     Theme.of(context).disabledColor,
                //     // Color(0xffF25D50),
                //     // Color(0xffF2BB77),
                //   ],
                // ),
                color: isAvailable
                    ? book.selected
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor
                    : book.selected
                        ? Theme.of(context).highlightColor
                        : Colors.transparent,
              ),
              child: Icon(
                Icons.noise_control_off,
                size: 24,
                color: isAvailable
                    ? book.selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColorDark
                    : Colors.transparent,
              ),
            ),
          ),
        ),
        bookItem(index, book),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                // fontSize: 20,
                fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
              ),
          child: Text(book.name),
        ),
      ),
      subtitle: Row(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
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
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 13,
                    color: isAvailable ? Theme.of(context).primaryColor : null,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              book.shortname,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
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
                  return ScaleTransition(scale: animation, child: child);
                },
                child: dragAnimation.isCompleted ? dragHandler(index) : child!,
              );
            },
            child: Text(
              '${book.year}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(
          Icons.drag_handle_rounded,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
