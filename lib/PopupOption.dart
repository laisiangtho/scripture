import 'package:flutter/material.dart';

import 'Popup.dart';
import 'Store.dart';
// import 'StoreModel.dart';

class PopupOption extends StatefulWidget {
  PopupOption(
    {
      Key key,
      this.shrinkOffset,
    }
  ) : super(key: key);
  final double shrinkOffset;

  @override
  State<StatefulWidget> createState() => _Option();
}

class _Option extends State<PopupOption> {
  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Popup(
      offsetPersentage: widget.shrinkOffset,
      height: 150,
      right: 2,
      // right: null,
      top:  20*widget.shrinkOffset+43,
      arrow: 7*widget.shrinkOffset+155,
      child: view()
    );
  }
  Container view () {
    return new Container(
      child: Center(
        child: Text('Option'),
      )
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