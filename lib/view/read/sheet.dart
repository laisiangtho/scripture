part of 'main.dart';

mixin _Sheet on _State {
  Widget showSheet() {
    return _SheetWidget(
      nextChapter: setChapterNext,
      previousChapter: setChapterPrevious,
      scrollToIndex: scrollToIndex,
      verseSelectionList: verseSelectionList,
      verseSelectionCopy: verseSelectionCopy,
    );
  }
}

class _SheetWidget extends StatefulWidget {
  // final BookType book;

  final void Function() nextChapter;
  final void Function() previousChapter;
  final void Function()? verseSelectionCopy;
  final Future<void> Function(int, {bool isId}) scrollToIndex;
  final List<int> verseSelectionList;

  const _SheetWidget({
    Key? key,
    // required this.book,
    required this.nextChapter,
    required this.previousChapter,
    required this.verseSelectionList,
    this.verseSelectionCopy,
    required this.scrollToIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetWidgetState();
}

class _SheetWidgetState extends State<_SheetWidget> with TickerProviderStateMixin {
  bool isDownloading = false;
  String message = '';

  // late ScrollController scrollController;
  late BuildContext contextDraggable;
  // late final ViewScrollNotify scrollNotify = context.read<ViewScrollNotify>();
  late final ViewScrollNotify scrollNotify = Provider.of<ViewScrollNotify>(context, listen: false);
  AppLocalizations get translate => AppLocalizations.of(context)!;

  // final keyParallel = UniqueKey();
  // final scaffoldParallel = GlobalKey<ScaffoldState>();

  // late final Core core = context.read<Core>();
  // late final Future<DefinitionBible> initiator = core.scriptureParallel.init();

  // // DefinitionBible get bibleInfo => core.collectionPrimary;
  // BIBLE get bible => core.scriptureParallel.verseChapter;
  // // BookType get tmpbible => bible.info;
  // // DefinitionBook get tmpbook => bible.book.first.info;
  // CHAPTER get tmpchapter => bible.book.first.chapter.first;
  // List<VERSE> get tmpverse => tmpchapter.verse;

  @override
  void initState() {
    super.initState();
  }

  List<int> get verseSelectionList => widget.verseSelectionList;
  bool get hasVerseSelection => verseSelectionList.isNotEmpty;

  late final AnimationController dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> dragAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(dragController);

  void showParallel() {
    _draggableEngine(checkChildSize ? 1.0 : 0.0);
    setState(() {
      initialChildSize = checkChildSize ? midChildSize : minChildSize;
    });
    // DraggableScrollableActuator.reset(contextDraggable);
    DraggableScrollableActuator.reset(context);
  }

  // final double shrinkSize = 10.0;
  final double shrinkSize = 15.0;
  double get height => kBottomNavigationBarHeight - shrinkSize;

  double get heightDevice => MediaQuery.of(context).size.height - shrinkSize;

  double get minChildSize => (height / heightDevice);
  // NOTE: update when scroll notify

  double initialChildSize = 0.0;

  final double maxChildSize = 0.90;
  final double midChildSize = 0.5;

  bool _draggableNotification(DraggableScrollableNotification dsf) {
    double childSize = dsf.extent;
    // final ad = (dsf.extent - dsf.minExtent) / (dsf.maxExtent - dsf.minExtent);
    // debugPrint('$ad');
    _draggableEngine(childSize);
    initialChildSize = childSize;

    return true;
  }

  bool _scrollNotification(dynamic scroll) {
    if (scroll is ScrollStartNotification) {
      // notify.metrics = scroll.metrics;
      // notify.isUpdating = false;
      // notify.isEnded = true;
    } else if (scroll is ScrollUpdateNotification) {
      // notify.metrics = scroll.metrics;
      // notify.isUpdating = true;
      // notify.isEnded = false;
      // notify.scrollUpdate(scroll.metrics);
    } else if (scroll is ScrollEndNotification) {
      // notify.metrics = scroll.metrics;
      // notify.isUpdating = false;
      // notify.isEnded = true;
      if (initialChildSize < 0.13) {
        debugPrint('ended $initialChildSize');
        setState(() {
          initialChildSize = 0.0;
        });
        _draggableEngine(0.0);
        DraggableScrollableActuator.reset(context);
      }
    } else if (scroll is UserScrollNotification) {
      // notify.direction = scroll.direction.index;
    }
    return false;
  }

  void _draggableEngine(double childSize) {
    // double _heightFactor = scrollNotify.heightFactor;
    // double _offset = (childSize - minChildSize) * shrinkSize;
    // double _delta = _offset.clamp(0.0, 1.0);
    // double shrink = (1.0 - _delta).toDouble();
    // if (childSize > initialChildSize) {
    //   // debugPrint('up');
    //   shrink = min(shrink, _heightFactor);
    // } else {
    //   // debugPrint('down');
    //   shrink = max(shrink, _heightFactor);
    // }
    // if (_heightFactor > 0.0 || _heightFactor < 1.0) {
    //   scrollNotify.heightFactor = shrink;
    // }
  }

  // bool get isDefaultSize => initialChildSize <= minChildSize;
  bool get checkChildSize => initialChildSize < midChildSize;
  // bool get isDefaultPage => tabController.index == 0;
  // void _verseScroll(int id) {
  //   widget.scrollToIndex(id, isId: true);
  // }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: _draggableNotification,
        child: DraggableScrollableSheet(
          key: UniqueKey(),
          expand: false,
          initialChildSize: initialChildSize < minChildSize ? minChildSize : initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (BuildContext _, ScrollController controller) {
            // contextDraggable = _;
            // scrollController = controller;
            // debugPrint('minChildSize $minChildSize $initialChildSize');
            return sheetDecoration(
              child: _scroll(controller),
            );
          },
        ),
      ),
    );
  }

  Widget sheetDecoration({Widget? child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // color: Theme.of(context).primaryColor,
        // borderRadius: const BorderRadius.vertical(
        //   top: Radius.elliptical(3, 2),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 0.1,
        //     color: Theme.of(context).shadowColor,
        //     spreadRadius: 0.0,
        //     offset: const Offset(0, -0.3),
        //   )
        // ],
        border: Border(
          top: BorderSide(
            color: Theme.of(context).shadowColor,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0.5),
        child: child,
      ),
    );
  }

  Widget _scroll(ScrollController controller) {
    return ViewPage(
      controller: controller,
      // depth: 1,
      onNotification: _scrollNotification,
      child: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          ViewHeaderSliverSnap(
            pinned: true,
            floating: false,
            heights: [height],
            // overlapsBackgroundColor: Theme.of(context).primaryColor,
            // overlapsBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // overlapsBorderColor: Theme.of(context).shadowColor,
            overlapsForce: true,
            builder: (BuildContext _, ViewHeaderData org, ViewHeaderData snap) {
              return buttonList;
            },
          ),
          SliverFillRemaining(
            child: SheetParallel(
              verseSelectionList: widget.verseSelectionList,
              controller: controller,
              scrollToIndex: widget.scrollToIndex,
            ),
          ),
        ],
      ),
    );
  }

  Widget get buttonList {
    return Row(
      key: const ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        button(
          message: translate.previousTo(translate.chapter(false)),
          child: const Icon(LideaIcon.chapterPrevious, size: 25),
          onPressed: widget.previousChapter,
        ),

        button(
          message: translate.nextTo(translate.chapter(false)),
          child: const Icon(LideaIcon.chapterNext, size: 25),
          onPressed: widget.nextChapter,
        ),

        button(
          // message: "Compare selected verse Parallel",
          message: translate.compareTo(translate.parallel),
          child: const Icon(LideaIcon.language, size: 22),
          // onPressed:showParallelIf?showParallel:null
          onPressed: showParallel,
        ),
        // Selector<ViewScrollNotify, bool>(
        //   selector: (_, e) => e.isUpdating,
        //   builder: (BuildContext context, bool message, Widget? child) {
        //     return Text('$message');
        //   },
        // ),
        // button(
        //   message: "Listen audio",
        //   child: Icon(
        //     CustomIcon.wave_square, size: 20
        //   ),
        //   onPressed:showAudioIf?showAudio:null
        // ),
        // button(
        //   message: "Copy/Share selected verse",
        //   onPressed:()=>null,
        //   // child: Text('Compare ${verseSelectionList.length}'),
        //   child: Stack(
        //     clipBehavior: Clip.none,
        //     fit: StackFit.passthrough,
        //     children: <Widget>[
        //       Icon(LaiSiangthoIcon.copy, size: 22),
        //     ],
        //   )
        // ),
        button(
          // message: "Copy/Share selected verse",
          message: translate.share,
          // onPressed:hasVerseSelection?widget.verseSelectionCopy:null,
          onPressed: hasVerseSelection ? widget.verseSelectionCopy : null,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: <Widget>[
              const Icon(LideaIcon.copy, size: 22),
              if (hasVerseSelection)
                Positioned(
                  top: -8.0,
                  right: -9.0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        verseSelectionList.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget button({
    Key? key,
    required String message,
    required Widget child,
    VoidCallback? onPressed,
  }) {
    return Tooltip(
      key: key,
      message: message,
      child: CupertinoButton(
        minSize: 30,
        // pressedOpacity: 0.5,
        // color: Colors.red,
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(vertical: 10,horizontal:0),
        // color: isButtomSelected?Colors.red:null,
        // borderRadius: BorderRadius.all(Radius.circular(2)),
        // padding: EdgeInsets.all(20),
        // disabledColor: Colors.grey[100],
        child: child,
        onPressed: onPressed,
      ),
    );
  }

  // Widget _inheritedVerse(VERSE verse) {
  //   return VerseWidgetInherited(
  //     // key: verse.key,
  //     size: core.collection.setting.fontSize,
  //     lang: core.scriptureParallel.info.langCode,
  //     selected: false,
  //     child: WidgetVerse(verse: verse, onPressed: _verseScroll),
  //   );
  // }
}
