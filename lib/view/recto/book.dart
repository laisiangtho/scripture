import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends CommonStates<Main> with TickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();
  late final ExpansionTileController _expansionController = ExpansionTileController();

  // ScrollPhysics? physics
  late final ValueNotifier<ScrollPhysics?> _scrollPhysics =
      ValueNotifier<ScrollPhysics?>(const ClampingScrollPhysics());

  Scripture get scripture => app.scripturePrimary;

  List<OfBook> get books => scripture.bookList;

  final List<int> expandedList = [];

  bool showBookInitiated = false;

  int get showBookId {
    if (state.param.map.isNotEmpty && state.param.map['book'] != null) {
      return state.param.map['book'] as int;
    }
    return 0;
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   if (!showBookInitiated && showBookId > 0) {
    //     _scrollOnInitiate();
    //   } else {
    //     _scrollPhysics.value = null;
    //   }
    // }).whenComplete(() {
    //   showBookInitiated = true;
    // });
    Future.delayed(Duration(milliseconds: showBookId * 7), () {
      _scrollOnInitiate().whenComplete(() {
        showBookInitiated = true;
        _scrollPhysics.value = null;
      });
    });
  }

  Future<void> _scrollOnInitiate() {
    if (showBookInitiated == true || showBookId <= 0) {
      return Future.delayed(const Duration(milliseconds: 100));
    }

    final offsetList = books.where((e) {
      return e.info.id < showBookId;
    }).map<double>((e) {
      final key = e.key as GlobalKey;
      if (key.currentContext != null) {
        final render = key.currentContext!.findRenderObject() as RenderBox;
        // return render.size.height + 1.98;
        return render.size.height;
      }
      return 0.0;
    });
    double offset = 0;
    if (offsetList.isNotEmpty) {
      final zero = offsetList.where((e) => e == 0.0);
      final nonZero = offsetList.where((e) => e > 0.0);
      // final offset = offsetList.reduce((a, b) => a + b) + (average * zero.length);
      offset = nonZero.reduce((a, b) => a + b);
      if (zero.isNotEmpty) {
        final average = nonZero.map((e) => e).reduce((a, b) => a + b) / nonZero.length;

        offset = offset + (average * zero.length);
      }
    }
    // _scrollController
    //     .animateTo(
    //   offset,
    //   duration: Duration(milliseconds: showBookId * 3),
    //   curve: Curves.easeInOut,
    // )
    //     .whenComplete(() {
    //   Future.delayed(Duration(milliseconds: showBookId * 10), () {
    //     debugPrint('showBookId whenComplete delayed');
    //     _expansionController.expand();
    //   });
    //   debugPrint('showBookId whenComplete');
    // });
    return _scrollController
        .animateTo(
      offset,
      duration: Duration(milliseconds: showBookId * 15),
      curve: Curves.easeInOut,
    )
        .whenComplete(() {
      return Future.delayed(Duration(milliseconds: showBookId * 2), () {
        _expansionController.expand();
      });
    });

    // Future.delayed(Duration(milliseconds: showBookId * 2), () {
    //   _scrollController.jumpTo(offset);
    // }).whenComplete(() {
    //   Future.delayed(Duration(milliseconds: showBookId * 10), () {
    //     debugPrint('showBookId whenComplete delayed');
    //     _expansionController.expand();
    //   });
    //   debugPrint('showBookId whenComplete');
    // });
  }

  void _scrollToIndex(bool isExpanded, int index) {
    // 350
    Future.delayed(const Duration(milliseconds: 300), () {
      final key = books.elementAt(index).key as GlobalKey;
      final keyContext = key.currentContext;
      if (keyContext != null && keyContext.mounted) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 350),
          curve: Curves.ease,
        );
      }
    });

    // Future.delayed(const Duration(milliseconds: 300)).then((value) {
    //   final key = books.elementAt(index).key as GlobalKey;

    //   final keyContext = key.currentContext;
    //   if (keyContext != null) {
    //     Scrollable.ensureVisible(
    //       keyContext,
    //       duration: const Duration(milliseconds: 100),
    //       curve: Curves.ease,
    //     );
    //   }
    // });
  }

  // void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index) {
  //   final key = books.elementAt(index).key as GlobalKey;
  //   final keyContext = key.currentContext;
  //   if (keyContext != null) {
  //     // make sure that your widget is visible
  //     final box = keyContext.findRenderObject() as RenderBox;
  //     _scrollController.animateTo(
  //       isExpanded ? (box.size.height * index) : previousOffset,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.linear,
  //     );
  //   }
  // }
}

