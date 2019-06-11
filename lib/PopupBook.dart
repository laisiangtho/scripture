import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'Popup.dart';
import 'Store.dart';
import 'StoreModel.dart';

class PopupBook extends StatefulWidget {
  PopupBook(
    {
      Key key,
      this.shrinkOffset:1.0,
    }
  ) : super(key: key);
  final double shrinkOffset;

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
    double halfWidth = (MediaQuery.of(context).size.width/2) - 20;
    return Popup(
      offsetPersentage: widget.shrinkOffset,
      right:halfWidth,
      top:  20*widget.shrinkOffset+43,
      arrow:  140,
      height: 500,
      child: FutureBuilder<List<BOOK>>(
        future: store.bookTitle,
        builder: (BuildContext context, AsyncSnapshot<List<BOOK>> e) {
          return e.hasData?view(e.data):Center(child: CircularProgressIndicator());
        }
      )
    );
  }
  ListView view(books){
    return ListView.separated(
      separatorBuilder: (context, index) => Divider( color: Colors.grey, height: 0),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        BOOK book = books[index];
        return (book.type)?header(book):item(book);
      }
    );
  }

  Padding header(BOOK testament){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:5.0, vertical:5),
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
        padding: EdgeInsets.symmetric(vertical:8, horizontal: 10),
        child: AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
          child: Text(book.name,
            // textScaleFactor: 0.9,
            style: TextStyle(
              height: 0.7,
              color: isCurrentBook?Colors.white30:Colors.white,
              fontWeight: FontWeight.w200,
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