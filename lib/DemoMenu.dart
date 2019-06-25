import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DemoAnimatedList.dart';
import 'DemoNoteBookmark.dart';
import 'DemoSearchResult.dart';



class DemoMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<Widget>(
      onSelected: (Widget choice){
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => choice),
        ).then((e){
          print(e);
        });
      },
      elevation: 1,
      padding: EdgeInsets.all(0),
      offset: Offset(10, 40),
      icon: Icon(Icons.more_vert, color: Colors.red),
      itemBuilder: (BuildContext context) {
        List<Map<String, dynamic>> testRoutes = [
          {'name':'Animated List','context': DemoAnimatedList()},
          {'name':'Note, Bookmark','context': DemoNoteBookmark()},
          {'name':'Search Result','context': DemoSearchResult()},
        ];
        return testRoutes.map((Map<String, dynamic> choice) {
          return new PopupMenuItem<Widget>(
            value: choice['context'],
            child: Text(choice['name']),
          );
        }).toList();
      }
    );
  }
}



// class DemoPopup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new IconButton(
//       icon: new Icon(Icons.mouse),
//       color: Colors.red,
//       iconSize: 18,
//       onPressed: (){
//         Navigator.of(context).push(PageRouteBuilder(
//           opaque: false,
//           barrierDismissible: true,
//           pageBuilder: (BuildContext context, _, __) => DemoPopupOverlay()
//         ));
//       },
//     );
//   }
// }
