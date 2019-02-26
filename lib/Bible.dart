import 'package:flutter/material.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Store.dart';
import 'package:laisiangtho/BibleView.dart';
// import 'package:laisiangtho/BibleBookList.dart';
// import 'package:laisiangtho/BibleChapterList.dart';
// import 'package:laisiangtho/BibleSearch.dart';

// export 'package:laisiangtho/Store.dart';

// BibleSheetBooks
class Bible extends StatefulWidget {

  static BibleView of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<BibleView>());

  @override
  BibleView createState() => new BibleView();
}

abstract class BibleState extends State<Bible> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController;
  final String tmpText = "Lorem Ipsum is simply dummy text of the printing\n and typesetting industry. Lorem \nIpsum has been the industry's \nstandard dummy \ntext ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, \nremaining essentially unchanged. \n\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with \ndesktop publishing \nsoftware like Aldus PageMaker including versions of Lorem Ipsum.";

  double kExpandedHeight = 150.0;
  ModelChapter info;

  bool sheetBooksVisibility = true;
  Store store;

  AnimationController animationController;
  bool chapterListContainer = false;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();

    store = new Store();
    // sheetBooksVisibility = false;
    // scrollController = ScrollController()..addListener(() => setState(() {
    //   // chapterListContainer = false;
    // }));
  }
  //

  void infoGenerate (e){
    info = e.data;
  }

  bool get showTitleTemp {
    return scrollController.hasClients && scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  double get screenHeight {
    return MediaQuery.of(context).size.height;
  }
  double get screenWidth {
    return MediaQuery.of(context).size.width;
  }

  void setPreviousChapter() {
    store.chapterPrevious.then((_){
      setState(() {});
    });
  }
  void setNextChapter() {
    store.chapterNext.then((_){
      setState(() {});
    });
  }
  // void setBookChapter(int id) {
  //     // Navigator.pop(context);
  //   store.chapterBook(id).then((_){
  //     setState(() {
  //       print('setState $id --${store.bookId}');
  //     });
  //   });
  // }
  void setChapter(int id) {
    setState(() {
      store.chapterId = id;
    });
  }



  // void sheetBookList() {
  //   // setState((){});
  //   if (sheetBooksVisibility) {
  //     sheetBooksVisibility = !sheetBooksVisibility;
  //     scaffoldKey.currentState.showBottomSheet<void>((BuildContext context)=> new BibleBookList()).closed.whenComplete(() {
  //         sheetBooksVisibility = true;
  //       // setState(() {
  //       // });
  //     });
  //   } else {
  //     Navigator.pop(context);
  //   }

  //   // sheetBooksVisibility = !sheetBooksVisibility;
  //   // print(sheetBooksVisibility);
  //   // setState(() {
  //   //   sheetBooksVisibility = false;
  //   // });
  //   // scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context)=> new BibleBookList()).closed.whenComplete(() {
  //   //   if (mounted) {
  //   //     setState(() {
  //   //       sheetBooksVisibility = true;
  //   //     });
  //   //   }
  //   // });
  // }
  void sheetChapterList(){
    // showModalBottomSheet<Null>(context: context, builder: (BuildContext context) {
    //   return StatefulBuilder(builder: (context,state)=>new BibleChapterList());
    // }).then((void value) {
    //   setState(() {
    //     print('closed ${store.chapterId}');
    //     // Store.chapterId = id;
    //   });
    // });
    // showModalBottomSheet(context: context, builder: (BuildContext context) => new BibleChapterList()).then((void value) {
    //   setState(() {
    //     print('closed ${Store.chapterId}');
    //     // Store.chapterId = id;
    //   });
    // });
  }
  // void sheetSearch(){
  //   showSearch(context: context, delegate: new BibleSearch());
  // }
}
