part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    // debugPrint(kToolbarHeight);
    // debugPrint(MediaQuery.of(context).padding.top);
    return new SliverPersistentHeader(
      pinned: true,
      floating:false,
      delegate: new ViewHeaderDelegate(
        _barMain,
        // maxHeight: widget.barMaxHeight
        // maxHeight: 80,
        // minHeight: 80
      )
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return ViewHeaderDecoration(
      overlaps: stretch > 0.0,
      child: Stack(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.lerp(Alignment(0.5,0),Alignment(-0.7,0), stretch),
          //   child:Transform.rotate(
          //     angle:6*shrink,
          //     child: Container(
          //       child: Text(core.version),
          //       padding: EdgeInsets.all(2),
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).backgroundColor,
          //         borderRadius: new BorderRadius.all(Radius.circular(3))
          //       )
          //     )
          //   )
          // ),
          Align(
            // alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,-.1), stretch)!,
            // alignment: Alignment(-.8,0),
            alignment: Alignment(0,0),
            child: _barTitle(shrink)
          ),
          Align(
            // alignment: Alignment(.95,-1),
            alignment: Alignment(1,-1),
            child: Padding(
              padding: EdgeInsets.only(top: 7, right: 3),
              child: Selector<Core,bool>(
                selector: (_, e) => e.collection.boxOfBookmark.length > 0,
                builder: (BuildContext context, bool hasBookmark, Widget? child) => _barSortButton(hasBookmark)
              )

            )
          ),
        ]
      )
    );
  }

  Widget _barSortButton(bool hasBookmark){
    return Tooltip(
      message: 'Clear all',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(vertical:10,horizontal:10),
        // color: Colors.blue,
        child: new Icon(
          // Icons.home,
          LaiSiangthoIcon.trash,
          // color: this.isSorting?Colors.red:null,
          size: 18,
        ),
        onPressed: hasBookmark?onClearAll:null
      ),
    );
  }

  Widget _barTitle(double shrink){
    return Text(
      'Bookmark',
      style: TextStyle(
        fontFamily: "sans-serif",
        // color: Color.lerp(Colors.white, Colors.white24, stretch),
        // color: Colors.black,
        fontWeight: FontWeight.w400,
        // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
        // fontSize:35 - (16*stretch),
        // fontSize:(25*shrink).clamp(25.0, 35.0),
        fontSize:20,
        // shadows: <Shadow>[
        //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
        // ]
      )
    );
  }

}
