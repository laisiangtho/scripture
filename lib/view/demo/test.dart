import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:scriptive/scroll.dart';
import 'package:scriptive/core.dart';
import 'package:scriptive/widget.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {

  final core = Core();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      // key: scaffoldKey,
      controller: controller.master,
      child: _body()
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollHeaderDelegate(_barMain)),
        body()
      ]
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
          'Accessibility',
          semanticsLabel: 'Accessibility',
          style: TextStyle(fontSize: 20),
        )
      ),
    );
  }

  Widget body(){
    return new WidgetContent(atLeast:'Content\n',enable:'labeling',task: ' &\nwhy ',message: 'issue');
  }
}