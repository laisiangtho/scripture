part of 'main.dart';

class PopChapterList extends StatefulWidget {
  final RenderBox render;

  const PopChapterList({
    Key? key,
    required this.render,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopChapterListState();
}

class _PopChapterListState extends State<PopChapterList> with TickerProviderStateMixin {
  late Core core;

  Scripture get scripture => core.scripturePrimary;
  // BIBLE get bible => scripture.verseChapter;
  // BOOK get book => bible.book.first;
  // CHAPTER get chapter => book.chapter.first;

  Size get targetSize => widget.render.size;
  Offset get targetPosition => widget.render.localToGlobal(Offset.zero);

  int get chapterCount => scripture.chapterCount;
  // int get chapterCount => book.info.chapterCount;
  int get perItem => chapterCount > 4 ? 4 : chapterCount;
  // double get height => (chapterCount < 4)?(250 / chapterCount).toDouble():(chapterCount/perItem).ceilToDouble()*62;
  double get height => (chapterCount < 4)
      ? (250 / chapterCount).toDouble()
      : (chapterCount / perItem).ceilToDouble() * 60;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    double halfWidth = (MediaQuery.of(context).size.width / 2) - 50;
    return WidgetPopup(
      left: halfWidth,
      right: 10,
      height: height,
      top: targetPosition.dy + targetSize.height + 1,
      arrow: targetPosition.dx - halfWidth + (targetSize.width / 2) - 7,
      backgroundColor: Theme.of(context).backgroundColor,
      child: view(),
    );
  }

  Widget view() {
    return GridTile(
      header: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      footer: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      // footer: Text('...'),
      child: GridView.count(
        padding: const EdgeInsets.all(3),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1,
        crossAxisCount: perItem,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: List<Widget>.generate(
          chapterCount,
          (index) => chapterButton(index + 1),
        ),
      ),
    );
  }

  Widget chapterButton(int index) {
    // bool isCurrentChapter = false;
    bool isCurrentChapter = core.collection.chapterId == index;
    // bool isCurrentChapter = chapter.id == index;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CupertinoButton(
        minSize: 55,
        // borderRadius: BorderRadius.all(Radius.circular(2.0)),
        padding: EdgeInsets.zero,
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          scripture.digit(index),
          style: TextStyle(
            color: isCurrentChapter ? Theme.of(context).highlightColor : null,
          ),
        ),
        onPressed: () => Navigator.pop<int>(context, index),
      ),
    );
  }
}
