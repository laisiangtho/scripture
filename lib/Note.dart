import 'package:flutter/material.dart';

export 'StoreModel.dart';
export 'Common.dart';

// import 'StoreModel.dart';
import 'Store.dart';

import 'NoteView.dart';

class Note extends StatefulWidget {
  Note({
    Key key
  }) : super(key: key);

  @override
  NoteView createState() => new NoteView();
}

abstract class NoteState extends State<Note> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  Store store = new Store();

  double shrinkOffsetPercentage=1.0;

  @override
  void initState() {
    super.initState();
    store.scrollController?.addListener(() => setState(() {}));
    store.analyticsScreen('note','NoteState');
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void toBible (){
    store.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // widget.pageController.jumpToPage(1);
  }
}
