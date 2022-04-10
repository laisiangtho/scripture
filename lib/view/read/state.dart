part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  // final keySheet = GlobalKey();
  final kBookButton = GlobalKey();
  final kChapterButton = GlobalKey();
  final kOptionButton = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    collection.boxOfSettings.fontSizeModify(increase);
  }

  // List<int> verseSelectionList = [];
  // late final verseSelectionList = core.verseSelectionWorking;
  // verseSelection verseSelectionList
  // void verseSelection(int id) {
  //   // debugPrint('selectVerse from it parent $id');
  //   int index = core.verseSelectionWorking.indexWhere((i) => i == id);
  //   if (index >= 0) {
  //     core.verseSelectionWorking.removeAt(index);
  //   } else {
  //     core.verseSelectionWorking.add(id);
  //   }
  //   core.notify();
  //   // setState(() {});
  // }

  void verseSelectionCopy() {
    List<String> list = [];
    String subject = tmpbook.name + ' ' + tmpchapter.name;
    list.add(subject);
    core.scripturePrimary.verseSelection.value
      ..sort((a, b) => a.compareTo(b))
      ..forEach((id) {
        VERSE o = tmpverse.where((i) => i.id == id).single;
        list.add(o.name + ': ' + o.text);
      });
    // Clipboard.setData(new ClipboardData(text: list.join("\n"))).whenComplete(() {
    //   showSnack('Copied to Clipboard');
    // });
    Share.share(list.join("\n"), subject: subject);
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
        return 0.0;
      });
      if (offsetList.isNotEmpty) {
        scrollTo = offsetList.reduce((a, b) => a + b) + 17;
      }
      scrollToPosition(scrollTo);
    }
  }

  // void setBookMark() {
  //   scrollToIndex(17, isId: true);
  // }
}
