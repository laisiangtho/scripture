import 'package:flutter/material.dart';

import 'Popup.dart';
import 'Store.dart';
// import 'StoreModel.dart';

class PopupChapter extends StatefulWidget {
  PopupChapter(
    {
      Key key,
      this.shrinkOffset,
      this.chapterCount,
    }
  ) : super(key: key);
  final double shrinkOffset;
  final int chapterCount;

  @override
  State<StatefulWidget> createState() => _Chapter();
}

class _Chapter extends State<PopupChapter> {
  int items;
  int perItem;
  double height;

  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();
    items = widget.chapterCount;
    perItem = items > 4?4:items;
    height =(items/perItem).ceilToDouble()*45;
  }

  @override
  Widget build(BuildContext context) {
    double halfWidth = (MediaQuery.of(context).size.width/2) - 20;
    return Popup(
      offsetPersentage: widget.shrinkOffset,
      height: height,
      left: halfWidth,
      top:  20*widget.shrinkOffset+43,
      arrow:  13*widget.shrinkOffset+15,
      child: view()
    );
  }
  GridView view () {
    return new GridView.count(
      // padding: EdgeInsets.zero,
      mainAxisSpacing: 1,
      crossAxisSpacing:1,
      childAspectRatio: 1,
      shrinkWrap: true,
      crossAxisCount: perItem,
      children: new List<Widget>.generate(items, (index) {
        ++index;
        bool isCurrentChapter = store.chapterId == index;
        return InkWell(
          child: Container(
            // padding: EdgeInsets.symmetric(vertical:20),
            child: Text(store.digit(index),
              textAlign: TextAlign.center,
              textScaleFactor: 0.9,
              style: TextStyle(
                color: isCurrentChapter?Colors.white30:Colors.white,
                height: 0.55
              )
            )
          ),
          onTap: () => Navigator.pop<int>(context, index)
        );
      })
    );
  }
}


  // void chaptersPopup (double shrinkOffset) {
  //   int _rowItems = store.chapterCount;
  //   int _perItem = _rowItems > 4?4:_rowItems;
  //   double _rowHeight =(_rowItems/_perItem).ceilToDouble()*45;
  //   Navigator.of(context).push(PageRouteBuilder(
  //     opaque: false,
  //     barrierDismissible: true,
  //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  //       return new SlideTransition(
  //           position: new Tween<Offset>(
  //             begin: const Offset(0.0, 0.7),
  //             end: Offset.zero,
  //           ).animate(animation),
  //           child: child
  //         );
  //       },
  //     pageBuilder: (BuildContext context, x, y) => Popup(
  //       offsetPersentage: shrinkOffset,
  //       height: _rowHeight,
  //       top:  45+(87-45)*shrinkOffset,
  //       // arrow:  96-(96-65)*shrinkOffset,
  //       arrow:  80-(80-50)*shrinkOffset,
  //       child: chaptersGirdView(_perItem, _rowItems)
  //     )
  //   ));
  // }
  // GridView chaptersGirdView (int _perItem, int _rowItems) {
  //   return new GridView.count(
  //     padding: EdgeInsets.all(0),
  //     mainAxisSpacing: 1,
  //     crossAxisSpacing:1,
  //     childAspectRatio: 1,
  //     shrinkWrap: true,
  //     crossAxisCount: _perItem,
  //     children: new List<Widget>.generate(_rowItems, (index) {
  //       ++index;
  //       bool isCurrentChapter = store.chapterId == index;
  //       return InkWell(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical:14),
  //           child: Text('$index',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: isCurrentChapter?Colors.white30:Colors.white,
  //             )
  //           )
  //         ),
  //         onTap: () => setChapter(index)
  //       );
  //     })
  //   );
  // }