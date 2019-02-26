import 'package:flutter/material.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Store.dart';
import 'package:laisiangtho/BookView.dart';

class Book extends StatefulWidget {
  // final ModelBible bible;
  // Book({Key key, this.bible}) : super(key: key);

  @override
  BookView createState() => new BookView();
}

abstract class BookState extends State<Book> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController;
  VoidCallback availableButtonCallBack;

  // VoidCallback buildCallBack;

  List<ModelBible> books;
  ModelBible bible;

  bool isLoading = false;

  @protected
  Store store;

  @override
  void initState() {
    super.initState();
    store = new Store();
    availableButtonCallBack = _availableButtonAction;
    scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void booksGenerate (e){
    books = e.data;
    bible = books.singleWhere((e)=>e.identify == store.identify);
  }
  get isAvailable => bible.available > 0?true:false;

  void _availableButtonAction() {
    setState(() {
      // bible.available = bible.available >0?0:1;
      isLoading = true;
      availableButtonCallBack = null;
      store.identify = bible.identify;
    });
    store.updateBookAvailable().then((_isAvailable){
      setState(() {
        isLoading = false;
        availableButtonCallBack = _availableButtonAction;
        print(_isAvailable);
      });
    });
  }
}