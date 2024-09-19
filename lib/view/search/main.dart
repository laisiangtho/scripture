import 'package:flutter/material.dart';
import 'package:lidea/provider.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';
part 'suggest.dart';
part 'histories.dart';
part 'result.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State<Main> with _Suggest, _Result {
  // @override
  // Widget build(BuildContext context) {
  //   refreshQuery();
  //   return super.build(context);
  // }

  @override
  Widget suggestView() {
    return ViewDelays.milliseconds(
      onAwait: const ViewFeedbacks.await(),
      builder: (_, __) {
        return Selector<Core, CacheBible>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, CacheBible o, Widget? child) {
            if (o.query.isEmpty) {
              return child!;
            }
            return _suggestBlock(o);
          },
          child: const _Histories(),
        );
      },
    );
  }

  @override
  Widget resultView() {
    return ViewDelays.milliseconds(
      onAwait: const ViewFeedbacks.await(),
      builder: (_, __) {
        return Selector<Core, CacheBible>(
          selector: (_, e) => e.scripturePrimary.verseSearch,
          builder: (BuildContext context, CacheBible o, Widget? child) {
            if (o.query.isEmpty) {
              return _resultEmptyQuery();
            } else if (o.result.ready) {
              return _resultBlock(o);
            } else if (o.words.isNotEmpty) {
              return _resultWords(o);
            }
            return _resultEmpty();
          },
        );
      },
    );

    // return FutureBuilder(
    //   future: initiator,
    //   builder: (BuildContext _, AsyncSnapshot<void> snap) {
    //     switch (snap.connectionState) {
    //       case ConnectionState.waiting:
    //       case ConnectionState.none:
    //         return ViewFeedbacks.message(
    //           label: preference.of(context).aMoment,
    //         );
    //       default:
    //         return Selector<Core, CacheBible>(
    //           selector: (_, e) => e.scripturePrimary.verseSearch,
    //           builder: (BuildContext context, CacheBible o, Widget? child) {
    //             onResult();
    //             if (o.query.isEmpty) {
    //               return _resultEmptyQuery();
    //             } else if (o.result.ready) {
    //               return _resultBlock(o);
    //             } else if (o.words.isNotEmpty) {
    //               return _resultWords(o);
    //             }
    //             return child!;
    //           },
    //           child: _resultEmpty(),
    //         );
    //     }
    //   },
    // );
  }
}
