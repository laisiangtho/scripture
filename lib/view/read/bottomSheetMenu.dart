// part of 'main.dart';

// class BottomSheetMenu extends StatefulWidget {
//   BottomSheetMenu({Key key,this.controller,this.verseSelectionList}) : super(key: key);
//   final ScrollController controller;
//   final List<int> verseSelectionList;
//   @override
//   BottomSheetMenuState createState() => BottomSheetMenuState();
// }

// class BottomSheetMenuState extends State<BottomSheetMenu> {
//   // final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//           ];
//         },
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               CupertinoButton(
//                 child: Text("Copy selection"),
//                 onPressed: null
//               ),
//               CupertinoButton(
//                 child: Text("Clean selection"),
//                 onPressed: null
//               ),
//               CupertinoButton(
//                 child: Text("Switch Bible"),
//                 onPressed: null
//               ),
//               CupertinoButton(
//                 child: Text("?? ${widget.verseSelectionList.length}"),
//                 onPressed: null
//               ),
//               CupertinoButton(
//                 child: Text("Close"),
//                 onPressed: null
//               ),
//             ],
//           ),
//         )
//       ),
//     );
//     // return CustomScrollView(
//     //   controller: widget.controller,
//     //   // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//     //   // primary: true,
//     //   slivers: <Widget>[
//     //     new SliverList(
//     //       delegate: new SliverChildListDelegate(
//     //         <Widget>[
//     //           CupertinoButton(
//     //             child: Text("Copy selection"),
//     //             onPressed: null
//     //           ),
//     //           CupertinoButton(
//     //             child: Text("Clean selection"),
//     //             onPressed: null
//     //           ),
//     //           CupertinoButton(
//     //             child: Text("Switch Bible"),
//     //             onPressed: null
//     //           ),
//     //           CupertinoButton(
//     //             child: Text("?? ${widget.verseSelectionList.length}"),
//     //             onPressed: null
//     //           ),
//     //         ]
//     //       )
//     //     )
//     //     // SliverPadding(
//     //     //   // padding: null,
//     //     //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top:MediaQuery.of(context).viewInsets.top),
//     //     //   sliver: new SliverList(
//     //     //     delegate: new SliverChildListDelegate(
//     //     //       <Widget>[
//     //     //         RaisedButton(
//     //     //           child: Text("Clean selection"),
//     //     //           onPressed: () {},
//     //     //         ),
//     //     //         Center(child: Text('Menu'))
//     //     //       ]
//     //     //     ),
//     //     //   )
//     //     // )
//     //   ]
//     // );
//   }
// }