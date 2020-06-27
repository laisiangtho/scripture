import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'scrollExtension.dart';

class BottomBarItem {
  BottomBarItem({
    this.label,
    this.icon
  });
  final String label;
  final IconData icon;
}

class ScrollPageBottom extends StatefulWidget {

  final ScrollController controller;
  final Duration duration;
  final Widget child;
  final void Function(int) pageChange;

  ScrollPageBottom({
    this.controller,
    // this.pageNotify,
    this.pageChange,
    this.duration: const Duration(milliseconds: 400),
    this.child,
  });

  final List<BottomBarItem> items = [
    BottomBarItem(icon:Icons.flag, label:"Book"),
    BottomBarItem(icon:Icons.local_library, label:"Read"),
    BottomBarItem(icon:Icons.collections_bookmark, label:"Bookmark"),
    BottomBarItem(icon:CupertinoIcons.search, label:"Search"),
    // BottomBarItem(icon:Icons.more_horiz, label:"More")
  ];

  @override
  _BottomBarAnimatedState createState() => _BottomBarAnimatedState();
}

class _BottomBarAnimatedState extends State<ScrollPageBottom> with TickerProviderStateMixin {
  ScrollController get controller => widget.controller;
  Duration get animationDuration => widget.duration;
  double get height => controller.bottom.height;
  int milliseconds(double heightFactor) => [0.0, 1.0].contains(heightFactor)?200:0;

  // double _itemWidth;

  final List<BottomBarItem> items = [
    BottomBarItem(icon:Icons.flag, label:"Book"),
    BottomBarItem(icon:Icons.local_library, label:"Read"),
    BottomBarItem(icon:Icons.collections_bookmark, label:"Bookmark"),
    BottomBarItem(icon:CupertinoIcons.search, label:"Search"),
    // BottomBarItem(icon:Icons.more_horiz, label:"More")
  ];

  @override
  Widget build(BuildContext context) {
    // _itemWidth = MediaQuery.of(context).size.width/items.length;
    return ValueListenableBuilder<bool>(
      valueListenable: controller.master.bottom.toggleNotify,
      builder: (BuildContext context, bool hide,Widget child) => (hide)?SizedBox.shrink():_height()
    );
  }

  Widget _height() {
    return ValueListenableBuilder<double>(
      valueListenable: controller.master.bottom.heightNotify,
      builder: _animatedContainer,
      child: _page(),
    );
  }

  ValueListenableBuilder<int> _page(){
    return ValueListenableBuilder<int>(
      valueListenable: controller.master.bottom.pageNotify,
      builder: _item,
    );
  }

  Widget _item(BuildContext context, int value,Widget child){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items.asMap().map((index, item) => MapEntry(index, _button(index,item,value == index))).values.toList()
    );
  }

  Widget _animatedContainer(BuildContext context, double heightFactor,Widget child) {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: Duration(milliseconds:milliseconds(heightFactor)),
          // alignment: Alignment(0, heightFactor),
          bottom:(height*heightFactor)-height,
          child: Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 0.5),
            child: Container(
              // padding: EdgeInsets.only(bottom: paddingBottom),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 2))
              ),
              child: child
            )
          )
        )
      ],
    );



  }
  Widget _button(int index, BottomBarItem item, bool isButtomSelected) {
    return CupertinoButton(
      pressedOpacity: 0.5,
      // padding: EdgeInsets.zero,
      // padding: EdgeInsets.all(20),
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          color: isButtomSelected?Colors.grey.withOpacity(1):null,
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        duration: animationDuration,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, size:25,color: isButtomSelected? Colors.white:Colors.grey[500]),
            SizedBox(width:2),
            AnimatedSize(
              vsync: this,
              duration: animationDuration,
              curve: Curves.easeInOut,
              child: Container(
                // constraints: BoxConstraints(
                //   maxWidth: _itemWidth-5
                // ),
                child: Text(
                  isButtomSelected?item.label:'', overflow: TextOverflow.clip, maxLines: 1,
                  style: TextStyle(color: Colors.white,fontSize: 15)
                )
              )
            )
          ]
        )
        // child:Text(
        //   isButtomSelected?item.label:'', overflow: TextOverflow.clip, maxLines: 1,
        //   style: TextStyle(color: Colors.white,fontSize: 15)
        // )
      ),
      // onPressed: () => store.pageController.jumpToPage(index)
      onPressed: () => controller.master.bottom.pageNotify.value != index? widget.pageChange(index):null
    );
  }
}