import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetLoading extends StatelessWidget {
  final String message;
  WidgetLoading({this.message:'?'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                // padding: EdgeInsets.only(bottom: 20,top: 20),
                padding: EdgeInsets.symmetric(horizontal:20),
                child: Icon(CupertinoIcons.ellipsis),
              ),
            ],
          )
        ),
      ),
    );
  }
}