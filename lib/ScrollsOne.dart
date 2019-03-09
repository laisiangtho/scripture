import 'package:flutter/material.dart';

class CustomScrollOne extends StatefulWidget {
  @override
  CustomScrollOneState createState() => new CustomScrollOneState();
}

class CustomScrollOneState extends State<CustomScrollOne> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  AnimationController animationController;
  Animation<Color> colorAnimation;
  Animation<double> doubleAnimation;

  double scrollOffset = 0.0;
  double scrollOffsetLast = 0.0;
  double upperSize = 50.0;

  @override
  initState() {
    scrollController = new ScrollController();
    scrollController.addListener(updateOffset);
    super.initState();

    animationController = new AnimationController(
      duration: const Duration(milliseconds:100),
      vsync: this,
    );
    colorAnimation = new ColorTween(
      begin: const Color.fromRGBO(10, 10, 10, 0.5),
      end: const Color.fromRGBO(0, 200, 100, 0.5),
    ).animate(animationController)
    ..addListener(() {
      setState((){});
    });
    doubleAnimation = new Tween<double>(
      begin: 20.0,
      end: 50.0,
    ).animate(animationController)..addListener(() {
      setState((){});
    });

  }

  @override
  dispose() {
    scrollController.removeListener(updateOffset);
    scrollController.dispose();
    super.dispose();
  }

  void updateOffset() {
    setState(() {
      scrollOffset = scrollController.offset;
    });
  }
  bool scrollDirectionDown = true;
  scrollNotificationListener(ScrollNotification scrollNotification) {
    // NOTE scrollNotification is ScrollStartNotification
    if (scrollNotification is ScrollUpdateNotification) {
      double minTop = 20.0;
      double maxTop = 50.0;
      double activePosition =  scrollOffsetLast + upperSize - scrollOffset;
      // upperSize = (activePosition * 0.5).clamp(minTop, maxTop);

      if (scrollNotification.scrollDelta < 0) {
        // NOTE forward to normal
        if (colorAnimation.isDismissed)animationController.forward();
        if (upperSize < maxTop) {
          // activePosition = scrollOffsetLast + upperSize - scrollOffset;
          // activePosition = scrollOffsetLast + minTop - scrollOffset;
          upperSize = (activePosition * 0.5).clamp(upperSize, maxTop);
        }
      } else if (scrollNotification.scrollDelta > 0) {
        // NOTE reverse to large
        if (colorAnimation.isCompleted)animationController.reverse();
        if (upperSize > minTop){
          // activePosition = scrollOffsetLast + upperSize - scrollOffset ;
          // activePosition = scrollOffsetLast + maxTop - scrollOffset ;
          upperSize = (activePosition).clamp(minTop, upperSize);
        }
      }
    } else if (scrollNotification is ScrollEndNotification) {
      scrollOffsetLast = scrollController.offset;
      // print(animationController.status);

      // if (colorAnimation.isDismissed && (upperSize < 50.0) ) {
      //   upperSize = 20.0;
      // } else if (colorAnimation.isCompleted && (upperSize > 20.0)){
      //   upperSize = 50.0;
      // }
      upperSize = doubleAnimation.value;
      updateOffset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: upperSize,
              left: 14,
              right:14,
              bottom: 50,
              child: Container(
                decoration: new BoxDecoration(
                  color: colorAnimation.value,
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                padding: EdgeInsets.all(15),
                // color: Colors.grey[200],
                child: NotificationListener<ScrollNotification>(
                  onNotification: (e)=>scrollNotificationListener(e),
                  child: _listView(),
                )
              ),
            ),
            Positioned(
              top: 0,
              left: 50,
              right: 50,
              child: Container(
                width: 300,
                height: upperSize,
                color: Colors.grey[100],
                child: Text(upperSize.toString()),
              ),
            ),
            Positioned(
              top: 0,
              left: 1,
              bottom: 0,
              child: Container(
                width: 10,
                height: upperSize,
                color: Colors.red

              ),
            )
          ],
        ),
      )
    );
  }

  Widget _listView() {
    return new ListView.builder(
      itemCount: 60,
      itemBuilder: _listViewItem,
      controller: scrollController
    );
  }
  Widget _listViewItem(BuildContext context, int index) {
    return new Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        // border: Border.all(width:0.2,color: Colors.grey)
      ),
      child: new Text('Item $index')
    );
  }
}

/*
Can somebody help me achievie
*/