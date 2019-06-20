import 'package:flutter/material.dart';

import 'Popup.dart';
import 'Store.dart';
// import 'StoreModel.dart';

class PopupChapter extends StatefulWidget {
  PopupChapter(
    {
      Key key,
      this.mainContext,
      this.chapterCount,
    }
  ) : super(key: key);
  final RenderBox mainContext;
  final int chapterCount;

  @override
  State<StatefulWidget> createState() => _Chapter();
}

class _Chapter extends State<PopupChapter> {
  int items;
  int perItem;
  double height;

  Size targetSize;
  Offset targetPosition;

  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();
    items = widget.chapterCount;
    perItem = items > 4?4:items;
    height =(items < 4)?(250 / items).toDouble():(items/perItem).ceilToDouble()*62;

    targetSize = widget.mainContext.size;
    targetPosition = widget.mainContext.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    // double paddingTop = MediaQuery.of(context).padding.top;
    double halfWidth = (MediaQuery.of(context).size.width/2) - 50;

    return Popup(
      left:halfWidth,
      right: 10,
      height: height,
      top: targetPosition.dy + targetSize.height + 7,
      arrow:  targetPosition.dx - halfWidth + (targetSize.width/2)-7,
      child: view()
    );
  }
  GridView view () {
    return new GridView.count(
      padding: EdgeInsets.zero,
      mainAxisSpacing:0,
      crossAxisSpacing:0,
      childAspectRatio: 1,
      crossAxisCount: perItem,
      children: new List<Widget>.generate(items, (index) {
        ++index;
        bool isCurrentChapter = store.chapterId == index;
        return InkWell(
          child: Center(
            child: Text(store.digit(index),
              style: TextStyle(
                color: isCurrentChapter?Colors.white30:Colors.white, fontSize: 19
              )
            )
          ),
          onTap: () => Navigator.pop<int>(context, index)
        );
      })
    );
  }
}