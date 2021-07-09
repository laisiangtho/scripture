import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/intl.dart' as intl;
// import 'package:lidea/view.dart';

import 'package:bible/core.dart';
// import 'package:bible/type.dart';
// import 'package:dictionary/widget.dart';

class DemoView extends StatelessWidget {
  final Core core;
  DemoView({Key? key, required this.core}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      key: key,
      delegate: new SliverChildListDelegate(
        <Widget>[
          ElevatedButton(
            child: Text("DateTime.now"),
            onPressed: () {
              final abc = DateTime.now();
              debugPrint(abc.toString());
            },
          ),
          ElevatedButton(
            child: Text("mockTest"),
            onPressed: () {
              core.mockTest().then((value) {
                print(value);
              }).catchError((e){
                print(e.toString());
              });
             print('catchError');
            },
          ),
          ElevatedButton(
            child: Text("Formatted Number"),
            onPressed: () {
              var _formattedNumber = intl.NumberFormat.compact().format(1500);
              debugPrint('Formatted Number is $_formattedNumber');
            },
          ),
        ]
      )
    );
  }
}