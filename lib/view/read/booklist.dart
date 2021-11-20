part of 'main.dart';

class PopBookList extends StatefulWidget {
  final RenderBox render;

  const PopBookList({
    Key? key,
    required this.render,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopBookListState();
}

class _PopBookListState extends State<PopBookList> with TickerProviderStateMixin {
  late final Core core = context.read<Core>();

  Scripture get scripture => core.scripturePrimary;
  // BIBLE get bible => scripture.cacheVerseChapter;
  // BOOK get book => bible.book.first;
  // CHAPTER get chapter => book.chapter.first;

  // List<DefinitionBook> get books => scripture.bookList;

  List<DefinitionBook> get books => scripture.bookList;

  Size get targetSize => widget.render.size;
  Offset get targetPosition => widget.render.localToGlobal(Offset.zero);

  // getBookList
  // List<DefinitionBook> get getBookList => Core.instance.getBookList;
  // @override
  // bool get wantKeepAlive => true;

  final List<int> expandedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double halfWidth = (MediaQuery.of(context).size.width/2) - 50;
    // double halfWidth = MediaQuery.of(context).size.width - 10;
    return WidgetPopup(
      right: 20,
      left: 20,
      height: MediaQuery.of(context).size.height,
      top: targetPosition.dy + targetSize.height + 1,
      arrow: targetPosition.dx + (targetSize.width / 2) - 25,
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
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        separatorBuilder: (BuildContext _, int index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 0,
            ),
          );
        },
        itemBuilder: (BuildContext _, int index) {
          return bookItem(index, books.elementAt(index));
        },
        itemCount: books.length,
      ),
    );
    // return ListView.separated(
    //   // shrinkWrap: true,
    //   padding: const EdgeInsets.all(0),
    //   physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

    //   separatorBuilder: (BuildContext _, int index) {
    //     return const Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 15),
    //       child: Divider(
    //         height: 0,
    //       ),
    //     );
    //   },
    //   itemBuilder: (BuildContext _, int index) {
    //     return bookItem(index, books[index]);
    //   },
    //   itemCount: books.length,
    // );
  }

  Widget bookItem(int index, DefinitionBook book) {
    bool isCurrentBook = core.collection.bookId == book.id;
    // int bookId = index+1;
    bool isExpanded = expandedList.where((e) => e == index).isNotEmpty;
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: isExpanded ? 500 : 200),
      // dividerColor: Colors.red,
      elevation: 0,
      // expandedHeaderPadding: EdgeInsets.zero,
      expandedHeaderPadding: const EdgeInsets.all(3),
      children: [
        ExpansionPanel(
          body: chapterList(isExpanded, book),
          backgroundColor: isCurrentBook ? Theme.of(context).disabledColor : Colors.transparent,
          // backgroundColor: Colors.red,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return CupertinoButton(
              // color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                book.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: TextStyle(
                  color: isCurrentBook ? Theme.of(context).highlightColor : null,
                ),
              ),
              onPressed: () {
                Navigator.pop<Map<String?, int?>>(context, {'book': book.id});
              },
            );
          },
          isExpanded: isExpanded,
        )
      ],
      expansionCallback: (int item, bool status) {
        // final abc = expandedList.where((e) => e == index).length;
        if (status) {
          expandedList.remove(index);
        } else {
          expandedList.add(index);
        }
        setState(() {
          // itemData[index].expanded = !itemData[index].expanded;
        });
      },
    );
  }

  Widget chapterList(bool isExpanded, DefinitionBook book) {
    if (!isExpanded) return const SizedBox();
    // List<Widget> abc = isExpanded == false
    //     ? []
    //     : List<Widget>.generate(book.entries.first.value, (index) => chapterButton(1, index + 1));

    return LayoutBuilder(
      builder: (_, constraints) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 2.0,
          runSpacing: 2.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          // textDirection: TextDirection.ltr,
          children: List<Widget>.generate(
            book.chapterCount,
            (index) => chapterButton(book.id, index + 1),
          ),
        );
      },
    );
  }

  Widget chapterButton(int bookId, int chapterId) {
    // bool isCurrentChapter = 2 == index;
    bool isCurrentChapter = core.collection.chapterId == chapterId;
    return CupertinoButton(
      minSize: 55,
      borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      padding: const EdgeInsets.all(5),
      child: Text(
        scripture.digit(chapterId),
        style: TextStyle(
          color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        ),
      ),
      onPressed: () {
        Navigator.pop<Map<String?, int?>>(context, {'book': bookId, 'chapter': chapterId});
      },
    );
  }
}
