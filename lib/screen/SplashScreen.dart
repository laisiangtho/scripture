import 'package:bible/core.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
// SplashScreen Launcher
class SplashScreen extends StatelessWidget {
  final double progress;
  SplashScreen({this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Colors.red,
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '"',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w200,
                    fontSize: 29,
                  ),
                  children: <TextSpan>[
                    TextSpan(text:'the'),
                    TextSpan(
                      text: ' holy\n',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 33,
                      )
                    ),
                    TextSpan(
                      text: 'Bible\n',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 51,
                      )
                    ),
                    TextSpan(
                      text: 'in ',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 15,
                      )
                    ),
                    TextSpan(
                      text: 'languages"',
                      style: TextStyle(
                        fontSize: 22,
                      )
                    ),
                  ]
                )
              ),
            ),
            CircularProgressIndicator(
              value: progress+0.1,
              backgroundColor: Colors.grey[300],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
              strokeWidth: 1
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:50 ),
              // decoration: new BoxDecoration(
              //   color: Colors.grey,
              //   // color: Theme.of(context).backgroundColor,
              //   // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(3, 2))
              //   borderRadius: new BorderRadius.all(Radius.elliptical(10, 50)),
              //   // boxShadow: [BoxShadow(blurRadius:60,color: Colors.brown,offset: Offset(0,1))]
              // ),
              child: Text(
                // 'Lai Siangtho'.toUpperCase(),
                Core.instance.appName.toUpperCase(),
                // MaterialApp.of(context).,
                // Scaffold.of(context).,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey
                )
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: name(),
    );
  }

  Widget name(){
    return Container(
      height: 70,
      child: Center(
        child: Text(
          // store.appVersion,
          // Store.apple
          Core.instance.version,
          // '...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w200,
            // foreground: Paint()
            //   ..style = PaintingStyle.stroke
            //   ..strokeWidth = 2
            //   ..color = Colors.grey[200],
            shadows: <Shadow>[
              // Shadow(
              //   offset: Offset(0.3, 0.5),
              //   blurRadius: 0.2,
              //   color: Colors.black
              // ),
              // Shadow(
              //   offset: Offset(2.0, 1.0),
              //   blurRadius: 20.0,
              //   color: Colors.red,
              // ),
            ],
          ),
        )
      ),
    );
  }
}