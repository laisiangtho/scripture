part of 'main.dart';

mixin _Bottom on _State {
  Widget bottomSheet() {
    return _BottomSheet(
      nextChapter: setChapterNext,
      previousChapter: setChapterPrevious,
      verseSelectionList: verseSelectionList,
    );
  }
}

class _BottomSheet extends StatefulWidget {
  _BottomSheet({
    this.nextChapter,
    this.previousChapter,
    this.verseSelectionList
  });

  final void Function() nextChapter;
  final void Function() previousChapter;
  final List<int> verseSelectionList;
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<_BottomSheet>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;


  List<int> get verseSelectionList => widget.verseSelectionList;
  bool get hasVerseSelection => verseSelectionList.length > 0;

  final double minChildSize = 0.070;
  final double maxChildSize = 0.5;

  // NOTE: update when scroll notify
  double initialChildSize = 0.070;
  bool isExpanded = false;

  void toggleSheet() {
    setState(() {
      initialChildSize = isExpanded ? minChildSize : maxChildSize;
      isExpanded = !isExpanded;
    });
    DraggableScrollableActuator.reset(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DraggableScrollableActuator(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (DraggableScrollableNotification notification) {
          initialChildSize = notification.extent;
          if (initialChildSize == maxChildSize) {
            isExpanded = true;
          } else if (initialChildSize == minChildSize) {
            isExpanded = false;
          }
          return true;
        },
        child: DraggableScrollableSheet(
          key: UniqueKey(),
          expand: false,
          initialChildSize: initialChildSize < minChildSize?minChildSize:initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (BuildContext _, ScrollController controller) {
            return sheetDecoration(
              child: sheetShape(
                child: scroll(controller)
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
      // color: Theme.of(context).backgroundColor,
      // color: Theme.of(context).primaryColor,
      // color: Colors.indigo,
      // shadowColor: Colors.grey,
      shadowColor: Theme.of(context).backgroundColor,
      child: Container(
        child: child
      )
    );
  }

  CustomScrollView scroll(ScrollController controller) {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        // SliverFillRemaining(
        //   child: Text('Body'),
        // ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                child: Text('test $index'),
              ),
              childCount: 20,
              // addAutomaticKeepAlives: true
            ),
          )
        )
      ]
    );
  }

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:true,
      delegate: new ScrollBarDelegate(_bar,minHeight:45, maxHeight:45)
    );
  }

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
          // BoxShadow(
          //   blurRadius:1.0,
          //   // color: Colors.white12,
          //   color: Theme.of(context).backgroundColor.withOpacity(0.8),
          //   // color: this.backgroundColor,
          //   spreadRadius: 0.2,
          //   offset: Offset(0.0, 0.0),
          // )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // overflow: Overflow.visible,
        // fit: StackFit.passthrough,
        children: <Widget>[
          button(
            message: "Previous chapter",
            child: Icon(
              Icons.chevron_left,
              size:40,
              color:Colors.grey
            ),
            onPressed:widget.previousChapter
          ),

          button(
            message: "Next chapter",
            child: Icon(
              Icons.chevron_right,
              size:40,
              color:Colors.grey
            ),
            onPressed:widget.nextChapter
          ),

          button(
            message: "Verse selection",
            onPressed:null,
            // child: Text('Compare ${verseSelectionList.length}'),
            child: Stack(
              overflow: Overflow.visible,
              fit: StackFit.passthrough,
              children: <Widget>[
                // Text('Verse'),
                Icon(
                  Icons.assignment,
                  color: hasVerseSelection?Colors.red[300]:Colors.grey[300],
                ),
                new Positioned(
                  top: -9.0,
                  right: -9.0,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical:1,horizontal: 5),
                      decoration: BoxDecoration(
                        color: hasVerseSelection?Colors.red:Colors.grey[400],
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

          button(
            message: "Compare selected verse",
            child: Text('Parallel'),
            onPressed:hasVerseSelection?()=>null:null
          ),


          button(
            message: "Copy selection",
            // child: Text('Copy'),
            child: Icon(
              Icons.content_copy,
              size:25,
              color:Colors.grey
            ),
            onPressed:hasVerseSelection?()=>null:null
          ),

          // button(
          //   message: "Drag up",
          //   child: Icon(
          //     Icons.keyboard_arrow_up,
          //     size:40,
          //     color:Colors.grey
          //   ),
          //   onPressed:null
          // ),
          button(
            message: "Toggle",
            child: Icon(
              isExpanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
              size:25,
              color:Colors.grey
            ),
            onPressed:toggleSheet
          ),

        ],
      ),
    );
  }

  Widget button({String message,Widget child, Function onPressed}) {
    return Tooltip(
      message: message,
      child: CupertinoButton(
        pressedOpacity: 0.5,
        // padding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 0,horizontal:0),
        // color: isButtomSelected?Colors.red:null,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        // padding: EdgeInsets.all(20),
        disabledColor: Colors.grey[100],
        child: child,
        onPressed: onPressed,
      ),
    );
  }
  // Widget nestedScroll() {
  //   return NestedScrollView(
  //     controller: scrollController,
  //     // physics: ScrollPhysics(parent: PageScrollPhysics()),
  //     // primary:false,
  //     physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
  //       return <Widget>[
  //         SliverAppBar(
  //           expandedHeight: 130.0,
  //           floating: false,
  //           pinned: true,
  //           flexibleSpace: FlexibleSpaceBar(
  //             title: new Text('abc'),
  //           ),
  //         ),
  //       ];
  //     },
  //     body: scroll()
  //   );
  // }

  Widget nextChapter() {
    return Container(
      child: Align(
        // alignment: Alignment(1.0, 0.97),
        // alignment: Alignment((1.0+stretch), 0.97),
        alignment: Alignment.topRight,
        child: Tooltip(
          message: "Next chapter",
          child: RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            highlightColor: Colors.black45,
            shape: new RoundedRectangleBorder(
              // borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
              borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 30))
            ),
            // constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
            constraints: BoxConstraints(minHeight: 50, minWidth: 60),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(Icons.chevron_right,color: Colors.white, size: 40,),
            onPressed: ()=>null
          ),
        ),
      ),
    );
  }

  Widget previousChapter(double stretch, double shrink) {
    return Align(
      // alignment: Alignment.topLeft,
      // alignment: Alignment(-1.0, 0.97),
      // alignment: Alignment((-1.0-shrink), 0.97),
      // alignment: Alignment((-1.0-shrink), (0.0-shrink)),
      alignment: Alignment((-1.0-shrink), (0.0-shrink)),
      // alignment: Alignment.bottomLeft,
      // alignment: Alignment((-1.0-shrink), (shrink*stretch)),
      child: Tooltip(
        message: "Previous chapter",
        child: Opacity(
          opacity: (stretch-shrink).clamp(0.0, 0.98),
          child: RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            fillColor: Theme.of(context).backgroundColor,
            // fillColor: Theme.of(context).backgroundColor.withOpacity(1.0*stretch),
            highlightColor: Colors.black45,

            shape: new RoundedRectangleBorder(
              // borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 20))
              borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 30))
            ),
            constraints: BoxConstraints(minHeight: 40, minWidth: 50),
            // constraints: BoxConstraints(
            //   minHeight: 20*stretch,
            //   // maxHeight: 50*stretch,
            //   minWidth: 60*stretch
            // ),
            // padding:EdgeInsets.symmetric(horizontal:10*stretch, vertical: 5*stretch),
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 45*stretch,
            ),
            onPressed: ()=>null
          ),
        ),
      ),
    );
  }

}