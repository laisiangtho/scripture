import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';
import '/widget/verse.dart';

part 'state.dart';
part 'header.dart';

part 'result.dart';
part 'suggest.dart';
part 'recent.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'search'; // ./result ./suggestion
  static String label = 'Search';
  static IconData icon = LideaIcon.search;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header, _Suggest, _Result {
  @override
  Widget build(BuildContext context) {
    debugPrint('search->build');

    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: _controller.bottom,
        //   notifier: App.viewData.bottom,
        // ),
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              ViewHeaderSliver(
                pinned: true,
                floating: false,
                padding: state.fromContext.viewPadding,
                heights: const [kToolbarHeight],
                // overlapsBackgroundColor: state.theme.primaryColor,
                overlapsBorderColor: state.theme.dividerColor,
                overlapsForce: innerBoxIsScrolled,
                builder: _header,
              ),
            ];
          },
          body: ValueListenableBuilder<bool>(
            valueListenable: _focusNotifier,
            builder: (context, toggle, child) {
              if (toggle) {
                return suggestView();
              }
              return child!;
            },
            child: resultView(),
          ),
        ),
      ),
    );
  }
}
