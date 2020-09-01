part of 'main.dart';

class _BottomSheet extends StatefulWidget {
  _BottomSheet({
    Key key,
    this.nextChapter,
    this.previousChapter,
    this.verseSelectionList,
    this.verseSelectionCopy,
    this.scrollToIndex,
    // this.primaryBible
  }) : super(key: key);

  final void Function() nextChapter;
  final void Function() previousChapter;
  final void Function() verseSelectionCopy;
  final Future<void> Function(int) scrollToIndex;
  // final void Function(int) scrollToIndex;
  final List<int> verseSelectionList;
  // final BIBLE primaryBible;
  @override
  _BottomSheetView createState() => _BottomSheetView();
}

abstract class _BottomSheetState extends State<_BottomSheet> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController tabController;
  ScrollController scrollController;
  Animation controllerAnimation;
  AnimationController animationController;
  BuildContext contextDraggable;

  // final core = Core();

  final keyMenu = UniqueKey();
  final keyParallel = UniqueKey();
  final keyAudio = UniqueKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // if (pageView.length == 0){
    //   pageView = [
    //     WidgetKeepAlive(key:keyMenu, child: new BottomSheetMenu(key:menu)),
    //     WidgetKeepAlive(key:keyParallel, child: new BottomSheetParallel(key:parallel)),
    //     WidgetKeepAlive(key:keyAudio, child: new BottomSheetAudio(key:audio))
    //   ];
    // }

    animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    controllerAnimation = Tween(begin: 0.0, end: 1.0).animate(
       CurvedAnimation(parent: animationController, curve: Curves.easeIn)
    );
    animationController.forward();

    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    // tabController = TabController(length: 3, initialIndex: 0, vsync: this);
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

  final double minChildSize = .065;
  final double maxChildSize = .985;
  // final double maxChildSize = .5;
  // NOTE: update when scroll notify
  double initialChildSize = .065;
  bool isExpanded = false;

  bool get showMenu => (isExpanded && tabController.index != 0);

  void _handleTabSelection() {
    if (tabController.indexIsChanging == false) {

      setState(() {
        switcherAnimationHandler(tabController.previousIndex == 0 || tabController.index == 0);
      });
    }
  }


  void toggleSheet(){
    // TODO: read-sheet toggle
    setState(() {
      initialChildSize = isExpanded ? minChildSize : maxChildSize;
      isExpanded = !isExpanded;
      // switcherAnimationHandler(tabController.index != 0);
    });
    // DraggableScrollableActuator.reset(context);
    DraggableScrollableActuator.reset(contextDraggable);
    // print(initialChildSize);
  }

  void showParallel(){
    if (isExpanded == false) {
      toggleSheet();
    }
    if (tabController.index != 1 ) {
      tabController.animateTo(1);
    }
  }

  bool get showParallelIf => (isExpanded == false || tabController.index != 1 );

  void switcherAnimationHandler(bool status){
    if (tabController.previousIndex != tabController.index) {
      if (status) {
        if (animationController.isCompleted) {
          animationController.reset();
        }
        animationController.forward();
      }
    }
  }
}

