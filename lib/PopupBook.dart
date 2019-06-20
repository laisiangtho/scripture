import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'Popup.dart';
import 'Store.dart';
import 'StoreModel.dart';

class PopupBook extends StatefulWidget {
  PopupBook({this.mainContext});
  final RenderBox mainContext;

  @override
  State<StatefulWidget> createState() => _Chapter();
}

class _Chapter extends State<PopupBook> with TickerProviderStateMixin {
  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size targetSize = widget.mainContext.size;
    final Offset targetPosition = widget.mainContext.localToGlobal(Offset.zero);

    double halfWidth = (MediaQuery.of(context).size.width/2) - 50;
    return Popup(
      right:halfWidth,
      left: 10,
      height: MediaQuery.of(context).size.height,
      top: targetPosition.dy + targetSize.height + 7,
      arrow: targetPosition.dx + (targetSize.width/2)-15,
      child: FutureBuilder<List<BOOK>>(
        future: store.bookTitle,
        builder: (BuildContext context, AsyncSnapshot<List<BOOK>> e) {
          return e.hasData?view(e.data):Center(child: CircularProgressIndicator());
        }
      )
    );
  }
  ListView view(books){
    return ListView.builder(
      // separatorBuilder: (context, index) => Divider( color: Colors.white, height: 2),
      padding: EdgeInsets.zero,
      // shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        BOOK book = books[index];
        return (book.type)?header(book):item(book);
      }
    );
  }

  Widget header(BOOK testament){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:5.0, vertical:10),
      // color: Colors.red,
      child: Text(
        testament.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w300
        )
      )
    );
  }

  InkWell item(BOOK book){
    bool isCurrentBook = store.bookId == book.id;
    return InkWell(
      child:Container(
        color: isCurrentBook?Colors.grey[600]:null,
        padding: EdgeInsets.symmetric(vertical:15, horizontal: 10),
        child: AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
          child: Text(book.name,
            // textScaleFactor: 0.9,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white
            )
          )
        ),
        // child: Text(
        //   book.name,
        //   style: TextStyle(
        //      color: isCurrentBook?Colors.white30:Colors.white,
        //      fontWeight: FontWeight.w300,
        //   )
        // )
      ),
      onTap: () => Navigator.pop<int>(context, book.id)
    );
  }
}