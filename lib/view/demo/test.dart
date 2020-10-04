import 'package:bible/component.dart';
import 'package:bible/core.dart';
import 'package:bible/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {

  final core = Core();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      body: ScrollPage(
        controller: controller.master,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar)),
        body()
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Accessibility',
        semanticsLabel: 'Accessibility',
        style: TextStyle(fontSize: 20),
      )
    );
  }

  Widget body(){
    return new WidgetContent(atLeast:'Content\n',enable:'labeling',task: ' &\nwhy ',message: 'issue');
  }
}