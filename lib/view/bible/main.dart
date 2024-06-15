import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'bible';
  static String label = 'Bible';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottom(
        //   notifier: App.scroll.bottom,
        //   controller: _controller.bottom,
        // ),

        // child: ValueListenableBuilder(
        //   valueListenable: boxOfBooks.listen(),
        //   builder: (BuildContext _, Box<BooksType> __, Widget? ___) {
        //     return CustomScrollView(
        //       controller: _controller,
        //       slivers: _slivers,
        //     );
        //   },
        // ),
        child: ValueListenableBuilder(
          valueListenable: boxOfBooks.listen(),
          builder: (BuildContext _, Box<BooksType> __, Widget? ___) {
            return ChangeNotifierProvider.value(
              key: const ValueKey("iso-value"),
              value: iso,
              child: Consumer<ISOFilter>(
                builder: (context, value, child) {
                  return CustomScrollView(
                    controller: _controller,
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
    debugPrint('_slivers');
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
      const PullToRefresh(),
      // bookList(),
      // TODO: To be improved (too slow rendering)
      ViewSections(
        sliver: true,
        headerTrailing: ViewDelays.milliseconds(
          milliseconds: 500,
          builder: (_, snap) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ViewButton(
                  onPressed: showBibleLang,
                  child: ViewMark(
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
        duration: const Duration(milliseconds: 250),
        onAwait: const ViewFeedbacks.await(),
        child: bookList(),
        // child: ViewDelays.milliseconds(
        //   milliseconds: 250,
        //   onAwait: const ViewFeedbacks.await(
        //   ),
        //   builder: (_, snap) {
        //     return bookList();
        //   },
        // ),
      ),
      SliverPadding(
        // padding: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        // available-book-lang
        sliver: SliverToBoxAdapter(
          child: Paragraphs(
            text: App.preference.language('totalBookLang'),
            style: state.textTheme.bodySmall,
            textAlign: TextAlign.center,
            decoration: [
              TextSpan(
                text: App.preference.digit(setOfBook.length),
                semanticsLabel: 'totalBook',
                style: TextStyle(
                  color: state.theme.highlightColor,
                ),
              ),
              TextSpan(
                text: App.preference.digit(iso.all.length),
                semanticsLabel: 'totalLanguage',
                style: TextStyle(
                  color: state.theme.highlightColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget bookList() {
    final items = booksFilter;
    return ViewLists.reorderable(
      // duration: const Duration(milliseconds: 300),
      // itemSnap: const BookListItem(),
      // itemPrototype: const BookListItem(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = items.elementAt(index);
        final show = iso.all
            .firstWhere(
              (e) => e.code == item.value.langCode,
              orElse: () => iso.all.first,
            )
            .show;

        if (show) {
          return bookContainer(index, item);
        } else {
          return const SizedBox();
        }
      },
      itemCount: items.length,
      reorderable: boxOfBooks.reorderable,
    );
  }

  Widget bookContainer(int index, MapEntry<dynamic, BooksType> item) {
    return ViewSwipeWidget(
      menu: <Widget>[
        ViewButton(
          message: preference.text.more,
          onPressed: () => showBibleInfo(item),
          child: ViewLabel(
            icon: LideaIcon.dotHoriz,
            iconColor: state.theme.highlightColor,
          ),
        ),
      ],
      child: ViewCards(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: bookDecoration(index, item),
      ),
    );
  }

  Widget bookDecoration(int index, MapEntry<dynamic, BooksType> item) {
    final book = item.value;
    bool isAvailable = book.available > 0;
    return Stack(
      children: [
        Positioned(
          top: -13,
          right: 0,
          child: ClipPath(
            clipper: CustomTriangleClipper(),
            child: Container(
              width: 60,
              height: 50,
              alignment: const Alignment(.9, .1),
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
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).focusColor
                    : book.selected
                        ? Theme.of(context).primaryColorDark
                        : Colors.transparent,
              ),
              child: Icon(
                LideaIcon.record,
                size: 18,
                color: isAvailable
                    ? book.selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor
                    : Colors.transparent,
              ),
            ),
          ),
        ),
        bookItem(index, item),
      ],
    );
  }

  Widget bookItem(int index, MapEntry<dynamic, BooksType> item) {
    final book = item.value;
    final isAva = book.available > 0;
    // bool isPrimary = book.identify == collection.primaryId;
    bool isPrimary = book.identify == App.core.data.primaryId;
    return ListTile(
      title: Text(
        book.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
              color: isAva
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
                    // color: isAvailable ? Theme.of(context).primaryColor : null,
                    color: isAva ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              book.shortname,
              // book.identify,
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
            child: Text(
              book.year.toString(),
              style: state.textTheme.bodySmall,
            ),
          ),
        ],
      ),
      onTap: () => showBibleContent(book, index),
    );
  }

  Widget dragHandler(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(
          Icons.drag_handle_rounded,
          color: Theme.of(context).colorScheme.error,
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
class BookListItem extends StatelessWidget {
  const BookListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewCards(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
      //   child: Text(
      //     '....',
      //     style: Theme.of(context).textTheme.labelMedium?.copyWith(
      //           color: Theme.of(context).disabledColor,
      //         ),
      //   ),
      // ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: DefaultTextStyle(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
            child: const Text('...'),
          ),
        ),
        subtitle: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          margin: const EdgeInsets.only(right: 7),
          child: Text(
            '...',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 13,
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ),
    );
  }
}