mixin _Header on _State {
  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kTextTabBarHeight,
      left: [
        OptionButtons.backOrCancel(
          back: lang.back,
          cancel: lang.cancel,
        ),
      ],
      primary: ViewHeaderTitle.fixed(
        // alignment: Alignment.lerp(
        //   const Alignment(0, 0),
        //   const Alignment(0, 0),
        //   vhd.snapShrink,
        // ),
        label: lang.book('true'),
      ),
      right: [
        ViewButtons(
          style: style.titleSmall,
          onPressed: () {
            // Navigator.of(context).pushNamed('recto-title');
            context.push('/recto-title');
          },
          child: ViewMarks(
            label: lang.title(''),
          ),
        ),
      ],
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ViewBars(
        height: kTextTabBarHeight,
        // forceOverlaps: false,
        forceStretch: true,
        backgroundColor: theme.primaryColor,
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,

        child: _header(),
      ),
      body: Views(
        heroController: HeroController(),
        child: ValueListenableBuilder<ScrollPhysics?>(
          valueListenable: _scrollPhysics,
          builder: (BuildContext context, ScrollPhysics? value, Widget? child) {
            return CustomScrollView(
              physics: value,
              controller: _scrollController,
              slivers: _slivers,
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewLists.separator(
        // sliver: true,
        decoration: BoxDecoration(
          color: CardTheme.of(context).color,
          // boxShadow: [
          //   BoxShadow(
          //     color: CardTheme.of(context).shadowColor!,
          //     blurRadius: 0.2,
          //     spreadRadius: 0.0,
          //     offset: const Offset(0.0, 0.0),
          //   )
          // ],
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        // duration: const Duration(milliseconds: 100),
        // itemSnap: const BookNameItem.snap(),
        // itemPrototype: const BookNameItem.snap(),
        separator: (BuildContext context, int index) {
          return const ViewDividers();
        },
        itemBuilder: (BuildContext context, int index) {
          final book = books.elementAt(index);
          return BookNameItem(
            // id: book.key,
            child: bookItem(index, book),
          );
        },

        itemCount: books.length,
      ),
    ];
  }

  Widget bookItem(int index, OfBook book) {
    return ExpansionTile(
      key: book.key,
      controller: showBookId == book.info.id ? _expansionController : null,
      textColor: theme.hintColor,
      // selectedTileColor: Colors.blue,
      // selectedTileColor: theme.cardColor,
      // selectedColor: theme.dividerColor,
      // contentPadding: EdgeInsets.zero,
      // horizontalTitleGap: 0,
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),

      // shape: Border(
      //   top: BorderSide(
      //     width: 0.4,
      //     color: theme.dividerColor,
      //   ),
      // ),
      iconColor: theme.highlightColor,
      collapsedIconColor: theme.focusColor,
      // initiallyExpanded: showBookId == book.id,
      // maintainState: true,
      // collapsedBackgroundColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: Text(
        // preference.digit(book.id.toString()),
        scripture.digit(book.info.id),
        // book.id.toString(),
        textAlign: TextAlign.center,
        // style: TextStyle(
        //   color: theme.primaryColorDark,
        // ),
        style: style.titleMedium?.copyWith(
          color: theme.hintColor,
        ),
      ),

      title: Text(
        book.info.name,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: style.titleMedium,
      ),
      // trailing: ViewMarks(
      //   iconLeft: false,
      //   // icon: Icons.arrow_forward_ios_rounded,
      //   icon: Icons.expand_more_rounded,
      //   iconSize: 20,
      //   // iconColor: theme.hintColor,
      //   label: preference.digit(book.chapterCount),
      // ),
      onExpansionChanged: (isExpanded) {
        // if (isExpanded) previousOffset = _scrollController.offset;
        // previousOffset = _scrollController.offset;
        _scrollToIndex(isExpanded, index);
      },

      childrenPadding: const EdgeInsets.only(bottom: 15),
      children: [
        chapterList(book),
      ],
    );
  }

  Widget chapterList(OfBook book) {
    // final itemCount = book.totalChapter + 1;
    final itemCount = book.totalChapter + 2;
    // const itemMin = 5;
    // final itemLimit = itemCount > itemMin;
    // final perItem = itemLimit ? itemMin : itemCount;

    return ViewGrids(
      // shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 80,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1.36,
      ),

      // duration: const Duration(milliseconds: 300),
      // itemSnap: const ChapterNameItem.snap(),
      itemBuilder: (BuildContext ctx, index) {
        // return ChapterNameItem(bookId: book.info.id, chapterId: index);
        return ChapterNameItem(book: book, index: index);
      },
      itemCount: itemCount,
    );
  }
}

