import 'package:flutter/material.dart';
// import 'package:scripture/widget/button.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';
import 'package:lidea/route/main.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-navigation';
  static String label = 'Section';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  // @override
  // ViewData get viewData => App.viewData;

  @override
  double get actualInitialSize => 0.9;
  @override
  double get actualMinSize => 0.4;

  late final RouteChangeNotifier notifier = RouteChangeNotifier();

  @override
  Widget draggableBody(BuildContext context, ScrollController controller) {
    // return Scrollable(
    //   controller: controller,
    //   viewportBuilder: (_, __) {
    //     return child();
    //   },
    // );
    return child();
  }

  Widget child() {
    return NestedView(
      delegate: ReadNestDelegate(
        notifier: notifier,
        name: rootPath,
        arguments: state.arguments,
        // root: state.name ?? TmpSheetHome.route,
        // route: routes,
      ),
    );
  }

  /// remove parent root path
  String get rootPath {
    // state.arguments.toString(),
    debugPrint('state.arguments: ${state.arguments}');
    if (state.name != null) {
      var name = state.name?.split('/');

      int index = name!.indexOf(Main.route);
      name.removeRange(0, index + 1);

      // numbers.removeWhere((item) => item.length == 3);
      // name.removeWhere((item) => item.length == index);
      return name.join('/?');
    }

    return "";
  }
}
