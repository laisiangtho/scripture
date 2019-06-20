import 'package:bible/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

class WidgetSheet extends StatelessWidget {
  WidgetSheet({this.child});
  final Widget child;

  double get paddingBottom => Store().contextMedia.padding.bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
      ),
      padding: EdgeInsets.only(top: 0.5),
      child: Container(
        padding: EdgeInsets.only(bottom: paddingBottom),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 2))
        ),
        child: this.child
      )
    );
  }
}

class WidgetLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1
      )
      // child: CupertinoActivityIndicator()
    );
  }
}

class WidgetError extends StatelessWidget {
  WidgetError({this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: new EdgeInsets.symmetric(horizontal:60),
        // padding: new EdgeInsets.all(25),
        // decoration: new BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(2)),
        //   color: Colors.white,
        //   boxShadow: [
        //     new BoxShadow(color: Colors.grey, offset: Offset(0, 1),spreadRadius: 0.2,blurRadius: 0.7)
        //   ]
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(this.message, textAlign: TextAlign.center,),
            Padding(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Icon(CupertinoIcons.ellipsis),
            ),
          ],
        )
      ),
    );
  }
}

class WidgetEmptyIdentify extends StatelessWidget {
  WidgetEmptyIdentify({
    this.startWith:'...',
    this.atLeast:'enable at least\na ',
    this.enable:'Bible',
    this.task:'\nto ',
    this.message:'read',
    this.endWith:'...'
  });
  final String startWith;
  final String endWith;
  final String atLeast;
  final String enable;
  final String task;
  final String message;
  @override
  // enable at least\na Bible to read
  // enable at least\na Bible to search
  // enable at least\na Bible to view bookmarks
  // search\na Word or two in verses
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        // strutStyle: StrutStyle(fontSize: 30.0, height: 0.7),
        text: TextSpan(
          text: this.startWith,
          style: Theme.of(context).textTheme.subhead.copyWith(fontFamily: 'Caveat',fontSize: 28,color: Colors.grey,height: 0.9),
          children: <TextSpan>[
            TextSpan(text:this.atLeast),
            TextSpan(
              text: this.enable,
              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 42),
            ),
            TextSpan(
              text: this.task,
            ),
            TextSpan(
              text: this.message,
              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.brown,fontSize: 35),
            ),
            TextSpan(
              text: this.endWith,
            )
          ]
        )
      )
    );
  }
}

class WidgetHeaderSliver extends SliverPersistentHeaderDelegate {
  WidgetHeaderSliver(
    this.builder,
    {
      this.minHeight:45.0,
      this.maxHeight:45.0
    }
  );
  final double minHeight;
  final double maxHeight;

  double stretch = 0.0;
  double shrink = 1.0;
  Function builder;



  @override
  double get minExtent => (minHeight + paddingTop);

  @override
  double get maxExtent => maxHeight + paddingTop;


  double get paddingTop => Store().contextMedia.padding.top;

  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  Widget build(BuildContext context,double offset,bool overlaps) {
    double limitOffset = (maxExtent - minExtent);
    if (limitOffset > 0){
      stretch= min(1,offset /limitOffset);
      shrink = max(0.0,(limitOffset - offset) / (limitOffset * 1.0));
    }
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(3, 2))
      ),
      padding: EdgeInsets.only(bottom: 0.5),
      child: Container(
        padding: EdgeInsets.only(top: paddingTop),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 2))
        ),
        child: new SizedBox.expand(
          child: builder(context,offset,overlaps,stretch,shrink)
        )
      )
    );
  }

  @override
  bool shouldRebuild(WidgetHeaderSliver oldDelegate) => true;
}

class WidgetBottomNavigation extends StatelessWidget {
  WidgetBottomNavigation({this.child});
  final Widget child;

  double get paddingBottom => Store().contextMedia.padding.bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
      ),
      padding: EdgeInsets.only(top: 0.5),
      child: Container(
        padding: EdgeInsets.only(top:5,bottom: paddingBottom),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(top: Radius.elliptical(5, 2))
        ),
        child: this.child
      )
    );
  }
}