class BookNameItem extends StatelessWidget {
  // final dynamic id;
  final Widget? child;
  const BookNameItem({
    super.key,
    // required this.id,
    required this.child,
  });
  const BookNameItem.snap({super.key}) : child = null;

  @override
  Widget build(BuildContext context) {
    final tpl = Theme.of(context);
    if (child == null) {
      return ListTile(
        leading: Container(
          constraints: const BoxConstraints(
            maxHeight: 20,
            maxWidth: 20,
          ),
          decoration: BoxDecoration(
            color: tpl.disabledColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 57),
          height: 20,
          decoration: BoxDecoration(
            color: tpl.disabledColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }

    return child!;
    //   return ViewCards.list(
    //     child: ListTile(
    //       leading: Container(
    //         constraints: const BoxConstraints(
    //           maxHeight: 20,
    //           maxWidth: 20,
    //         ),
    //         decoration: BoxDecoration(
    //           color: theme.disabledColor,
    //           borderRadius: const BorderRadius.all(Radius.circular(10)),
    //         ),
    //       ),
    //       title: Container(
    //         margin: const EdgeInsets.only(right: 57),
    //         height: 20,
    //         decoration: BoxDecoration(
    //           color: theme.disabledColor,
    //           borderRadius: const BorderRadius.all(Radius.circular(10)),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // return ViewCards.list(
    //   key: id,
    //   child: child,
    // );
  }
}

class ChapterNameItem extends StatelessWidget {
  final OfBook? book;
  final int? index;
  const ChapterNameItem({
    super.key,
    required this.book,
    required this.index,
  });

  const ChapterNameItem.snap({super.key})
      : book = null,
        index = null;

  Core get app => App.core;
  Data get data => app.data;
  Preference get preference => app.preference;

  bool get isCurrentChapter => data.bookId == book?.info.id && data.chapterId == index;
  // bool get isChapter => chapterId != null && chapterId! > 0;
  bool get isChapter => index != null && index! > 0 && index! <= book!.totalChapter;

  Scripture get scripture => app.scripturePrimary;

  @override
  Widget build(BuildContext context) {
    final tpl = Theme.of(context);
    const margin = EdgeInsets.symmetric(vertical: 4, horizontal: 4);
    // book?.totalChapter

    if (book == null) {
      return ViewButtons.filled(
        margin: margin,
        enable: false,
        child: ViewMarks(
          icon: Icons.signpost_rounded,
          // iconColor: theme.disabledColor,
          iconColor: tpl.primaryColorDark.withOpacity(0.3),
        ),
      );
    }

    if (isChapter) {
      return ViewButtons.filled(
        margin: margin,
        color: tpl.primaryColor.withOpacity(isCurrentChapter ? 0.4 : 1),
        showShadow: isCurrentChapter,
        message: preference.lang(context).chapter(''),
        child: ViewMarks(
          label: scripture.digit(index),
          labelStyle: tpl.textTheme.labelLarge?.copyWith(
            color: isCurrentChapter ? tpl.hintColor.withOpacity(0.3) : null,
          ),
        ),
        onPressed: () {
          // Navigator.of(context, rootNavigator: true).maybePop(
          //   {'book': book?.info.id, 'chapter': index},
          // );

          app.route.context.pop({'book': book?.info.id, 'chapter': index});
        },
      );
    }

    if (index == book!.totalChapter + 1) {
      /// NOTE: verse merge
      return ViewButtons.filled(
        margin: margin,
        message: preference.text('verse-merged'),
        child: ViewMarks(
          icon: Icons.merge,
          iconColor: tpl.primaryColorDark.withOpacity(0.3),
        ),
        onPressed: () {
          // Navigator.of(context).pushNamed('recto-merge', arguments: {'book': book?.info.id});
          context.push('/recto-merge', extra: {'book': book?.info.id});
        },
      );
    }

    return ViewButtons.filled(
      margin: margin,
      // color: theme.primaryColor,
      showShadow: false,
      message: preference.lang(context).title(''),
      child: ViewMarks(
        icon: Icons.signpost_rounded,
        iconColor: tpl.primaryColorDark.withOpacity(0.3),
      ),
      onPressed: () {
        // Navigator.of(context).pushNamed('recto-title', arguments: {'book': book?.info.id});
        context.push('/recto-title', extra: {'book': book?.info.id});
      },
    );
  }
}
