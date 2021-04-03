import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

import 'package:lidea/scroll.dart';
// import 'package:bible/widget.dart';
// import 'package:bible/core.dart';
// import 'package:bible/icon.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  AnimationController animatedController;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}

mixin _Bar on _State {
  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:true,
      // delegate: new ScrollHeaderDelegate(_bar,minHeight: 40, maxHeight: 50)
      delegate: new ScrollHeaderDelegate(_barMain)
    );
  }

  Widget _barDecoration({double stretch, Widget child}){
    return Container(
      decoration: BoxDecoration(
        // color: this.backgroundColor??Theme.of(context).primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            // color: Colors.black38,
            color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return _barDecoration(
      stretch: stretch,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'Bookmark',
          semanticsLabel: 'Bookmark',
          style: TextStyle(fontSize: 20),
        )
      ),
    );
  }
}

class View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ScrollPage(
        controller: controller.master,
        child: _scroll(),
      ),
    );
  }

  CustomScrollView _scroll() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        _body()
      ]
    );
  }

  Widget _body(){
    // return new WidgetContent(atLeast:'collection of\n',enable:'Bookmark',task: ' &\nother ',message: 'library');
    return Container(
      child: Center(child: Text('collection of Bookmark, library and other'))
    );
  }
}