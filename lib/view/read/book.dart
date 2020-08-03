part of 'main.dart';

class PopBookList extends StatefulWidget {
  final RenderBox mainContext;
  // final void Function(int) setBook;

  PopBookList(
    {
      Key key,
      this.mainContext,
    }
  ) : super(key: key);

  @override
  _PopBookListState createState() => _PopBookListState();
}

class _PopBookListState extends State<PopBookList> {

  Size get targetSize => widget.mainContext.size;
  Offset get targetPosition => widget.mainContext.localToGlobal(Offset.zero);

  // getBookList
  // List<DefinitionBook> get getBookList => Core.instance.getBookList;

  @override
  Widget build(BuildContext context) {

    double halfWidth = (MediaQuery.of(context).size.width/2) - 50;
    return WidgetPopup(
      right:halfWidth,
      left: 10,
      height: MediaQuery.of(context).size.height,
      top: targetPosition.dy + targetSize.height + 7,
      arrow: targetPosition.dx + (targetSize.width/2)-15,
      child: view(Core.instance.getDefinitionBookList),
    );
  }
  ListView view(List<DefinitionBook> book){
    // book.id
    return ListView.builder(
      // separatorBuilder: (context, index) => Divider( color: Colors.white, height: 2),
      padding: EdgeInsets.zero,
      // shrinkWrap: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: book.length,
      itemBuilder: (BuildContext context, int index) {
        // NAME book = book.listName[index];
        // NAME book = book.listName;
        // book.listName.indexWhere((element) => false)
        // book.listName[index];

        // return (book.type)?header(book):item(book);
        return item(book[index]);
        // return Container();
      }
    );
  }

  // Widget header(DeleteBookTmp testament){
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal:5.0, vertical:10),
  //     // color: Colors.red,
  //     child: Text(
  //       testament.name,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 10,
  //         color: Colors.white,
  //         fontWeight: FontWeight.w300,
  //         height: 1.2
  //       )
  //     )
  //   );
  // }
  // final String identify;
  // final int testamentId;
  // final String testamentName;
  // final String testamentShortname;

  // final int bookId;
  // final String bookName;
  // final String bookShortname;

  // final int chapterCount;
  InkWell item(DefinitionBook book){
    bool isCurrentBook = Core.instance.bookId == book.id;
    return InkWell(
      child:Container(
        color: isCurrentBook?Colors.grey[600]:null,
        padding: EdgeInsets.symmetric(vertical:5, horizontal: 10),
        // child: AnimatedSize(
        //   vsync: this,
        //   duration: const Duration(milliseconds: 500),
        //   curve: Curves.ease,
        //   child: Text(book.name,
        //     // textScaleFactor: 0.9,
        //     style: TextStyle(
        //       fontSize: 18,
        //       color: Colors.white
        //     )
        //   )
        // ),
        child: Text(
          book.name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
             color: isCurrentBook?Colors.white30:Colors.white,
            //  fontWeight: FontWeight.w300,
            fontSize: 18,
             height: 1.5
          )
        )
      ),
      onTap: () {
        Navigator.pop<int>(context, book.id);
      }
    );
  }
}