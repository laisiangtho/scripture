import 'package:flutter/material.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Store.dart';
import 'package:laisiangtho/HomeView.dart';
// import 'package:laisiangtho/HomeBookDetail.dart';
// import 'package:laisiangtho/Book.dart';
// import 'package:laisiangtho/StoreBook.dart';


class Home extends StatefulWidget {

  static HomeView of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<HomeView>());
  // static HomeView of(BuildContext context) => context.rootAncestorStateOfType(const TypeMatcher<HomeView>());
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController;
  VoidCallback updateButtonCallBack;
  bool isLoading = false;

  List<ModelBible> books;

  @protected
  Store store;


  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(() => setState(() {}));
    store = new Store();
    updateButtonCallBack = _updateButtonAction;
  }

  void booksGenerate (e){
    books = e.data;
    // await bookList.then((books) => books.where((e)=>e.identify == id).toList());
    // List<ModelBible> booksAvailable = books.where((e)=> e.lang == 'en').toList();
    // print(booksAvailable.length);
    // booksAvailable.forEach((e){
    //   print(e.name);
    // });
  }

  // List<ModelBible> get booksOffline => books.where((e)=> e.lang == 'en' || e.lang == 'my').toList();
  List<ModelBible> get booksOffline => books.where((e)=> e.available > 0).toList();
  List<ModelBible> get booksAvailable => books.where((e)=> e.available >= 0).toList();


  void _updateButtonAction() {
    setState(() {
      isLoading = true;
      updateButtonCallBack = null;
    });
    store.updateBook().then((_isUpdated){
      // print('updated?');
    }).catchError((isError){
      // print('error?');
    }).whenComplete((){
      print('updated');
      setState(() {
        isLoading = false;
        updateButtonCallBack = _updateButtonAction;
      });
    });
  }

  void toBible(book){
    // print('toBible');
    store.identify = book.identify;
    // print(store.identify);
    Navigator.pushNamed(context, 'bible');
  }

  void toBook(ModelBible book){
    // print('toBook');
    // setState(() {
    //   book.available = book.available >0?0:1;
    // });
    store.identify = book.identify;
    Navigator.pushNamed(context, 'book');
  }

}