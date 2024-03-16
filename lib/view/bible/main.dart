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

        child: ValueListenableBuilder(
          valueListenable: boxOfBooks.listen(),
          builder: (BuildContext _, Box<BooksType> __, Widget? ___) {
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
      const PullToRefresh(),
      bookList(),
      SliverPadding(
        // padding: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        // available-book-lang
        sliver: SliverToBoxAdapter(
          // child: Text.rich(
          //   textAlign: TextAlign.center,
          //   style: state.textTheme.labelSmall,
          //   TextSpan(
          //     children: [
          //       const TextSpan(
          //         text: '...available book: ',
          //       ),
          //       TextSpan(
          //         text: totalBook.toString(),
          //         style: TextStyle(
          //           color: state.theme.hintColor,
          //         ),
          //       ),
          //       const TextSpan(
          //         text: ' & language: ',
          //       ),
          //       TextSpan(
          //         text: totalLanguage.toString(),
          //         style: TextStyle(
          //           color: state.theme.hintColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          child: _availableContent(),
        ),
      ),
    ];
  }

  Widget _availableContent() {
    // preference.text.delete : preference.text.download,
    final label = preference
        .language('total-book-lang')
        .replaceAll('total.book', totalBook.toString())
        .replaceAll('total.language', totalLanguage.toString());

    return Text(
      label,
      style: state.textTheme.labelSmall,
      textAlign: TextAlign.center,
    );
    // return Text(label);
  }

  Widget bookList() {
    final items = boxOfBooks.values.toList();
    return ViewListBuilder(
      itemBuilder: (BuildContext context, int index) {
        return bookContainer(index, items.elementAt(index));
      },
      itemCount: items.length,
      itemReorderable: boxOfBooks.reorderable,
    );
  }

  Widget bookContainer(int index, BooksType book) {
    return ViewSwipeWidget(
      menu: <Widget>[
        ViewButton(
          message: preference.text.more,
          onPressed: () => showBibleInfo(book),
          child: ViewLabel(
            icon: LideaIcon.dotHoriz,
            iconColor: state.theme.highlightColor,
          ),
        ),
      ],
      child: ViewBlockCard(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: bookDecoration(index, book),
      ),
    );
  }

  Widget bookDecoration(int index, BooksType book) {
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
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor
                    : book.selected
                        ? Theme.of(context).highlightColor
                        : Colors.transparent,
              ),
              child: Icon(
                LideaIcon.record,
                size: 18,
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
    final isAva = book.available > 0;
    // bool isPrimary = book.identify == collection.primaryId;
    bool isPrimary = book.identify == App.core.data.primaryId;
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DefaultTextStyle(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: isAva ? FontWeight.w400 : FontWeight.w300,
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
              // style: Theme.of(context).textTheme.bodySmall!.copyWith(
              //       color: isAva ? null : Theme.of(context).hintColor,
              //     ),
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
