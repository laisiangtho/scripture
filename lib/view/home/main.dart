import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bible/component.dart';
import 'package:bible/core.dart';
import 'package:bible/widget.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

part 'view.dart';
part 'bar.dart';
part 'refresh.dart';
part 'info.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  final core = Core();

  // MainState get ancestorState => Scaffold.of(context).context.findAncestorStateOfType<MainState>();
  // final animatedListKey = GlobalKey<AnimatedListState>();
  final sliverAnimatedListKey = GlobalKey<SliverAnimatedListState>();
  AnimationController animatedController, scaleController;// animatedListController;

  bool isSorting = false;

  // Collection get collection => core.collection;
  List<CollectionBible> get collectionBibleList => core.collection.bible;

  @override
  void initState() {
    super.initState();
    // collection = core.collection;
    animatedController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    // animatedListController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    scaleController = AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void setSorting (){
    if (isSorting) core.writeCollection();
    setState(() {
      isSorting = !isSorting;
    });
  }

 void toBible(CollectionBible bible) {
    if (core.identify != bible.identify){
      setState(() {
        core.identify = bible.identify;
      });
    }
    controller.master.bottom.pageChange(1);
    // core.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
  }
}
