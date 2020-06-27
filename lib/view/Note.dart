// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:bible/component/scroll.dart';
import 'package:bible/avail.dart';
import 'NoteView.dart';

class Note extends StatefulWidget {
  Note({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => NoteView();
}

abstract class NoteState extends State<Note> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Note> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final store = Store();
  final int _id = 2;
  // TickerProviderStateMixin, SingleTickerProviderStateMixin
  ScrollController controller;
  // final controller = ScrollController();

  double get offset => store.offset[_id]??0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      // initialScrollOffset: offset,
      // keepScrollOffset: true
    )..addListener(() {
      // store.offset[_id] = controller.position.pixels;
    });
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
}
