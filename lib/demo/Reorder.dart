import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/avail.dart';

class DemoReorder extends StatefulWidget {
  DemoReorder({
    Key key
  }) : super(key: key);

  @override
  DemoReorderView createState() => new DemoReorderView();
  }

class DemoReorderView extends State<DemoReorder> {
  Store store = new Store();

  // List<Widget> _rows;

  @override
  void initState() {
    super.initState();
    // _rows = List<Widget>.generate(50,
    //     (int index) => Text('This is sliver child $index')
    // );
  }

  @override
  Widget build(BuildContext context) {
    // ScrollController _scrollController = PrimaryScrollController.of(context) ?? store.scrollController;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('ReorderableSliverList')
            )
          ),
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: booksAnimatedList()
          )
        ]
      )
    );
  }

  Widget booksAnimatedList(){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Text('$index Item');
          // return booksItemWidget(collection.book[index],index);
        },
        childCount: 50,
      ),
    );
  }
}