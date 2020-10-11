part of 'main.dart';

class _BottomSheet extends StatefulWidget {
  _BottomSheet({
    Key key,
    this.nextChapter,
    this.previousChapter,
    this.verseSelectionList,
    this.verseSelectionCopy,
    this.scrollToIndex,
  }) : super(key: key);

  final void Function() nextChapter;
  final void Function() previousChapter;
  final void Function() verseSelectionCopy;
  final Future<void> Function(int,{bool isId}) scrollToIndex;
  final List<int> verseSelectionList;
  @override
  _BottomSheetView createState() => _BottomSheetView();
}

abstract class _BottomSheetState extends State<_BottomSheet> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // final core = Core();
  final keyMenu = UniqueKey();
  final keyParallel = UniqueKey();
  final keyAudio = UniqueKey();

  final scaffoldParallel = GlobalKey<ScaffoldState>();
  final scaffoldAudio = GlobalKey<ScaffoldState>();

  TabController tabController;
  ScrollController scrollController;

  BuildContext contextDraggable;

  final double shrinkSize = 10.0;
  double get height => kBottomNavigationBarHeight-shrinkSize;

  double get heightDevice => MediaQuery.of(context).size.height-shrinkSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    tabController.addListener(_handleTabSelection);

  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  List<int> get verseSelectionList => widget.verseSelectionList;
  bool get hasVerseSelection => verseSelectionList.length > 0;

  double get minChildSize => (height/heightDevice);
  // NOTE: update when scroll notify
  double initialChildSize = 0.0;
  final double maxChildSize = 0.985;
  final double midChildSize = 0.5;

  void _handleTabSelection() {
    if (tabController.indexIsChanging == false) {
      setState(() {
        // switcherAnimationHandler(tabController.previousIndex == 0 || tabController.index == 0);
      });
    }
  }

  bool _scrollableNotification(DraggableScrollableNotification notification) {
    double childSize = notification.extent;
    navigatorController(childSize);
    initialChildSize = childSize;
    return true;
  }

  void navigatorController(double childSize){
    double _heightNotify = scrollController.master.bottom.heightNotify.value;
    double _offset = (childSize-minChildSize)*10;
    double _delta = _offset.clamp(0.0, 1.0);
    double shrink = (1.0 - _delta).toDouble();
    if (childSize > initialChildSize) {
      // print('up');
      shrink = min(shrink,_heightNotify);
    } else {
      // print('down');
      shrink = max(shrink,_heightNotify);

    }
    if (_heightNotify > 0.0 || _heightNotify < 1.0) {
      scrollController.master.bottom.heightNotify.value = shrink;
    }

  }

  bool get isDefaultSize => initialChildSize <= minChildSize;
  bool get checkChildSize => initialChildSize < midChildSize;
  bool get isDefaultPage => tabController.index == 0;

  // bool get showParallelIf => (isDefaultSize || isDefaultPage == false );
  void showParallel(){
    navigatorController(checkChildSize?1.0:0.0);
    setState(() {
      initialChildSize = checkChildSize?midChildSize:minChildSize;
    });
    DraggableScrollableActuator.reset(contextDraggable);

    if (isDefaultPage == false) {
      tabController.animateTo(0);
    }
  }

  bool get showAudioIf => (isDefaultSize || tabController.index != 1);
  void showAudio(){
    if (isDefaultSize){
      navigatorController(isDefaultSize?1.0:0.0);
      setState(() {
        initialChildSize = isDefaultSize?midChildSize:minChildSize;
      });
      DraggableScrollableActuator.reset(contextDraggable);
    }

    if (isDefaultPage) {
      tabController.animateTo(1);
    }
  }

  // void switcherAnimationHandler(bool status){
  //   if (tabController.previousIndex != tabController.index) {
  //     if (status) {
  //       if (animationController.isCompleted) {
  //         animationController.reset();
  //       }
  //       animationController.forward();
  //     }
  //   }
  // }
}

