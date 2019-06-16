import 'package:flutter/material.dart';

// import 'Common.dart';
import 'StoreModel.dart';
import 'Store.dart';
import 'HomeView.dart';

class Home extends StatefulWidget {
  Home({
    Key key,

    this.scrollController,
    this.pageController,
    this.offset,
  }) : super(key: key);

  final ScrollController scrollController;
  final PageController pageController;
  final double offset;

  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorState = new GlobalKey<RefreshIndicatorState>();

  PersistentBottomSheetController<void> bottomSheet;
  // ScaffoldFeatureController  bottomSheet;
  VoidCallback updateCollectionCallBack;
  // VoidCallback updateAvailableCallBack;
  bool isUpdating = false;
  // bool isDownloading = false;
  bool isSorting = false;

  Collection collection;
  // List<CollectionBook> books;

  @protected
  Store store = new Store();


  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(() => setState(() {}));
    updateCollectionCallBack = updateCollectionAction;
    // updateAvailableCallBack = updateAvailableAction;
    // double abc = MediaQuery.of(context).padding.top;
    // EdgeInsets contextPadding = MediaQuery.of(context).padding;

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
   void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void collectionGenerate (e){
    collection = e.data;
    // books = e.data;
  }

  List<CollectionBook> get collectionOffline => collection.book.where((e)=> e.available > 0).toList();
  List<CollectionBook> get collectionAvailable => collection.book.where((e)=> e.available >= 0).toList();

  // void toBook(CollectionBook book){
  //   store.identify = book.identify;
  //   Navigator.pushNamed(context, 'book');
  // }
  void toBible(CollectionBook book) async{
    // store.identify = book.identify;
    // Navigator.pushNamed(context, 'bible');
    store.identify = book.identify;
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context)  => WidgetLoad()
    // );
    // await store.activeName();
    // // Navigator.of(context)..pop()..pushNamed('bible');
    // Navigator.of(context)..pop();

    // if (widget.pageController == null) {
    //   // Navigator.pushNamed(context, 'bible');

    // } else {
    //   // widget.navigator(1);
    //   widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
    // }
    widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
  }

  void updateCollectionAction() {
    setState(() {
      isUpdating = true;
      updateCollectionCallBack = null;
    });
    store.updateCollection().catchError((_e){
      print(_e);
    }).whenComplete((){
      setState(() {
        isUpdating = false;
        updateCollectionCallBack = updateCollectionAction;
      });
    });
  }
  // void updateAvailableAction() {
  //   // _bottomSheet?
  //   setState(() {
  //     isDownloading = true;
  //     updateAvailableCallBack = null;
  //   });
  //   bottomSheet?.setState(() { });
  //   store.updateCollectionAvailable().catchError((_e){
  //     print(_e);
  //   }).then((_isAvailable){
  //     setState(() {
  //       isDownloading = false;
  //       updateAvailableCallBack = updateAvailableAction;
  //     });
  //     bottomSheet?.setState(() { });
  //     bottomSheet?.close();
  //   });
  //   // bottomSheet.setState(() { });
  // }
}