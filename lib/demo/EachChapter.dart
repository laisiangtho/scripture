import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/avail.dart';

class DemoEachChapter extends StatefulWidget {
  DemoEachChapter({
    Key key
  }) : super(key: key);

  @override
  DemoEachChapterView createState() => new DemoEachChapterView();
  }

class DemoEachChapterView extends State<DemoEachChapter> {
  Store store = new Store();

  // List<Widget> _rows;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('DemoEachChapter')
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