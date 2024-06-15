import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';

import '../../app.dart';

import '/widget/verse.dart';

part 'state.dart';
part 'header.dart';
part 'gadget.dart';
part 'result.dart';
part 'suggest.dart';
part 'recent.dart';

// final _textController = TextEditingController();

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'search';
  static String label = 'Search';
  static IconData icon = LideaIcon.search;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ViewBars(
        padding: state.fromContext.viewPadding,
        // forceOverlaps: false,
        // forceStretch: true,
        // backgroundColor: Theme.of(context).primaryColor,
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        child: _header(),
      ),
      body: Views(
        child: ValueListenableBuilder<bool>(
          valueListenable: _focusNotifier,
          builder: (_, focus, header) {
            return ViewDelays.milliseconds(
              onAwait: const ViewFeedbacks.await(),
              builder: (_, __) {
                if (focus) {
                  return const _Suggest();
                } else {
                  return const _Result();
                }
              },
            );
            // return ViewFeedbacks.message(label: focus.toString());
          },
        ),
      ),
    );
  }
}
