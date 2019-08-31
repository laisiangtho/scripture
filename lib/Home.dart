import 'package:bible/Note.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'Common.dart';
import 'SheetInfo.dart';
import 'StoreModel.dart';
import 'Store.dart';
import 'HomeView.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.bottomSheet
  }) : super(key: key);

  final dynamic bottomSheet;

  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> with TickerProviderStateMixin {
  // SingleTickerProviderStateMixin TickerProviderStateMixin
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // GlobalKey<RefreshIndicatorState> refreshIndicatorState = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  AnimationController animatedController, scaleController;


  bool isSorting = false;

  Collection collection;

  @protected
  Store store = new Store();

  @override
  void initState() {
    store.scrollController?.addListener(() => setState(() {}));
    store.analyticsScreen('home','HomeState');

    animatedController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    scaleController =AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    refreshController.headerMode.addListener(() {
      if (refreshController.headerStatus == RefreshStatus.idle) {
        // scaleController.value = 0.0;
        animatedController.reset();
      } else if (refreshController.headerStatus == RefreshStatus.refreshing) {
        animatedController.repeat();
      }
    });
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
    collection = e;
  }

  List<CollectionBook> get collectionOffline => collection.book.where((e)=> e.available > 0).toList();
  List<CollectionBook> get collectionAvailable => collection.book.where((e)=> e.available >= 0).toList();

  void toBible(CollectionBook book) async{
    store.identify = book.identify;
    store.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
  }

  void showSheetInfo(CollectionBook book) {
    widget.bottomSheet((BuildContext context)=>SheetInfo(book)).whenComplete(()=>setState((){}));
  }

  void refreshUpdate() async{
    int totalPrevious = collection.book.length;
    // await Future.delayed(Duration(milliseconds: 1000));
    await store.updateCollection().then((Collection e){
      for (int index = totalPrevious; index < collection.book.length; index++) animatedListKey.currentState.insertItem(index);
    }).whenComplete((){
      setState(() {});
      refreshController.refreshCompleted();
      store.analyticsShare('Update success ', store.appVersion);
      // print('completed object');
    }).catchError((e){
      store.analyticsShare('Update fail', store.appVersion);
      refreshController.refreshFailed();
    });
  }
}