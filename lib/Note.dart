import 'package:flutter/material.dart';

export 'StoreModel.dart';
export 'Common.dart';

// import 'StoreModel.dart';
import 'Store.dart';

import 'NoteView.dart';

class Note extends StatefulWidget {
  Note({
    Key key,
    this.scrollController,
    this.pageController,
    this.offset,
  }) : super(key: key);

  final ScrollController scrollController;
  final PageController pageController;
  final double offset;

  @override
  NoteView createState() => new NoteView();
}

abstract class NoteState extends State<Note> with TickerProviderStateMixin{

  Store store = new Store();

  double shrinkOffsetPercentage=1.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(() => setState(() {}));
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
    widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // widget.pageController.jumpToPage(1);
  }
}
