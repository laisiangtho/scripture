import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'scrollExtension.dart';

class ModelPage {
  ModelPage({
    this.name,
    this.icon,
    this.screenName,
    this.screenClass,
    this.key,
    this.child,
  });
  final String screenName;
  final String screenClass;
  final GlobalKey<State<dynamic>> key;
  final Widget child;
  final String name;
  final IconData icon;
}
// core.analyticsScreen('home','HomeState');

class ScrollPageBottom extends StatefulWidget {

  final ScrollController controller;
  final void Function(int) pageClick;
  final List<ModelPage> items;
  final Duration duration;
  final Widget child;

  ScrollPageBottom({
    this.controller,
    this.items,
    this.pageClick,
    this.duration: const Duration(milliseconds: 400),
    this.child,
  });

  // final List<ModelPage> items = [
  //   ModelPage(icon:Icons.flag, name:"Book"),
  //   ModelPage(icon:Icons.local_library, name:"Read"),
  //   // BottomBarItem(icon:Icons.collections_bookmark, name:"Bookmark"),
  //   ModelPage(icon:Icons.book, name:"Bookmark"),
  //   ModelPage(icon:CupertinoIcons.search, name:"Search"),
  //   ModelPage(icon:Icons.more_horiz, name:"More")
  // ];

  @override
  _BottomBarAnimatedState createState() => _BottomBarAnimatedState();
}

class _BottomBarAnimatedState extends State<ScrollPageBottom> with TickerProviderStateMixin {
  ScrollController get controller => widget.controller;
  Duration get animationDuration => widget.duration;
  double get height => controller.bottom.height;
  int milliseconds(double heightFactor) => [0.0, 1.0].contains(heightFactor)?200:0;
  List<ModelPage> get items => widget.items;

  double itemWidthMax;

  @override
  Widget build(BuildContext context) {
    itemWidthMax = MediaQuery.of(context).size.width/items.length;
    return ValueListenableBuilder<bool>(
      valueListenable: controller.master.bottom.toggleNotify,
      builder: (BuildContext context, bool hide,Widget child) => (hide)?Container():_height()
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
    // return Stack(
    //   alignment: Alignment(1.0, -1.0),
    //   fit: StackFit.loose,
    //   children: <Widget>[
    //     AnimatedPositioned(
    //       duration: Duration(milliseconds:milliseconds(heightFactor)),
    //       // alignment: Alignment(0, heightFactor),
    //       bottom:(height*heightFactor)-height,
    //       child: Container(
    //         decoration: new BoxDecoration(
    //           color: Theme.of(context).backgroundColor,
    //           borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
    //         ),
    //         width: MediaQuery.of(context).size.width,
    //         padding: EdgeInsets.only(top: 0.5),
    //         child: Container(
    //           // padding: EdgeInsets.only(bottom: paddingBottom),
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).primaryColor,
    //             borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 2))
    //           ),
    //           child: child
    //         )
    //       )
    //     )
    //   ],
    // );
    return Align(
      heightFactor: heightFactor,
      alignment: Alignment(0.0, -1.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(
            top: Radius.elliptical(3, 2),
            // bottom: Radius.elliptical(3, 2)
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 0.0,
              // color: Theme.of(context).backgroundColor,
              color: Colors.black38,
              spreadRadius: 0.0,
              offset: Offset(0.0, .0),
            )
          ]
        ),
        child: child
      )
    );
  }

  Widget _button(int index, ModelPage item, bool isButtomSelected) {
    return CupertinoButton(
      pressedOpacity: 0.5,
      // padding: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 13,horizontal: 10),
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
                constraints: BoxConstraints(
                  maxWidth: itemWidthMax-5
                ),
                child: Text(
                  isButtomSelected?item.name:'', overflow: TextOverflow.clip, maxLines: 1,
                  style: TextStyle(color: Colors.white,fontSize: 13)
                )
              )
            )
          ]
        )
      ),
      // onPressed: () => store.pageController.jumpToPage(index)
      onPressed: () => controller.master.bottom.pageNotify.value != index? widget.pageClick(index):null
    );
  }
}
/*
ClipRRect(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  )
  child:null
)
*/
/*
class CornerRadiusClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, 0);
    path.lineTo(20, 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
class _Clipper extends CustomClipper<Path> {
  final double radius;

  _Clipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = new Path();
    final rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    path.addRRect(new RRect.fromRectAndRadius(rect, new Radius.circular(radius)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
*/