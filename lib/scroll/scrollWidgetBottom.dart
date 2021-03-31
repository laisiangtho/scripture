part of 'root.dart';

class ModelPage {
  ModelPage({
    this.name,
    this.icon,
    this.screenName,
    this.description,
    this.key,
    this.child,
  });

  final String screenName;
  final String description;
  final GlobalKey<State<dynamic>> key;
  final Widget child;
  final String name;
  final IconData icon;
}

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
  double heightCurrent(heightFactor) => (height*heightFactor).toDouble();
  // double heightCurrent(heightFactor) => (height*heightFactor).toDouble().clamp(5.0, height);
  int milliseconds(double heightFactor) => [0.0, 1.0].contains(heightFactor)?200:0;
  List<ModelPage> get items => widget.items;

  // double itemWidthMax;

  @override
  Widget build(BuildContext context) {
    // itemWidthMax = MediaQuery.of(context).size.width/items.length;
    return ValueListenableBuilder<bool>(
      valueListenable: controller.master.bottom.toggleNotify,
      // builder: (BuildContext context, bool hide,Widget child) => (hide)?Container():_height()
      // builder: (BuildContext context, bool hide,Widget child) => (hide)?SizedBox.shrink():_height()
      // builder: (BuildContext context, bool hide,Widget child) => (hide)?Container(height: 0,color:Colors.brown):_height()
      builder: (BuildContext context, bool hide,Widget child) => (hide)?Container(height: 0,color:Colors.brown):_height()
    );
    // return _height();
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items.asMap().map((index, item) => MapEntry(index, _button(index,item,value == index))).values.toList()
    );
  }

  Widget _animatedContainer(BuildContext context, double heightFactor,Widget children) {
    // return Align(
    //   heightFactor: 1.0,
    //   child: Stack(
    //     // alignment: Alignment(1.0, -1.0),
    //     // fit: StackFit.loose,
    //     children: <Widget>[
    //       Text('abc')
    //     ],
    //   ),
    // );
    // return Stack(
    //   // alignment: Alignment(1.0, -1.0),
    //   // fit: StackFit.loose,
    //   children: <Widget>[
    //     AnimatedPositioned(
    //       duration: Duration(milliseconds:milliseconds(heightFactor)),
    //       alignment: Alignment(0, heightFactor),
    //       // bottom:0,
    //       // left: 0,
    //       // height: 50,
    //       // width: 100,
    //       child: Text('abc')
    //     )
    //   ],
    // );
    return AnimatedContainer(
      duration: Duration(milliseconds:milliseconds(heightFactor)),
      height: heightCurrent(heightFactor),
      // width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.symmetric(vertical: 2),
      // padding: EdgeInsets.symmetric(vertical: 10),
      // alignment: Alignment.bottomCenter,
      // height: height,
      // color: Colors.red,
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
              color: Theme.of(context).backgroundColor,
              // color: Colors.black38,
              spreadRadius: 0.7,
              offset: Offset(-0.1, -0.5),
            )
          ]
        ),
        child: children
      )
    );
    /*
    return Stack(
      // alignment: Alignment(1.0, -1.0),
      // fit: StackFit.loose,
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
              child: children
            )
          )
        )
      ],
    );
    */
    /*
    return Align(
      heightFactor: heightFactor,
      alignment: Alignment(0.0, -.87),
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
        child: children
      )
    );
    */
  }

  Widget _button(int index, ModelPage item, bool isButtomSelected) {
    // return Text('a');
    return Tooltip(
      message: item.description,
      // child: CupertinoButton(
      //   child: Text('a'),
      //   onPressed: () => isButtomSelected?null: widget.pageClick(index)
      // )
      child: CupertinoButton(
        // color: Colors.red,
        // splashColor: Colors.transparent,
        // padding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal:5,vertical:2),
        // highlightColor: Colors.transparent,
        // shape: RoundedRectangleBorder(
        //   borderRadius: new BorderRadius.circular(20.0),
        //   // side: BorderSide(color: Colors.grey)
        // ),
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal:0,vertical:10),
          child: Icon(
            item.icon,
            size:isButtomSelected?25:27,
            // color: isButtomSelected?null:Colors.grey
          )
        ),
        // onPressed: () => core.pageController.jumpToPage(index)
        onPressed: isButtomSelected?null:()=>widget.pageClick(index)
        // onPressed: null,
      ),
    );
  }

  // Widget _button_(int index, ModelPage item, bool isButtomSelected) {
  //   return Tooltip(
  //     message: item.description,
  //     child: CupertinoButton(
  //       pressedOpacity: 0.5,
  //       // minSize: 0.4,
  //       // padding: EdgeInsets.zero,
  //       color: Colors.red,
  //       // color: isButtomSelected?Colors.red:null,
  //       // padding: EdgeInsets.symmetric(vertical: 10,horizontal:0),
  //       // borderRadius: BorderRadius.all(Radius.circular(50)),
  //       // padding: EdgeInsets.symmetric(vertical: 5,horizontal:5),
  //       // borderRadius: BorderRadius.all(Radius.circular(10)),
  //       // padding: EdgeInsets.all(20),
  //       child: AnimatedContainer(
  //         // padding: EdgeInsets.symmetric(vertical: 7,horizontal: 8),
  //         // margin: EdgeInsets.symmetric(vertical: 0,horizontal: 1),
  //         decoration: BoxDecoration(
  //           // color: isButtomSelected?Colors.grey.withOpacity(1):null,
  //           color: isButtomSelected?Colors.grey[300]:null,
  //           borderRadius: BorderRadius.all(Radius.circular(7))
  //         ),
  //         duration: animationDuration,
  //         child: Icon(
  //           item.icon,
  //           size:30,
  //           color: isButtomSelected? Colors.black45:Colors.grey
  //         ),
  //         // child: Row(
  //         //   mainAxisSize: MainAxisSize.min,
  //         //   crossAxisAlignment: CrossAxisAlignment.center,
  //         //   mainAxisAlignment: MainAxisAlignment.center,
  //         //   children: <Widget>[
  //         //     // Icon(item.icon, size:28,color: isButtomSelected? Colors.white:Colors.grey[500]),
  //         //     Icon(
  //         //       item.icon,
  //         //       size:isButtomSelected?25:30,
  //         //       color: isButtomSelected? Colors.white:Colors.grey
  //         //     ),
  //         //     SizedBox(width:5),
  //         //     AnimatedSize(
  //         //       vsync: this,
  //         //       duration: animationDuration,
  //         //       curve: Curves.easeInOut,
  //         //       child: Container(
  //         //         constraints: BoxConstraints(
  //         //           maxWidth: itemWidthMax-2
  //         //         ),
  //         //         child: Text(
  //         //           isButtomSelected?item.name:'', overflow: TextOverflow.clip, maxLines: 1,
  //         //           semanticsLabel: item.name,
  //         //           style: TextStyle(color: Colors.white,fontSize: 15)
  //         //         )
  //         //       )
  //         //     )
  //         //   ]
  //         // )
  //       ),
  //       // onPressed: () => store.pageController.jumpToPage(index)
  //       onPressed: () => controller.master.bottom.pageNotify.value != index? widget.pageClick(index):null
  //     ),
  //   );
  // }
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