import 'dart:math';

import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<String> items = <String>['1', '2', '3', '4', '5'];

  final pageController = PageController();

  void _reverse() {
    setState(() {
      items = items.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.custom(
          controller: pageController,
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return KeepAlive(
                data: items[index],
                test: new Random().nextInt(100),
                key: ValueKey<String>(items[index]),
              );
            },
            childCount: items.length,
            findChildIndexCallback: (Key key) {
              final ValueKey valueKey = key;
              final String data = valueKey.value;
              return items.indexOf(data);
            }
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => _reverse(),
              child: Text('Reverse'),
            ),
            IconButton(onPressed: () {
              pageController.jumpTo(2.0);
            }, icon: Icon(Icons.menu),),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add), onPressed: () {
          setState(() {

          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

// PageController controller;
// int currentpage = 0;

//   Widget buildB(BuildContext context) {
//     return new Scaffold(
//       body: new Center(
//       child: new Container(
//       child: new PageView.builder(
//       onPageChanged: (value) {
//         setState(() {
//         currentpage = value;
//         });
//       },
//       controller: controller,
//       itemBuilder: (context, index) => builder(index)),
//       ),
//       ),
//     );
//   }

//   builder(int index) {
//   return new AnimatedBuilder(
//     animation: controller,
//     builder: (context, child) {
//     double value = 1.0;
//     if (pageController.position.haveDimensions) {
//       value = controller.page - index;
//       value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
//     }
//     return new Center(
//     child: new SizedBox(
//     height: Curves.easeOut.transform(value) * 300,
//     width: Curves.easeOut.transform(value) * 250,
//     child: child,
//     ),
//     );
//     },
//     child: new Container(
//     margin: const EdgeInsets.all(8.0),
//     color: index % 2 == 0 ? Colors.blue : Colors.red,
//     ),
//     );
//   }
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({Key key, this.data, this.test}) : super(key: key);

  final String data;
  final int test;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('setstate');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Text(widget.data);
    return new ListView.builder(
      // key: new Key(randomString(20)), //new
      // itemBuilder: (BuildContext context, int index) => children[index],
      itemBuilder: _listItem,
      itemExtent: 128.0,
      // itemCount: children.length,
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      // color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("test ${widget.test} data ${widget.data} of $index")),
    );
  }
}