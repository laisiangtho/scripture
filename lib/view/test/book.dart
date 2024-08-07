import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/sliver_tools.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-book';
  static String label = 'Book';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: App.preference.text.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, 0),
          vhd.snapShrink,
        ),
        label: 'Abc',
        data: vhd,
      ),
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Views(
        child: CustomScrollView(
          controller: scrollController,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        // floating: false,
        // padding: const EdgeInsets.only(top: 30),
        // heights: const [kToolbarHeight, 100],
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        // overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      SliverList.builder(
        itemBuilder: (BuildContext _, int index) {
          return ListTile(
            title: Text('... $index'),
          );
        },
        itemCount: 50,
      ),
    ];
  }
}
