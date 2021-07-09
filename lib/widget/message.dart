import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WidgetMsg extends StatelessWidget {
  final String message;
  WidgetMsg({Key? key, this.message:''}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: new EdgeInsets.symmetric(horizontal:60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Semantics(
            label: "Message",
            child: Text(
              message,
              semanticsLabel: message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21
              ),
            ),
          ),
          Semantics(
            label: "Icon",
            child: Padding(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Icon(
                CupertinoIcons.ellipsis,
                semanticLabel: "ellipsis",
                size: 40
              )
            ),
          )
        ]
      )
    );
  }
}

class WidgetMessage extends StatelessWidget {
  final String message;
  WidgetMessage({Key? key, this.message:''}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverFillRemaining(
      key: key,
      hasScrollBody: false,
      fillOverscroll: false,
      child: WidgetMsg(message: message)
    );
  }
}

class WidgetHint extends StatelessWidget {

  WidgetHint({
    Key? key,
    this.message:'?',
    this.label:'?',
    this.route:true,
    this.enabled:true,
    required this.child
  }): super(key: key);

  final String message;
  final bool route;
  final String label;
  final bool enabled;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: key,
      label: label,
      namesRoute: route,
      enabled: enabled,
      child: Tooltip(
        message: message,
        excludeFromSemantics:true,
        child: child,
      )
    );
  }
}

Future<bool?> doConfirmWithDialog({
  required BuildContext context,
  required String message,
  String? cancel:'Cancel',
  String? confirm:'Confirm'
  }) async {
  if (!Platform.isIOS) {
    return await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        contentPadding: EdgeInsets.symmetric(horizontal:20, vertical:20),
        actionsPadding: EdgeInsets.symmetric(horizontal:20, vertical:10),
        actions: <Widget>[
          CupertinoButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal:12, vertical:7),
            minSize: 10,
            child: Text(cancel!),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoButton(
            color: Theme.of(context).splashColor,
            padding: EdgeInsets.symmetric(horizontal:12, vertical:7),
            minSize: 10,
            child: Text(confirm!),
            // Navigator.of(context, rootNavigator: true).pop(false)
            onPressed: () => Navigator.of(context).pop(true)
          ),
        ],
      )
    );
  }
  return await showCupertinoDialog<bool?>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: Text(cancel!),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(confirm!),
          // Navigator.of(context, rootNavigator: true).pop(false)
          onPressed: () => Navigator.of(context).pop(true)
        ),
      ],
    )
  );
}