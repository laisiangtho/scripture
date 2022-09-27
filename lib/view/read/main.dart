import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/share.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'state.dart';
part 'sheet.dart';
part 'sheet_parallel.dart';
part 'optionlist.dart';
part 'booklist.dart';
part 'chapterlist.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;

  static const route = '/read';
  static const icon = LideaIcon.bookOpen;
  static const name = 'Read';
  static const description = 'Read';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ViewPage(
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
      bottomNavigationBar: _SheetWidget(
        key: const Key('read-options'),
        nextChapter: setChapterNext,
        previousChapter: setChapterPrevious,
        scrollToIndex: scrollToIndex,
        verseSelectionCopy: verseSelectionCopy,
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight - 20, 20],
        overlapsBorderColor: Theme.of(context).shadowColor,
        backgroundColor: Theme.of(context).primaryColor,
        // overlapsBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: bar,
      ),
      SliverToBoxAdapter(
        child: Selector<Core, String>(
          selector: (_, e) => e.message,
          builder: (BuildContext context, String message, Widget? child) {
            if (message.isEmpty) return child!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('...$message'),
              ),
            );
          },
          child: const SizedBox(),
        ),
      ),
      // SliverToBoxAdapter(
      //   child: GestureDetector(
      //     child: Selector<Core, BIBLE>(
      //       selector: (_, e) => e.scripturePrimary.verseChapter,
      //       builder: (BuildContext _a, BIBLE _b, Widget? _c) {
      //         return ListView.builder(
      //           shrinkWrap: true,
      //           primary: true,
      //           padding: EdgeInsets.zero,
      //           physics: const NeverScrollableScrollPhysics(),
      //           itemBuilder: (_c, index) {
      //             return FutureBuilder(
      //               future: Future.delayed(const Duration(milliseconds: 300), () => true),
      //               builder: (_, snap) {
      //                 if (snap.hasData == false) return const VerseWidgetHolder();
      //                 return _inheritedVerse(tmpverse[index]);
      //               },
      //             );
      //           },
      //           itemCount: tmpverse.length,
      //         );
      //       },
      //     ),
      //   ),
      // ),
      StreamBuilder(
        initialData: collection.boxOfSettings.fontSize(),
        stream: collection.boxOfSettings.watch(key: 'fontSize'),
        builder: (BuildContext _, e) {
          return WidgetChildBuilder(
            child: Selector<Core, BIBLE>(
              selector: (_, e) => e.scripturePrimary.verseChapter,
              builder: (BuildContext _, BIBLE __, Widget? ___) {
                return WidgetListBuilder(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  duration: const Duration(milliseconds: 300),
                  itemBuilder: (BuildContext _, int index) {
                    return _inheritedVerse(tmpverse[index]);
                  },
                  itemSnap: (BuildContext _, int index) {
                    return const VerseWidgetHolder();
                  },
                  itemCount: tmpverse.length,
                );
              },
            ),
          );
        },
      ),
      // SliverToBoxAdapter(
      //   child: Selector<Core, BIBLE>(
      //     selector: (_, e) => e.scripturePrimary.verseChapter,
      //     builder: (BuildContext _a, BIBLE _b, Widget? _c) {
      //       return ListView.builder(
      //         shrinkWrap: true,
      //         primary: true,
      //         padding: EdgeInsets.zero,
      //         physics: const NeverScrollableScrollPhysics(),
      //         itemBuilder: (_c, index) {
      //           return FutureBuilder(
      //             future: Future.delayed(const Duration(milliseconds: 300), () => true),
      //             builder: (_, snap) {
      //               if (snap.hasData == false) return const VerseWidgetHolder();
      //               return _inheritedVerse(tmpverse[index]);
      //             },
      //           );
      //         },
      //         itemCount: tmpverse.length,
      //       );
      //     },
      //   ),
      // ),
    ];
  }

  Widget _inheritedVerse(VERSE verse) {
    // core.scripturePrimary.info.langDirection
    // return Selector<Core, String>(
    //   selector: (_, e) => e.testQuery,
    //   builder: (BuildContext _a, String list, Widget? _c) {
    //     debugPrint('??? _inheritedVerse $list');
    //     return VerseWidgetInherited(
    //       key: verse.key,
    //       size: core.collection.fontSize,
    //       lang: core.scripturePrimary.info.langCode,
    //       // selected: list.indexWhere((id) => id == verse.id) >= 0,
    //       child: WidgetVerse(
    //         verse: verse,
    //         // onPressed: core.verseSelectionWithNotify,
    //         onPressed: (int id) {
    //           core.testQuery = id.toString();
    //         },
    //       ),
    //     );
    //   },
    // );
    // final asdf = Hive.box('settings').listenable(keys: ['firstKey', 'secondKey']);

    // final efee = collection.boxOfSettings.listen(keys: ['fontSize']);
    // final efee = collection.boxOfSettings.listen(keys: ['fontSize']).value.values.first.asDouble;
    // final efee = collection.boxOfSettings.listen(keys: ['fontSize']).value.values.first;
    // final effee = collection.boxOfSettings.box.watch(key: 'fontSize').first.;
    // ValueListenableBuilder(
    //   valueListenable: collection.boxOfSettings.box.,
    //   builder: (context, value, _) {
    //     return const SizedBox();
    //   },
    // );
    // final child = ValueListenableBuilder<List<int>>(
    //   valueListenable: core.scripturePrimary.count,
    //   builder: (context, value, _) {
    //     debugPrint('??? _inheritedVerse $value');
    //     return VerseWidgetInherited(
    //       key: verse.key,
    //       size: collection.boxOfSettings.fontSize().asDouble,
    //       lang: core.scripturePrimary.info.langCode,
    //       selected: value.indexWhere((id) => id == verse.id) >= 0,
    //       child: WidgetVerse(
    //         verse: verse,
    //         onPressed: (int id) {
    //           int index = value.indexWhere((i) => i == id);
    //           if (index >= 0) {
    //             // value.removeAt(index);
    //             core.scripturePrimary.count.value = List.from(value)..removeAt(index);
    //           } else {
    //             // value.add(id);
    //             core.scripturePrimary.count.value = List.from(value)..add(id);
    //           }
    //           // core.scripturePrimary.count.value = List.from(value)..add(...);
    //           // core.scripturePrimary.count = value;
    //         },
    //       ),
    //     );
    //   },
    // );

    return ValueListenableBuilder<List<int>>(
      key: verse.key,
      valueListenable: core.scripturePrimary.verseSelection,
      builder: (context, value, _) {
        return VerseWidgetInherited(
          size: collection.boxOfSettings.fontSize().asDouble,
          lang: core.scripturePrimary.info.langCode,
          selected: value.indexWhere((id) => id == verse.id) >= 0,
          child: WidgetVerse(
            verse: verse,
            onPressed: (int id) {
              int index = value.indexWhere((i) => i == id);
              if (index >= 0) {
                // value.removeAt(index);
                core.scripturePrimary.verseSelection.value = List.from(value)..removeAt(index);
              } else {
                // value.add(id);
                core.scripturePrimary.verseSelection.value = List.from(value)..add(id);
              }
              // core.scripturePrimary.count.value = List.from(value)..add(...);
              // core.scripturePrimary.count = value;
            },
          ),
        );
      },
    );
    // return ValueListenableBuilder<List<int>>(
    //   valueListenable: core.scripturePrimary.count,
    //   builder: (context, value, _) {
    //     debugPrint('??? _inheritedVerse $value');
    //     return VerseWidgetInherited(
    //       key: verse.key,
    //       size: collection.boxOfSettings.fontSize().asDouble,
    //       lang: core.scripturePrimary.info.langCode,
    //       selected: value.indexWhere((id) => id == verse.id) >= 0,
    //       child: WidgetVerse(
    //         verse: verse,
    //         onPressed: (int id) {
    //           int index = value.indexWhere((i) => i == id);
    //           if (index >= 0) {
    //             // value.removeAt(index);
    //             core.scripturePrimary.count.value = List.from(value)..removeAt(index);
    //           } else {
    //             // value.add(id);
    //             core.scripturePrimary.count.value = List.from(value)..add(id);
    //           }
    //           // core.scripturePrimary.count.value = List.from(value)..add(...);
    //           // core.scripturePrimary.count = value;
    //         },
    //       ),
    //     );
    //   },
    // );
    // return Selector<Core, List<int>>(
    //   selector: (_, e) => e.scripturePrimary.verseSelectionWorking,
    //   builder: (BuildContext _a, List<int> list, Widget? _c) {
    //     debugPrint('??? _inheritedVerse $list');
    //     return VerseWidgetInherited(
    //       key: verse.key,
    //       size: core.collection.fontSize,
    //       lang: core.scripturePrimary.info.langCode,
    //       selected: list.indexWhere((id) => id == verse.id) >= 0,
    //       child: WidgetVerse(
    //         verse: verse,
    //         onPressed: core.verseSelectionWithNotify,
    //       ),
    //     );
    //   },
    // );
    // return VerseWidgetInherited(
    //   key: verse.key,
    //   size: core.collection.fontSize,
    //   lang: core.scripturePrimary.info.langCode,
    //   selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
    //   child: WidgetVerse(
    //     verse: verse,
    //     onPressed: verseSelection,
    //   ),
    // );
  }
}
