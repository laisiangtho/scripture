import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: new Icon(
                Icons.sort,
              ),
              onPressed: ()=>null
            ),
            selectable()
          ],
        )
      )
    );
  }

  Widget selectable(){
    return SelectableText.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '\t',
            children: <TextSpan>[
              TextSpan(
                text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
              ),
            ],
            style: TextStyle(
              // color: Colors.grey,
              // fontWeight: FontWeight.w300
            )
          ),
        ]
      ),
      cursorColor: Colors.red,
    );
  }
}