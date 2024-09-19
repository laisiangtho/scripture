import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
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
      body: Views(
        child: ValueListenableBuilder(
          valueListenable: boxOfBooks.listen(),
          builder: (BuildContext _, Box<BooksType> e, Widget? ___) {
            items = e;

            return ChangeNotifierProvider.value(
              value: iso,
              child: Consumer<ISOFilter>(
                builder: (context, value, child) {
                  return CustomScrollView(
                    controller: scrollController,
                    slivers: _slivers,
                  );
                },
              ),
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
        padding: state.media.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,
        builder: _header,
      ),
      const PullToRefresh(),
      // bookList(),
      // TODO: To be improved (too slow rendering)
      ViewSections(
        sliver: true,
        headerTrailing: ViewDelays.milliseconds(
          milliseconds: 1200,
          builder: (_, snap) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ViewButtons(
                  onPressed: showLangFilter,
                  child: ViewMarks(
                    icon: LideaIcon.language,
                    iconLeft: false,
                    iconSize: 19,
                    badge: iso.selection.length.toString(),
                  ),
                ),
              ],
            );
          },
        ),

        // duration: const Duration(milliseconds: 70),
        // onAwait: const ViewFeedbacks.await(),
        // child: const ViewFeedbacks.await(),
        // child: bookList(),
        child: ViewDelays.milliseconds(
          sliver: false,
          onAwait: const ViewFeedbacks.await(sliver: false),
          builder: (_, __) => bookList(),
        ),
      ),

      ViewFlats(
        sliver: true,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        child: Paragraphs(
          text: preference.language('totalBookLang'),
          style: style.bodySmall,
          textAlign: TextAlign.center,
          decoration: [
            TextSpan(
              text: preference.digit(context, items.length),
              semanticsLabel: 'totalBook',
              style: TextStyle(
                color: theme.highlightColor,
              ),
            ),
            TextSpan(
              text: preference.digit(context, iso.all.length),
              semanticsLabel: 'totalLanguage',
              style: TextStyle(
                color: theme.highlightColor,
              ),
            ),
          ],
        ),
      )
    ];
  }

  Widget bookList() {
    return ViewLists.reorderable(
      key: const ValueKey('reorderable'),
      sliver: false,
      duration: const Duration(milliseconds: 400),
      itemSnap: const BookListItemSnap(),
      itemPrototype: const BookListItemSnap(),
      buildDefaultDragHandles: false,
      itemBuilder: (BuildContext context, int index) {
        final item = items.values.elementAt(index);

        final show = iso.all
            .firstWhere(
              (e) => e.code == item.langCode,
              orElse: () => iso.all.first,
            )
            .show;

        if (show) {
          return bookContainer(index, item);
        }
        // return const SizedBox();
        return const BookListItemSnap();
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: 0.9,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: child,
            );
          },
          child: child,
        );
      },
      itemCount: items.length,
      reorderable: boxOfBooks.reorderable,
    );
  }

  Widget bookContainer(int index, BooksType item) {
    return ViewSwipeWidget(
      // key: ValueKey(item),
      menu: [
        ViewButtons(
          message: app.preference.of(context).more,
          onPressed: () => showBibleInfo(item),
          child: const ViewLabels(
            icon: LideaIcon.dotHoriz,
          ),
        ),
      ],
      child: ViewCards(
        sliver: false,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: bookDecoration(index, item),
      ),
    );
  }

  Widget bookDecoration(int index, BooksType book) {
    return Stack(
      children: [
        // BookListItemCorner(book: book),
        if (book.selected) const BookListItemCorner(),
        bookItem(index, book),
      ],
    );
  }

  Widget bookItem(int index, BooksType book) {
    // final book = item.value;
    final isAva = book.available > 0;

    bool isPrimary = book.identify == data.primaryId;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      title: Text(
        book.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium!.copyWith(
          fontWeight: isAva ? FontWeight.w400 : FontWeight.w300,
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
              minWidth: 40.0,
              // minHeight: 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            margin: const EdgeInsets.only(right: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: isPrimary
                  ? theme.highlightColor.withOpacity(0.5)
                  : isAva
                      ? theme.focusColor
                      : theme.focusColor.withOpacity(0.7),
              // color: isAva
              //     ? isPrimary
              //         ? theme.highlightColor
              //         : theme.primaryColorDark
              //     : theme.disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
              // style: theme.textTheme.bodySmall!.copyWith(
              //   fontSize: 13,
              //   // color: isAvailable ? theme.primaryColor : null,
              //   color: isAva ? theme.primaryColor : theme.hintColor,
              // ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 0),
          //   child: Text(
          //     book.shortname,
          //     // book.identify,
          //     style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          //   ),
          // ),

          Text(
            book.shortname,
            // book.identify,
            style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
          if (isAva)
            const Icon(
              Icons.check,
              size: 19,
            ),
        ],
      ),
      trailing: AnimatedBuilder(
        animation: _dragController,
        builder: (context, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _dragAnimation.isCompleted ? dragHandler(index) : child!,
          );
        },
        child: ViewMarks(
          child: Text(
            book.year.toString(),
          ),
        ),
      ),
      onTap: () => showBibleContent(book, index),
    );
  }

  Widget dragHandler(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: ViewMarks(
        icon: Icons.drag_handle_rounded,
        iconColor: colorScheme.error,
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

class BookListItemCorner extends StatelessWidget {
  const BookListItemCorner({super.key});
  // const BookListItemCorner({super.key, required this.book});
  // final BooksType book;
  // bool get isAvailable => book.available > 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -13,
      right: 0,
      child: ClipPath(
        clipper: CustomTriangleClipper(),
        child: Container(
          // width: 60,
          // height: 50,
          width: 50,
          height: 50,
          alignment: const Alignment(.9, .1),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     // theme.highlightColor,
            //     theme.primaryColor,
            //     theme.disabledColor,
            //     // Color(0xffF25D50),
            //     // Color(0xffF2BB77),
            //   ],
            // ),
            color: Theme.of(context).highlightColor,
          ),
          // child: Icon(
          //   LideaIcon.record,
          //   size: 18,
          //   color: isAvailable
          //       ? book.selected
          //           ? theme.primaryColor
          //           : theme.disabledColor
          //       : Colors.transparent,
          // ),
        ),
      ),
    );
  }
}

class PullToRefresh extends PullToActivate {
  const PullToRefresh({super.key});

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  // late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    await App.core.updateBookMeta();
    await Future.delayed(const Duration(milliseconds: 100));
    // await App.core.data.updateToken();
    // await Future.delayed(const Duration(milliseconds: 200));
  }
}

// BookItemSnap BookListItem
class BookListItemSnap extends StatelessWidget {
  const BookListItemSnap({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewCards(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 20,
                // width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                // color: Colors.grey[200],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 15,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  // color: Colors.grey[200],
                ),
                Container(
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  // color: Colors.grey[200],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
