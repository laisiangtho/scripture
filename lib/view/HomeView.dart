import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/component/scroll.dart';
import 'Home.dart';

import 'package:bible/avail.dart';

class HomeView extends HomeState {
  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    scaffoldContext = context;
    return Scaffold(
      key: scaffoldKey,
      body: ScrollPage(
        controller: controller.master,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return CustomScrollView(
      controller: controller.master,
      // controller: controller,
      // shrinkWrap: true,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar,maxHeight: 120)),
        // new SliverToBoxAdapter(),
        new SliverList(
          delegate: new SliverChildListDelegate(
            <Widget>[
              RaisedButton(
                child: Text("modal bottom sheet"),
                onPressed: showBottomSheetModal
              ),
              RaisedButton(
                child: Text("SnackBar"),
                onPressed: ()=> null,
              ),
              RaisedButton(
                child: Text("bottom sheet, hide nav, Shape"),
                onPressed: showBottomSheet,
              )
            ],
          ),
        ),
        new SliverPadding(
          // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          padding: EdgeInsets.only(bottom: controller.bottom.height),
          // sliver: SliverToBoxAdapter(
          //   child: Center(
          //     child: Text('hello')
          //   )
          // )
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _listItem(context, index),
              childCount: 50,
              // addAutomaticKeepAlives: true
            ),
          ),
        )
        // SliverList(
        //   delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        //     return Container(
        //       height: 200,
        //       color: Color(Random().nextInt(0xffffffff)),
        //     );
        //   },
        //   )
        // )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double percentage){
    return Container(
      height: 70,
      child: Center(child: Text('Home: $percentage'))
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("CustomScrollView $index")),
    );
  }

  void showBottomSheet() {
    controller.master.bottom.toggle(true);
    scaffoldKey.currentState.showBottomSheet(
      // (BuildContext context)=>TestBottomSheetLayout(),
      (BuildContext context)=>WidgetSheet(
        child:  Text("sheet")
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        ),
      ),
      // backgroundColor: Colors.red
      // context: context,
    )..closed.whenComplete(() {
      controller.master.bottom.toggle(false);
    });
    // controller.master.bottom.toggle(true);
    // scaffoldKey.currentState.showBottomSheet<void>(
    //   (BuildContext context){
    //     return TestBottomSheetLayout();
    //   }
    // )..closed.whenComplete(() {
    //   controller.master.bottom.toggle(false);
    // });
  }
  void showBottomSheetModal() {
    showModalBottomSheet(
      context: context, builder: (s) => WidgetSheet(
        child: Text("modal sheet")
      )
    )..whenComplete(() {
      print('done');
    });
  }
}
