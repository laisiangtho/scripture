import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Store.dart';

// import 'DemoAnimatedList.dart';
// import 'DemoNoteBookmark.dart';

class DemoMenu extends StatefulWidget {
  @override
  _DemoMenuState createState() => _DemoMenuState();
}

class _DemoMenuState extends State<DemoMenu> {
  Store store = new Store();

  void deleteCollection (){
    store.deleteCollection().then((e){
      setState(() {
       print('deleted: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<VoidCallback>(
      onSelected: (VoidCallback choice){
        choice();
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => choice),
        // ).then((e){
        //   print(e);
        // });
      },
      elevation: 1,
      padding: EdgeInsets.all(0),
      offset: Offset(10, 40),
      icon: Icon(Icons.more_vert, color: Colors.red),
      itemBuilder: (BuildContext context) {
        List<Map<String, dynamic>> testRoutes = [
          {'name':'collection Delete','action': deleteCollection},
          // {'name':'Note, Bookmark','action': DemoNoteBookmark()}
        ];
        return testRoutes.map((Map<String, dynamic> choice) {
          return new PopupMenuItem<VoidCallback>(
            value: choice['action'],
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
