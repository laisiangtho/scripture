import 'package:flutter/material.dart';

class WidgetContent extends StatelessWidget {

  WidgetContent({
    Key key,
    this.startWith:'...',
    this.atLeast:'enable at least\na ',
    this.enable:'Bible',
    this.task:'\nto ',
    this.message:'read',
    this.endWith:'...'
  }): super(key: key);

  final String startWith;
  final String endWith;
  final String atLeast;
  final String enable;
  final String task;
  final String message;

  String get label => '$startWith $atLeast $enable $task $message $endWith'.replaceAll("\n", " ").replaceAll("  ", " ");

  @override
  // enable at least\na Bible to read
  // enable at least\na Bible to search
  // enable at least\na Bible to view bookmarks
  // search\na Word or two in verses
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      fillOverscroll: false,
      hasScrollBody: false,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          strutStyle: StrutStyle(fontSize: 30.0, ),
          text: TextSpan(
            text: this.startWith,
            semanticsLabel: label,
            style: TextStyle(color: Colors.grey,fontSize: 29,fontWeight: FontWeight.w300,height: 1.0,),
            children: <TextSpan>[
              TextSpan(text:this.atLeast),
              TextSpan(
                text: this.enable,
                style: TextStyle(color: Colors.red,),
              ),
              TextSpan(
                text: this.task,
              ),
              TextSpan(
                text: this.message,
                style: TextStyle(color: Colors.brown,fontSize: 25),
              ),
              TextSpan(
                text: this.endWith,
              )
            ]
          )
        )
      ),
    );
  }
}