part of 'main.dart';

abstract class _State extends StateAbstract<Main> with SingleTickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();

  late final boxOfBooks = data.boxOfBooks;
  late final iso = core.iso;

  late Box<BooksType> setOfBook;
  late Set<String> setOfLang;

  late final AnimationController _dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> _dragAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_dragController);
  late final Animation<Color?> _colorAnimation = ColorTween(
    begin: null,
    end: Theme.of(context).colorScheme.error,
  ).animate(_dragController);

  @override
  void initState() {
    super.initState();
    setOfBook = boxOfBooks.box;
    _addISO(setOfBook);

    boxOfBooks.watch().listen((event) {
      setOfBook = boxOfBooks.box;
      _addISO(setOfBook);
    });
  }

  void _addISO(Box<BooksType> setOfBook) {
    final setOfLang = setOfBook.values.map((e) => e.langCode).toSet();
    if (setOfLang.length != iso.all.length) {
      iso.all.clear();

      for (var e in setOfBook.values) {
        // final obj = setOfBook.values.firstWhere((e) => e.langCode == e.langCode);
        iso.insert(
          ISOModel(
            code: e.langCode,
            text: e.langName,
            shortname: e.shortname,
            direction: e.langDirection,
          ),
        );
      }
    }
  }

  /// booksFiltered userBooks userLangs
  List<MapEntry<dynamic, BooksType>> get booksFilter {
    // return boxOfBooks.entries.where(
    //   (e) {
    //     return iso.all
    //         .firstWhere(
    //           (element) => element.code == e.value.langCode,
    //           orElse: () => iso.all.first,
    //         )
    //         .show;
    //   },
    // ).toList();
    return boxOfBooks.entries.toList();
  }

  void onSort() {
    if (_dragController.isCompleted) {
      _dragController.reverse();
    } else {
      _dragController.forward();
    }
  }

  void showBibleContent(BooksType bible, int index) async {
    if (state.asMap.isNotEmpty) {
      // debugPrint('from:${data.parallelId} to:${bible.identify}');

      if (data.parallelId != bible.identify) {
        data.parallelId = bible.identify;
      }
      // if (!core.scriptureParallel.isReady) {
      //   core.message.value = App.preference.text.aMoment;
      // }

      // Navigator.of(context).pop();
      state.navigator.maybePop();

      Future.microtask(() {
        core.scriptureParallel.init().then((value) {
          if (core.message.value.isNotEmpty) {
            core.message.value = '';
          } else {
            core.notify();
          }
        });
      });
    } else {
      bible.selected = !bible.selected;
      boxOfBooks.box.putAt(index, bible);
    }
  }

  void tmp() {}

  Future showBibleInfo(MapEntry<dynamic, BooksType> book) {
    return route.showSheetModal(context: context, name: 'sheet-bible-info', arguments: book);
  }

  Future showBibleLang() {
    return route.showSheetModal(context: context, name: 'sheet-bible-lang');
  }
}
