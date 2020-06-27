// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:bible/component/scroll.dart';
import 'package:bible/avail.dart';
import 'HomeView.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<StatefulWidget> createState() => HomeView();
}

abstract class HomeState extends State<Home> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Home>  {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final store = Store();
  final int _id = 0;
  // TickerProviderStateMixin, SingleTickerProviderStateMixin
  // ScrollController controller;
  final controller = ScrollController();

  double get offset => store.offset[_id]??0.0;
  // GlobalKey<ScaffoldState> get scaffoldParent => widget.scaffoldKey;
  // dynamic get bottomSheet => widget.bottomSheet;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // controller = ScrollController(
    //   // initialScrollOffset: offset,
    //   // keepScrollOffset: true
    // )..addListener(() {
    //   // store.offset[_id] = controller.position.pixels;
    // });
  }

  // Future doAsyncStuff() async {
  //   keepAlive = true;
  //   updateKeepAlive();
  //   // Keeping alive...

  //   // await Future.delayed(Duration(seconds: 10));

  //   // keepAlive = false;
  //   // updateKeepAlive();
  //   // Can be disposed whenever now.
  // }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  // @override
  // // @protected
  // // @mustCallSuper
  // void didUpdateWidget(covariant oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

}
