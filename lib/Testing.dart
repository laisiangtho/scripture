import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  // Testing({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _TestingState createState() => new _TestingState();
}

class _TestingState extends State<Testing>  with SingleTickerProviderStateMixin {
  _TestingState() {
    controller = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  AnimationController controller;
  Animation animation;
  bool expanded = false;

  _animateAppBar() {
    expanded ? controller.reverse() : controller.forward();
    expanded = !expanded;
  }

  Widget build(BuildContext context) {
    return new AnimatedScaffoldBottom(
        animation: animation, onPress: _animateAppBar);
  }
}

class AnimatedScaffoldBottom extends AnimatedWidget {
  AnimatedScaffoldBottom({Key key, Animation<double> animation, this.onPress})
      : super(key: key, listenable: animation);

  final Function onPress;
  static final _sizeTween = new Tween<double>(begin: 0.0, end: 300.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
          child: new Text(
        'Hello World!',
        // style: Theme.of(context).textTheme.display1,
      )),
      appBar: new AppBar(
        title: const Text('Expanding AppBar Example'),
        elevation: 0.3,

        actions: [
          new IconButton(
            icon: new Icon(Icons.expand_more),
            onPressed: onPress,
          ),
        ],
        bottom: new PreferredSize(
          preferredSize: new Size.fromHeight(_sizeTween.evaluate(listenable)),
          child: new Container(
            color: Colors.grey[200],
            height: _sizeTween.evaluate(listenable),
            // child: const Center(
            //   child: const FlutterLogo(size: 200.0),
            // ),
            child: _listView()
          ),
        ),
      ),
    );
  }
    Widget _listView() {
    return new ListView.builder(
      itemCount: 60,
      itemBuilder: _listViewItem,
      // controller: scrollController
    );
  }
  Widget _listViewItem(BuildContext context, int index) {
    return new Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        // border: Border.all(width:0.2,color: Colors.grey)
      ),
      child: new Text('Item $index')
    );
  }
}