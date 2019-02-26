import 'package:flutter/material.dart';

// class WidgetLauncher extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 1,
//         )
//       )
//     );
//   }
// }

class WidgetLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
        )
      )
    );
  }
}

class WidgetError extends StatelessWidget {
  WidgetError({this.message});
  final message;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Error $message')
      )
    );
  }
}


class WidgetBottomSheet extends StatelessWidget {
  WidgetBottomSheet({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // Scaffold.of(context).
    return Container(
      // key: Bible.of(context).scaffoldKey,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
      child: Container(
        decoration: new BoxDecoration(
          // color: Theme.of(context).backgroundColor,
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
          border: Border.all(color: Colors.grey,style: BorderStyle.none),
          boxShadow: [
            new BoxShadow(color: Colors.grey[400], offset: Offset(0, 0),spreadRadius: 0,blurRadius: 2)
          ]
        ),
        padding: EdgeInsets.all(7.0),
        height:MediaQuery.of(context).size.height/1.15,
        // height:MediaQuery.of(context).size.height/1.5,
        width: MediaQuery.of(context).size.width,
        // child:Text('booklist?')
        // child:_list()
        child: this.child
      )
    );
  }
}

// return Container(
//   color: Theme.of(context).backgroundColor,
//   child:  Center(
//     child: CircularProgressIndicator(strokeWidth: 1,valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))
//   )
// );