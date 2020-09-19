// import 'package:bible/component.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

part of 'main.dart';

mixin _Bar on _State {
  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:false,
      delegate: new ScrollPageBarDelegate(Navigator.canPop(context)?_barPopup:_barPage,maxHeight: widget.barMaxHeight)
      // delegate: new ScrollPageBarDelegate(_barPopup,maxHeight: widget.barMaxHeight)
    );
  }

  Widget _barPopup(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(-.95,0),
          child: CupertinoButton(
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Icon(
                  // Icons.arrow_back_ios,
                  CustomIcon.left_open_big,
                  // size: 27,
                ),
                Text(widget.title??'Back')
              ],
            )
          ),
        ),
        // if (widget.title != null)Align(
        //   // alignment: Alignment.lerp(Alignment(-0.2,0.5),Alignment(-0.5,-.4), stretch),
        //   alignment: Alignment(-.6,0),
        //   child: _barTitle(shrink)
        // ),
        Align(
          alignment: Alignment(.95,0),
          child: _barSortButton(),
        ),
      ]
    );
  }


  Widget _barPage(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    // double stretch = percentage;
    // double shrink = percentage;
    return Stack(
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
          alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,-.1), stretch),
          // alignment: Alignment(-.9,0),
          child: _barTitle(shrink)
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        //     _barSortButton()
        //   ]
        // ),
        Align(
          alignment: Alignment(.95,-1),
          child: _barSortButton(),
        ),
      ]
    );
  }

  Widget _barSortButton(){
    return Tooltip(
      message: 'Sort available Bible list',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(vertical:10,horizontal:10),
        // color: Colors.blue,
        child: new Icon(
          // Icons.sort,
          CustomIcon.swatchbook,
          color: this.isSorting?Colors.red:null,
          size: 20,
        ),
        onPressed: setSorting
      ),
    );
  }

  Widget _barTitle(double shrink){
    return Text(
      widget.title??core.appName,
      semanticsLabel: widget.title??core.appName,
      style: TextStyle(
        fontFamily: "sans-serif",
        // color: Color.lerp(Colors.white, Colors.white24, stretch),
        // color: Colors.black,
        fontWeight: FontWeight.w200,
        // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
        // fontSize:35 - (16*stretch),
        fontSize:(35*shrink).clamp(25.0, 35.0),
        // shadows: <Shadow>[
        //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
        // ]
      )
    );
  }
  // void markNeedsBuild() => (context as Element).markNeedsBuild();
}