class _BottomSheetView extends _BottomSheetState {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DraggableScrollableActuator(
      // key: ValueKey<int>(88698),
      child: NotificationListener<DraggableScrollableNotification>(
        // key: widget.key,
        // key: ValueKey<int>(88698),
        onNotification: (DraggableScrollableNotification notification) {
          initialChildSize = notification.extent;

          // if (initialChildSize > minChildSize ){
          //   scrollController.master.bottom.toggle(true);
          //   print('hide');
          // } else {
          //   scrollController.master.bottom.toggle(false);
          //   print('show');
          // }
          if (initialChildSize == maxChildSize) {
            switcherAnimationHandler(tabController.index != 0);
            isExpanded = true;
          } else if (initialChildSize == minChildSize) {
            switcherAnimationHandler(tabController.index != 0);
            isExpanded = false;
          }

          return true;
        },
        child: DraggableScrollableSheet(
          // key: keySheet,
          key: ValueKey<double>(initialChildSize),
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
          new SliverPersistentHeader(pinned: true, delegate: new ScrollBarDelegate(_bar,minHeight: 45, maxHeight: 45)),

          // TODO: somehow this prevent struggling from overscroll, need to improve but not possible flutter fixed???
          SliverLayoutBuilder(
            builder: (BuildContext context, SliverConstraints constraint) {
              return new SliverPersistentHeader(
                delegate: new ScrollBarDelegate(
                  (BuildContext context,double offset,bool overlaps, double stretch,double shrink) => TabBarView(
                    controller: tabController,
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      WidgetKeepAlive(
                        key:keyMenu,
                        child: new BottomSheetMenu(
                          verseSelectionList: verseSelectionList,controller: controller,
                        )
                      ),
                      WidgetKeepAlive(
                        key:keyParallel,
                        child: new BottomSheetParallel(
                          verseSelectionList: verseSelectionList,controller: controller,
                          scrollToIndex:widget.scrollToIndex
                        )
                      ),
                      WidgetKeepAlive(
                        key:keyAudio,
                        child: new BottomSheetAudio(
                          verseSelectionList: verseSelectionList,controller: controller,
                          scrollToIndex:widget.scrollToIndex
                        )
                      )
                    ]
                  ),
                  // maxHeight: double.infinity,
                  maxHeight: constraint.viewportMainAxisExtent-45.0,
                ),
                floating: true,
                pinned:false,
              );
            }
          ),
        ]
      ),
    );
  }
  // Widget _scroll_(ScrollController controller) {
  //   return Scaffold(
  //     body: CustomScrollView(
  //       controller: controller,
  //       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  //       slivers: <Widget>[
  //         // new SliverPersistentHeader( pinned: true, delegate: new ScrollBarDelegate(_bar, minHeight: 45, maxHeight: 45)),
  //         SliverOverlapAbsorber(
  //           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //           sliver: new SliverPersistentHeader( pinned: true, delegate: new ScrollBarDelegate(_bar, minHeight: 45, maxHeight: 45))
  //         ),
  //         SliverOverlapInjector(
  //           // This is the flip side of the SliverOverlapAbsorber above.
  //           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //           // sliver: sliverPersistentHeader(),
  //         ),

  //         // TODO: somehow this prevent struggling from overscroll, need to improve but not possible flutter fixed???

  //         SliverLayoutBuilder(
  //           builder: (BuildContext context, SliverConstraints constraint) {
  //             return new SliverPersistentHeader(
  //               delegate: new ScrollBarDelegate(
  //                 (BuildContext context,double offset,bool overlaps, double stretch,double shrink) => TabBarView(
  //                   controller: tabController,
  //                   physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  //                   children: [
  //                     WidgetKeepAlive(
  //                       key:keyMenu,
  //                       child: new BottomSheetMenu(
  //                         verseSelectionList: verseSelectionList,controller: controller,
  //                       )
  //                     ),
  //                     WidgetKeepAlive(
  //                       key:keyParallel,
  //                       child: new BottomSheetParallel(
  //                         verseSelectionList: verseSelectionList,controller: controller,
  //                         scrollToIndex:widget.scrollToIndex
  //                       )
  //                     ),
  //                     WidgetKeepAlive(
  //                       key:keyAudio,
  //                       child: new BottomSheetAudio(
  //                         verseSelectionList: verseSelectionList,controller: controller,
  //                         scrollToIndex:widget.scrollToIndex
  //                       )
  //                     )
  //                   ]
  //                 ),
  //                 // maxHeight: double.infinity,
  //                 maxHeight: constraint.viewportMainAxisExtent-45.0,
  //               ),
  //               floating: true,
  //               pinned:false,
  //             );
  //           }
  //         ),

  //       ]
  //     ),
  //   );
  // }

  Widget _bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink) {
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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double switchWidth = 140.0;
          double mainWidth = constraints.maxWidth - switchWidth;
          return Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // color: Colors.red,
                  width: switchWidth,
                  child: buttonSwitcher(),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  // color: Colors.blue,
                  width: mainWidth,
                  child: buttonAction,
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget button({Key key,String message,Widget child, Function onPressed,double horizontal:20}) {
    return Tooltip(
      key: key,
      message: message,
      child: CupertinoButton(
        // pressedOpacity: 0.5,
        // color: Colors.red,
        // padding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 0,horizontal:horizontal),
        // color: isButtomSelected?Colors.red:null,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        // padding: EdgeInsets.all(20),
        disabledColor: Colors.grey[100],
        child: child,
        onPressed: onPressed,
      ),
    );
  }

  Widget buttonSwitcher() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds:200),
      reverseDuration: Duration(milliseconds:50),
      // transitionBuilder: (Widget child, Animation<double> animation)  => ScaleTransition(child: child, scale: animation),
      transitionBuilder: buttonSwitcherTransitionBuilder,
      child: this.showMenu?buttonSwitcherMenu:buttonSwitcherNavigator
    );
  }

  Widget buttonSwitcherTransitionBuilder(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) {
        return Opacity(
          opacity: controllerAnimation.value,
          child: ScaleTransition(
            scale: controllerAnimation,
            child: widget,
          ),
        );
      },
      child: child,
    );
  }

  Widget get buttonSwitcherMenu {
    return button(
      key: ValueKey<int>(101),
      message: "Option",
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left:0, right:7),
            child: Icon(
              Icons.arrow_back_ios,
              // size:20,
              // color:Colors.grey
            ),
          ),
          Text('Option'),
        ],
      ),
      onPressed:(){
        tabController.animateTo(0,duration: Duration(milliseconds:200));
      }
    );
  }

  Widget get buttonSwitcherNavigator {
    return Row(
      // key: ValueKey<String>('bottom-switcher-nav'),
      key: ValueKey<int>(102),
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        button(
          message: "Previous chapter",
          child: Icon(
            // Icons.chevron_left,
            Icons.arrow_back_ios
            // size:30,
          ),
          onPressed:widget.previousChapter
        ),

        button(
          message: "Next chapter",
          child: Icon(
            // Icons.chevron_right,
            Icons.arrow_forward_ios,
            // size:30,
          ),
          onPressed:widget.nextChapter
        ),
      ],
    );
  }

  Widget get buttonAction {
    return Row(
      key: ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        button(
          message: "Compare selected verse Parallel",
          child: Text('Parallel'),
          // horizontal: 2,
          // child: Icon(Icons.scatter_plot,),
          onPressed:showParallelIf?showParallel:null
        ),
        // button(
        //   message: "Listen",
        //   // child: Text('Audio'),
        //   child: Icon(Icons.audiotrack,),
        //   // horizontal: 2,
        //   onPressed:()=>null
        // ),

        button(
          message: "Copy verse selection",
          onPressed:hasVerseSelection?widget.verseSelectionCopy:null,
          // child: Text('Compare ${verseSelectionList.length}'),
          child: Stack(
            overflow: Overflow.visible,
            fit: StackFit.passthrough,
            children: <Widget>[
              Text('Copy'),
              // Icon(
              //   // Icons.assignment,
              //   Icons.content_copy,
              // ),
              if(hasVerseSelection)new Positioned(
                top: -9.0,
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

        // button(
        //   message: "Copy selection",
        //   // child: Text('Copy'),
        //   child: Icon(
        //     Icons.content_copy,
        //     size:25,
        //     color:Colors.grey
        //   ),
        //   onPressed:hasVerseSelection?()=>null:null
        // ),

        // button(
        //   message: "Drag up",
        //   child: Icon(
        //     Icons.keyboard_arrow_up,
        //     size:40,
        //     color:Colors.grey
        //   ),
        //   onPressed:null
        // ),
        // VerticalDivider(
        //   width: 50,
        // ),
        button(
          message: "Toggle",
          child: Icon(
            isExpanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
            size:25,
          ),
          onPressed:toggleSheet
        ),
      ],
    );
  }
}