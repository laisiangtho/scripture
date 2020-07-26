// import 'package:bible/component.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

part of 'main.dart';

mixin _Bar on _State {
  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:false,
      delegate: new ScrollPageBarDelegate(_bar,maxHeight: 120)
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    // double stretch = percentage;
    // double shrink = percentage;
    return Stack(
      children: <Widget>[
        // Align(
        //   alignment: Alignment.lerp(Alignment(0.5,0),Alignment(-0.7,0), stretch),
        //   child:Transform.rotate(
        //     angle:6*shrink,
        //     child: Container(
        //       child: Text('1.0.1'),
        //       padding: EdgeInsets.all(2),
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).backgroundColor,
        //         borderRadius: new BorderRadius.all(Radius.circular(3))
        //       )
        //     )
        //   )
        // ),
        Align(
          // alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,0), stretch),
          alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,0), stretch),
          child: Container(
            child: Text(
              core.appName,
              // 'the holy Bible'.toUpperCase(),
              style: TextStyle(
                fontFamily: "sans-serif",
                // color: Color.lerp(Colors.white, Colors.white24, stretch),
                color: Colors.black,
                fontWeight: FontWeight.w200,
                // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
                // fontSize:35 - (16*stretch),
                fontSize:(35*shrink).clamp(25.0, 35.0),
                // shadows: <Shadow>[
                //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
                // ]
              )
            )
          )
          // child: RichText(
          //   text: TextSpan(
          //     style: DefaultTextStyle.of(context).style.copyWith(
          //       fontFamily: "sans-serif",
          //       // fontSize:45 - (16*shrink).clamp(lowerLimit, upperLimit),
          //       fontSize:(45*shrink).clamp(16.0, 46.0),
          //       // fontSize:20,
          //       fontWeight: FontWeight.w100,color: Colors.black26,
          //       shadows: <Shadow>[
          //         Shadow(
          //           offset: Offset(0.0, 0.0),
          //           blurRadius: 1.0,
          //           color: Color.fromARGB(255, 0, 0, 0),
          //         ),
          //         Shadow(
          //           offset: Offset(0.0, 0.0),
          //           blurRadius: 2.0,
          //           // color: Color.fromARGB(2, 0, 0, 255),
          //         ),
          //       ],
          //     ),
          //     children: <TextSpan>[
          //       TextSpan(text: 'The ', style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20, color: Colors.black54)),
          //       TextSpan(text: 'HOLY ', style: TextStyle(fontWeight: FontWeight.w200,fontSize: 25, color: Colors.black54)),
          //       TextSpan(text: 'Bible', style: TextStyle(fontWeight: FontWeight.w300,color: Colors.black54)),
          //       TextSpan(text: "s", style: TextStyle(color: Colors.grey, )),
          //     ],
          //   ),
          // ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // CupertinoButton(
            //   // padding: EdgeInsets.zero,
            //   child: isUpdating?SizedBox(width:20, height:20,
            //     child:CircularProgressIndicator(strokeWidth: 1)
            //   ):new Icon(CupertinoIcons.refresh_circled,color: Colors.grey, size: 30),
            //   onPressed: updateCollectionCallBack
            // ),
            CupertinoButton(
              // padding: EdgeInsets.zero,
              child: new Icon(Icons.sort,color: this.isSorting?Colors.red:Colors.grey, size: 30),
              onPressed: setSorting
            ),
            // new DemoMenu()
          ]
        )
      ]
    );
  }
  // void markNeedsBuild() => (context as Element).markNeedsBuild();
}