class _BottomSheetView extends _BottomSheetState {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('$minChildSize $initialChildSize');
    return DraggableScrollableActuator(
      // key: ValueKey<int>(88698),
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
              child: sheetShape(
                child: _scroll(controller)
              )
            );
          }
        ),
      ),
    );
  }

  Widget sheetDecoration({Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:3),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        borderRadius: new BorderRadius.vertical(
          top: Radius.elliptical(3, 7),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.3,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.5,
            offset: Offset(0.0, -0.3),
          )
        ]
      ),
      child: child
    );
  }

  Widget sheetShape({Widget child}) {
    return Material(
      // shape: ShapedArrow(arrow:20, borderRadius: BorderRadius.vertical(top: Radius.elliptical(3,3)), padding: 0),
      shape: new RoundedRectangleBorder(
        // borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
        borderRadius: new BorderRadius.vertical(
          top: Radius.elliptical(3, 7),
        )
      ),
      clipBehavior: Clip.antiAlias,
      elevation:0,
      shadowColor: Theme.of(context).backgroundColor,
      child: child
    );
  }

  Widget _scroll(ScrollController controller) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          // new SliverPersistentHeader(pinned: true, delegate: new ScrollBarDelegate(_bar)),
          new SliverPersistentHeader(pinned: true, delegate: new ScrollBarDelegate(_bar,minHeight: height, maxHeight: height)),

          // ???: somehow this prevent struggling from overscroll, need to improve but not possible flutter fixed???
          // SliverLayoutBuilder(
          //   builder: (BuildContext context, SliverConstraints constraint) {
          //     return new SliverPersistentHeader(
          //       delegate: new ScrollBarDelegate(
          //         (BuildContext context,double offset,bool overlaps, double stretch,double shrink) => TabBarView(
          //           controller: tabController,
          //           physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          //           children: [
          //             // WidgetKeepAlive(
          //             //   key:keyMenu,
          //             //   child: new BottomSheetMenu(
          //             //     verseSelectionList: verseSelectionList,controller: controller,
          //             //   )
          //             // ),
          //             WidgetKeepAlive(
          //               key:keyParallel,
          //               child: new BottomSheetParallel(
          //                 key: scaffoldParallel,
          //                 verseSelectionList: verseSelectionList,controller: controller,
          //                 scrollToIndex:widget.scrollToIndex
          //               )
          //             ),
          //             // WidgetKeepAlive(
          //             //   key:keyAudio,
          //             //   child: new BottomSheetAudio(
          //             //     key: scaffoldAudio,
          //             //     verseSelectionList: verseSelectionList,controller: controller,
          //             //     scrollToIndex:widget.scrollToIndex
          //             //   )
          //             // )
          //           ]
          //         ),
          //         // maxHeight: double.infinity,
          //         // maxHeight: constraint.viewportMainAxisExtent-45.0,
          //         maxHeight: constraint.viewportMainAxisExtent-height,
          //       ),
          //       floating: true,
          //       pinned:false,
          //     );
          //   }
          // ),
          SliverFillRemaining(
            child: WidgetKeepAlive(
              key:keyParallel,
              child: new BottomSheetParallel(
                key: scaffoldParallel,
                verseSelectionList: verseSelectionList,controller: controller,
                scrollToIndex:widget.scrollToIndex
              )
            )
          )
        ]
      ),
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink) {
    // return buttonList;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        // borderRadius: BorderRadius.all( Radius.elliptical(3,3)),
        boxShadow: [
          BoxShadow(
            blurRadius:0.2,
            // color: Colors.white12,
            // color: Theme.of(context).backgroundColor.withOpacity(0.8),
            color: Colors.grey,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          )
        ]
      ),
      child: buttonList
    );
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
          child: Icon(CustomIcon.chapter_previous,size: 25),
          onPressed:widget.previousChapter
        ),

        button(
          message: "Next chapter",
          child: Icon(CustomIcon.chapter_next,size: 25),
          onPressed:widget.nextChapter
        ),

        button(
          message: "Compare selected verse Parallel",
          child: Icon(
            CustomIcon.language, size: 22
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
        button(
          message: "Copy/Share selected verse",
          onPressed:hasVerseSelection?widget.verseSelectionCopy:null,
          // child: Text('Compare ${verseSelectionList.length}'),
          child: Stack(
            overflow: Overflow.visible,
            fit: StackFit.passthrough,
            children: <Widget>[
              Icon(CustomIcon.copy, size: 22),
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

  Widget button({Key key,String message,Widget child, Function onPressed}) {
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
        disabledColor: Colors.grey[100],
        child: child,
        onPressed: onPressed,
      ),
    );
  }

}