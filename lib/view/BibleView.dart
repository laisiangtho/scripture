import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/component/scroll.dart';
import 'Bible.dart';

class BibleView extends BibleState {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      body: ScrollPage(
        controller: controller,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return CustomScrollView(
      // controller: controller.master,
      controller: controller,
      // shrinkWrap: true,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar,minHeight: 30)),
        new SliverToBoxAdapter(
          child: Center(
            child: RaisedButton(
              child: Text("bible to note"),
              onPressed: () {
                controller.master.bottom.pageChange(2);
              },
            ),
          )
        ),
        new SliverToBoxAdapter(
          child: Center(
            child: RaisedButton(
              child: Text("Popup"),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   // PageRouteBuilder(
                //   //   pageBuilder: (c, a1, a2) => Container(color: Colors.white,child: Center(child: Text("Hello Popup"))),
                //   //   transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                //   //   transitionDuration: Duration(milliseconds: 200),
                //   // ),
                //   MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))))
                // );
                // Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))), maintainState: false));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))), maintainState: false));
                // Navigator.pushNamed(context, '2');
                // Navigator.of(context).pushNamedAndRemoveUntil('3', (Route<dynamic> route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SecondRoute()),
                  // );
                // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new SecondRoute()));
                // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new SecondRoute(), maintainState: true,fullscreenDialog: true));
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new SecondRoute(), maintainState: true));
              },
            ),
          )
        ),
        new SliverPadding(
          // padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          padding: EdgeInsets.only(bottom: controller.bottom.height),
          // sliver: SliverToBoxAdapter(
          //   child: Center(
          //     child: Text('hello')
          //   )
          // )
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _listItem(context, index),
              childCount: 103,
              // addAutomaticKeepAlives: true
            ),
          ),
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double percentage){
    return Container(
      height: 70,
      child: Center(child: Text('Bible: $percentage'))
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("CustomScrollView $index")),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}