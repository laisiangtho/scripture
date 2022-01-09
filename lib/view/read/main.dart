// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/share.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
// import 'package:lidea/authentication.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';
import '../routes.dart';

// import '/view/home/bible/main.dart' as bible_page;

part 'bar.dart';
part 'sheet.dart';
part 'sheet_parallel.dart';
part 'optionlist.dart';
part 'booklist.dart';
part 'chapterlist.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  // final SettingsController? settings;
  // final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/read';
  static const icon = LideaIcon.bookOpen;
  static const name = 'Read';
  static const description = 'Read';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  // late final SettingsController settings = context.read<SettingsController>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  late final Authentication authenticate = context.read<Authentication>();
  late final scrollController = ScrollController();

  // final keySheet = GlobalKey();
  final kBookButton = GlobalKey();
  final kChapterButton = GlobalKey();
  final kOptionButton = GlobalKey();

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // DefinitionBible get bibleInfo => core.collectionPrimary;
  BIBLE get bible => core.scripturePrimary.verseChapter;
  // BIBLE get bible => core.verseChapterData;
  // CollectionBible get tmpbible => bible?.info;
  DefinitionBook get tmpbook => bible.book.first.info;
  CHAPTER get tmpchapter => bible.book.first.chapter.first;
  List<VERSE> get tmpverse => tmpchapter.verse;

  void setChapterPrevious() {
    core.chapterPrevious.catchError((e) {
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setChapterNext() {
    core.chapterNext.catchError((e) {
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setChapter(int? id) {
    if (id == null) return;
    core.chapterChange(chapterId: id).catchError((e) {
      showSnack(e.toString());
    }).whenComplete(() {
      scrollToPosition(null);
    });
  }

  void setFontSize(bool increase) {
    double size = core.collection.fontSize;
    if (increase) {
      size++;
    } else {
      size--;
    }
    setState(() {
      core.collection.fontSize = size.clamp(7.0, 57.0);
    });
  }

  List<int> verseSelectionList = [];
  // verseSelection verseSelectionList
  void verseSelection(int id) {
    // debugPrint('selectVerse from it parent $id');
    int index = verseSelectionList.indexWhere((i) => i == id);
    if (index >= 0) {
      verseSelectionList.removeAt(index);
    } else {
      verseSelectionList.add(id);
    }
    setState(() {});
  }

  void verseSelectionCopy() {
    List<String> list = [];
    String subject = tmpbook.name + ' ' + tmpchapter.name;
    list.add(subject);
    verseSelectionList
      ..sort((a, b) => a.compareTo(b))
      ..forEach((id) {
        VERSE o = tmpverse.where((i) => i.id == id).single;
        list.add(o.name + ': ' + o.text);
      });
    // Clipboard.setData(new ClipboardData(text: list.join("\n"))).whenComplete((){
    //   showSnack('Copied to Clipboard');
    // });
    Share.share(list.join("\n"), subject: subject);
    debugPrint('share???');
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void scrollToPosition(double? pos) {
    scrollController.animateTo(
      pos ?? scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );
  }

  Future scrollToIndex(int id, {bool isId = false}) async {
    double scrollTo = 0.0;
    if (id > 0) {
      final offsetList = tmpverse.where((e) {
        return isId ? e.id < id : tmpverse.indexOf(e) < id;
      }).map<double>((e) {
        final key = e.key as GlobalKey;
        if (key.currentContext != null) {
          final render = key.currentContext!.findRenderObject() as RenderBox;
          return render.size.height;
        }
        debugPrint('${e.key}');
        return 0.0;
      });
      if (offsetList.isNotEmpty) {
        scrollTo = offsetList.reduce((a, b) => a + b) + scrollTo;
      }
    }

    scrollToPosition(scrollTo);
  }

  void setBookMark() {
    scrollToIndex(17, isId: true);
  }
}

class _View extends _State with _Bar, _Sheet {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        key: widget.key,
        controller: scrollController,
        child: body(),
      ),
      bottomNavigationBar: showSheet(),
      // bottomSheet: showSheet(),
      // floatingActionButton: showSheet(),
      // persistentFooterButtons: [
      //   TextButton(
      //     onPressed: () {},
      //     child: const Text('abc'),
      //   )
      // ],
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: DecoratedBox(
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).scaffoldBackgroundColor,
      //     borderRadius: const BorderRadius.all(
      //       Radius.circular(100),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         blurRadius: 0.2,
      //         color: Theme.of(context).shadowColor,
      //         spreadRadius: 0.1,
      //         offset: const Offset(0, 0),
      //       )
      //     ],
      //   ),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       CupertinoButton(
      //         padding: EdgeInsets.zero,
      //         minSize: 30,
      //         child: const Icon(LideaIcon.chapterPrevious),
      //         onPressed: () {},
      //       ),
      //       if (verseSelectionList.isNotEmpty)
      //         CupertinoButton(
      //           padding: EdgeInsets.zero,
      //           minSize: 30,
      //           borderRadius: const BorderRadius.all(
      //             Radius.circular(2),
      //           ),
      //           child: const Icon(Icons.copy),
      //           onPressed: () {},
      //         ),
      //       CupertinoButton(
      //         // color: Colors.red,
      //         padding: EdgeInsets.zero,
      //         minSize: 30,
      //         borderRadius: const BorderRadius.all(
      //           Radius.circular(2),
      //         ),
      //         child: const Icon(LideaIcon.language),
      //         onPressed: () {},
      //       ),
      //       CupertinoButton(
      //         padding: EdgeInsets.zero,
      //         minSize: 30,
      //         child: const Icon(LideaIcon.chapterNext),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            bar(),
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
            SliverToBoxAdapter(
              child: GestureDetector(
                child: Selector<Core, BIBLE>(
                  selector: (_, e) => e.scripturePrimary.verseChapter,
                  builder: (BuildContext _a, BIBLE _b, Widget? _c) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_c, index) {
                        return FutureBuilder(
                          future: Future.delayed(const Duration(milliseconds: 300), () => true),
                          builder: (_, snap) {
                            if (snap.hasData == false) return const VerseWidgetHolder();
                            return _inheritedVerse(tmpverse[index]);
                          },
                        );
                      },
                      itemCount: tmpverse.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inheritedVerse(VERSE verse) {
    // core.scripturePrimary.info.langDirection
    return VerseWidgetInherited(
      key: verse.key,
      size: core.collection.fontSize,
      lang: core.scripturePrimary.info.langCode,
      selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
      child: WidgetVerse(
        verse: verse,
        onPressed: verseSelection,
      ),
    );
  }
}
