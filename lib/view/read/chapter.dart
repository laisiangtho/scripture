part of 'main.dart';

class PopChapterList extends StatefulWidget {
  final RenderBox mainContext;
  // final int chapterCount;
  final BIBLE bible;

  PopChapterList(
    {
      Key key,
      this.mainContext,
      this.bible,
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopChapterListState();
}

class _PopChapterListState extends State<PopChapterList> {

  BIBLE get bible => widget.bible;
  // DefinitionBook get book => bible.book.first.info;
  BOOK get book => bible.book.first;
  CHAPTER get chapter => book.chapter.first;
  int get items => book.info.chapterCount;
  int get perItem => items > 4?4:items;
  double get height => (items < 4)?(250 / items).toDouble():(items/perItem).ceilToDouble()*62;

  Size get targetSize => widget.mainContext.size;
  Offset get targetPosition => widget.mainContext.localToGlobal(Offset.zero);

  @override
  Widget build(BuildContext context) {
    double halfWidth = (MediaQuery.of(context).size.width/2) - 50;

    return WidgetPopup(
      left:halfWidth,
      right: 10,
      height: height,
      top: targetPosition.dy + targetSize.height + 7,
      arrow: targetPosition.dx - halfWidth + (targetSize.width/2)-7,
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
        bool isCurrentChapter = chapter.id == index;
        return InkWell(
          child: Center(
            child: Text(Core.instance.digit(index),
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
