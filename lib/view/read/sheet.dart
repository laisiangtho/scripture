part of 'main.dart';

mixin _Sheet on _State {
  Widget showSheet(){
    return _SheetWidget(
      nextChapter: setChapterNext,
      previousChapter: setChapterPrevious,
      scrollToIndex:scrollToIndex,
      verseSelectionList:verseSelectionList,
      verseSelectionCopy:verseSelectionCopy
    );
  }
}

class _SheetWidget extends StatefulWidget {
  // final BookType book;

  final void Function() nextChapter;
  final void Function() previousChapter;
  final void Function()? verseSelectionCopy;
  final Future<void> Function(int,{bool isId}) scrollToIndex;
  final List<int> verseSelectionList;

  _SheetWidget({
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
  bool isDownloading=false;
  String message='';

  late ScrollController scrollController;
  late BuildContext contextDraggable;
  late NotifyViewScroll nav;

  final keyParallel = UniqueKey();
  final scaffoldParallel = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    nav = Provider.of<NotifyViewScroll>(context, listen: false);
  }

  List<int> get verseSelectionList => widget.verseSelectionList;
  bool get hasVerseSelection => verseSelectionList.length > 0;

  void showParallel(){
    navigatorController(checkChildSize?1.0:0.0);
    setState(() {
      initialChildSize = checkChildSize?midChildSize:minChildSize;
    });
    DraggableScrollableActuator.reset(contextDraggable);
  }

  // final double shrinkSize = 10.0;
  final double shrinkSize = 15.0;
  double get height => kBottomNavigationBarHeight-shrinkSize;

  double get heightDevice => MediaQuery.of(context).size.height-shrinkSize;

  double get minChildSize => (height/heightDevice);
  // NOTE: update when scroll notify
  double initialChildSize = 0.0;
  final double maxChildSize = 0.90;
  final double midChildSize = 0.5;

  bool _scrollableNotification(DraggableScrollableNotification notification) {
    double childSize = notification.extent;
    navigatorController(childSize);
    initialChildSize = childSize;

    return true;
  }

  void navigatorController(double childSize){
    double _heightFactor = nav.heightFactor;
    double _offset = (childSize-minChildSize)*shrinkSize;
    double _delta = _offset.clamp(0.0, 1.0);
    double shrink = (1.0 - _delta).toDouble();
    if (childSize > initialChildSize) {
      // debugPrint('up');
      shrink = min(shrink,_heightFactor);
    } else {
      // debugPrint('down');
      shrink = max(shrink,_heightFactor);
    }
    if (_heightFactor > 0.0 || _heightFactor < 1.0) {
      nav.heightFactor = shrink;
    }
  }

  bool get isDefaultSize => initialChildSize <= minChildSize;
  bool get checkChildSize => initialChildSize < midChildSize;
  // bool get isDefaultPage => tabController.index == 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      // key: ValueKey(88698),
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification:_scrollableNotification,
        child: DraggableScrollableSheet(
          // key: ValueKey<double>(initialChildSize),
          key:UniqueKey(),
          expand: false,
          initialChildSize: initialChildSize < minChildSize?minChildSize:initialChildSize,
          // initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (BuildContext _, ScrollController controller) {
            contextDraggable = _;
            scrollController = controller;

            return sheetDecoration(
              child: _scroll(controller)
            );
          }
        ),
      ),
    );
  }

  Widget sheetDecoration({Widget? child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0.5),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        // color: Colors.blue,
        borderRadius: new BorderRadius.vertical(
          top: Radius.elliptical(3, 3),
        ),
        boxShadow: [
          BoxShadow(
            // blurRadius: 0.0,
            // color: Theme.of(context).backgroundColor,
            color: Theme.of(context).backgroundColor.withOpacity(0.6),
            blurRadius: 0.0,
            spreadRadius: 0.1,
            offset: Offset(0, .1)
          )
        ]
      ),
      child: Material(
        shape: new RoundedRectangleBorder(
          // borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
          borderRadius: new BorderRadius.vertical(
            top: Radius.elliptical(3, 3),
          )
        ),
        clipBehavior: Clip.hardEdge,
        // elevation:10,
        // shadowColor: Theme.of(context).backgroundColor,
        // shadowColor: Colors.black,
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: child
      )
    );
  }

  Widget _scroll(ScrollController controller) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        controller: controller,
        // primary: true,
        // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          new SliverPersistentHeader(pinned: true, delegate: new ViewHeaderDelegate(_bar,minHeight: height, maxHeight: height)),
          SliverFillRemaining(
            child: new SheetParallel(
              key: scaffoldParallel,
              verseSelectionList: widget.verseSelectionList,
              controller: controller,
              scrollToIndex:widget.scrollToIndex
            ),
          )
          // SliverFillRemaining(
          //   child: WidgetKeepAlive(
          //     key:keyParallel,
          //     child: new SheetParallel(
          //       key: scaffoldParallel,
          //       verseSelectionList: widget.verseSelectionList,
          //       controller: controller,
          //       scrollToIndex:widget.scrollToIndex
          //     ),
          //   ),
          // )
        ]
      ),
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // color: Theme.of(context).errorColor,
        // color: Theme.of(context).primaryColor.withOpacity(0.3),
        // borderRadius: BorderRadius.all( Radius.elliptical(3,3)),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius:0.1,
        //     // color: Colors.white12,
        //     color: Theme.of(context).backgroundColor.withOpacity(shrink),
        //     // color: Colors.grey,
        //     spreadRadius: 0.1,
        //     offset: Offset(0.0, 0.1),
        //   )
        // ]
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).backgroundColor.withOpacity(0.5),
            width: 0.1,
          ),
        ),
      ),
      child: buttonList
    );
    // return ViewHeaderDecoration(
    //   overlaps: stretch > 0.3,
    //   child: buttonList
    // );
  }

  Widget get buttonList {
    return Row(
      key: ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        button(
          message: "Previous chapter",
          child: Icon(LaiSiangthoIcon.chapter_previous,size: 25),
          onPressed: widget.previousChapter
        ),

        button(
          message: "Next chapter",
          child: Icon(LaiSiangthoIcon.chapter_next,size: 25),
          onPressed: widget.nextChapter
        ),

        button(
          message: "Compare selected verse Parallel",
          child: Icon(
            LaiSiangthoIcon.language, size: 22
          ),
          // onPressed:showParallelIf?showParallel:null
          onPressed:showParallel
        ),
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
          message: "Copy/Share selected verse",
          // onPressed:hasVerseSelection?widget.verseSelectionCopy:null,
          onPressed:hasVerseSelection?widget.verseSelectionCopy:null,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: <Widget>[
              Icon(LaiSiangthoIcon.copy, size: 22),
              if(hasVerseSelection)new Positioned(
                top: -8.0,
                right: -9.0,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:1,horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text(
                      verseSelectionList.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ],
    );
  }

  Widget button({Key? key,required String message,required Widget child, VoidCallback? onPressed}) {
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
}