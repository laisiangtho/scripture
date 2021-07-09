part of 'main.dart';

class PopBookList extends StatefulWidget {
  final RenderBox render;

  PopBookList({
    Key? key,
    required this.render,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopBookListState();
}

class _PopBookListState extends State<PopBookList> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  late Core core;

  Scripture get scripture => core.scripturePrimary;
  // BIBLE get bible => scripture.cacheVerseChapter;
  // BOOK get book => bible.book.first;
  // CHAPTER get chapter => book.chapter.first;

  List<DefinitionBook> get books => scripture.bookList;

  Size get targetSize => widget.render.size;
  Offset get targetPosition => widget.render.localToGlobal(Offset.zero);

  // getBookList
  // List<DefinitionBook> get getBookList => Core.instance.getBookList;
  // @override
  // bool get wantKeepAlive => true;

  final List<int> expandedList=[];


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  // void close() {
  //   // core.chapterChange();
  //   // Navigator.pop<int>(context, index);
  //   final abc = {
  //     0:1
  //   };
  //   abc[0];
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // double halfWidth = (MediaQuery.of(context).size.width/2) - 50;
    // double halfWidth = MediaQuery.of(context).size.width - 10;
    return WidgetPopup(
      right:20,
      left: 20,
      height: MediaQuery.of(context).size.height,
      top: targetPosition.dy + targetSize.height + 7,
      arrow: targetPosition.dx + (targetSize.width/2)-25,
      child: view(),
    );
  }

  Widget view() {
    // return CustomScrollView(
    //   physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    //   slivers: <Widget>[
    //     new SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (BuildContext context, int index){
    //           return DecoratedBox(
    //             decoration: BoxDecoration(
    //               // color: Theme.of(context).scaffoldBackgroundColor,
    //               color: Theme.of(context).primaryColor,
    //               border: Border(
    //                 top: BorderSide(
    //                   color: Theme.of(context).backgroundColor.withOpacity(index==0?0.0:0.2),
    //                   width: 0.5,
    //                 ),
    //               ),
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 0.2),
    //               child: bookItem(index,books[index]),
    //             ),
    //           );
    //         },
    //         childCount: books.length,
    //         // addAutomaticKeepAlives: true
    //       ),
    //     )
    //   ]
    // );
    return ListView.builder(
      // shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemBuilder: (BuildContext a, int index){
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).backgroundColor.withOpacity(index==0?0.0:0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.2),
            child: bookItem(index,books[index]),
          ),
        );
      },
      itemCount: books.length,
    );
  }

  Widget bookItem(int index, DefinitionBook book){
    // bool isCurrentBook = core.collection.bookId == book.id;
    // int bookId = index+1;

    bool isExpanded = expandedList.where((e) => e == index).length > 0;
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: isExpanded?700:200),
      // dividerColor: Colors.red,
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: chapterList(isExpanded, book)
          ),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return CupertinoButton(
              // color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                book.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
              onPressed: () {
                Navigator.pop<Map<String?, int?>>(context, {'book':book.id});
                // core.chapterChange(bookId: book.id);
                // debugPrint('bookid ${book.id}');
              }
            );

            // return Container(
            //   padding: EdgeInsets.only(left: 20),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'itemData[index].headerItem',
            //     // style: TextStyle(
            //     //   color: itemData[index].colorsItem,
            //     //   fontSize: 18,
            //     // ),
            //   ),
            // );
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
    // return AnimatedOpacity(
    //   opacity: isExpanded? 1.0 : 0.0,
    //   duration: const Duration(milliseconds: 300),
    //   child: new Wrap(
    //     alignment: WrapAlignment.center,
    //     spacing:2.0,
    //     runSpacing: 2.0,
    //     crossAxisAlignment: WrapCrossAlignment.center,
    //     // textDirection: TextDirection.ltr,
    //     children: new List<Widget>.generate(items, (index) => chapterButton(index+1))
    //   )
    // );

    if (isExpanded == false) return Container();
    List<Widget> abc = isExpanded == false?[]:new List<Widget>.generate(book.chapterCount, (index) => chapterButton(book.id, index+1));

    return new Wrap(
      alignment: WrapAlignment.center,
      spacing:2.0,
      runSpacing: 2.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      // textDirection: TextDirection.ltr,
      children: abc
    );
  }

  Widget chapterButton(int bookId, int chapterId){
    // bool isCurrentChapter = 2 == index;
    return CupertinoButton(
      minSize: 55,
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
      padding: EdgeInsets.all(5),
      // color: Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        scripture.digit(chapterId),
        style: TextStyle(
          // color: isCurrentChapter?Colors.white30:Colors.white, fontSize: 19
        )
      ),
      onPressed: () {
        // Navigator.pop<int>(context, index);
        // core.chapterChange(bookId: bookId, chapterId: chapterId);
        Navigator.pop<Map<String?, int?>>(context, {'book':bookId,'chapter':chapterId});
      }
    );
  }
}