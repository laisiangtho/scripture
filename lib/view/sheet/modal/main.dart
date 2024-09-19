import 'package:flutter/material.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends SheetStates<Main> {
  @override
  late final actualInitialSize = 0.4;
  @override
  late final actualMinSize = 0.3;

  @override
  List<Widget> slivers() {
    return <Widget>[
      const SliverAppBar(
        // floating: true,
        pinned: true,
        // snap: true,
        title: Text('sheet modal'),
      ),
      SliverToBoxAdapter(
        child: ElevatedButton(
          onPressed: () {
            draggableController
                .animateTo(
              0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            )
                .whenComplete(() {
              draggableController.reset();
            });
          },
          child: const Text('.animateTo(defaultInitial)'),
        ),
      ),
    ];
  }
}


// import 'package:flutter/material.dart';
// import 'package:explorer/lidea/view/draggable_sheet.dart';

// // class ViewStateSheettate<ViewDraggableSheetWidget extends StatefulWidget>
// //     extends State<ViewDraggableSheetWidget> with TickerProviderStateMixin
// // State<_SheetWidget> createState() => _SheetWidgetState();
// // class _SheetWidgetState extends ViewStateSheettate<_SheetWidget>

// class Main extends ViewDraggableSheet {
//   const Main({Key? key}) : super(key: key);



//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends ViewStateSheettate<Main> {
//   @override
//   // Widget build(BuildContext context) {
//   //   return ElevatedButton(
//   //     child: const Text('Close'),
//   //     onPressed: () => Navigator.pop(context),
//   //   );
//   // }
//   List<Widget> sliverWidgets() {
//     return <Widget>[
//       // const SliverToBoxAdapter(
//       //   child: Center(
//       //     child: Text('hello'),
//       //   ),
//       // ),
//       ...List.generate(50, (index) {
//         return const SliverToBoxAdapter(
//           child: Center(
//             child: Text('modal'),
//           ),
//         );
//       })
//     ];
//   }
// }
// // class SheetModelWidget extends StatefulWidget {
// //   const SheetModelWidget({Key? key}) : super(key: key);

// //   @override
// //   State<SheetModelWidget> createState() => _SheetModelWidgetState();
// // }

// // class _SheetModelWidgetState extends State<SheetModelWidget> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ElevatedButton(
// //       child: const Text('Close'),
// //       onPressed: () => Navigator.pop(context),
// //     );
// //   }
// // }
