import 'package:flutter/material.dart';

// import 'Common.dart';
import 'StoreModel.dart';
import 'Store.dart';
import 'HomeView.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.bottomSheet,
    this.offset,
  }) : super(key: key);

  final dynamic bottomSheet;
  final double offset;

  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorState = new GlobalKey<RefreshIndicatorState>();

  VoidCallback updateCollectionCallBack;
  bool isUpdating = false;
  bool isSorting = false;

  Collection collection;

  @protected
  Store store = new Store();

  @override
  void initState() {
    store.scrollController?.addListener(() => setState(() {}));
    updateCollectionCallBack = updateCollectionAction;
    super.initState();
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
  }

  List<CollectionBook> get collectionOffline => collection.book.where((e)=> e.available > 0).toList();
  List<CollectionBook> get collectionAvailable => collection.book.where((e)=> e.available >= 0).toList();

  void toBible(CollectionBook book) async{
    store.identify = book.identify;
    store.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
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
}