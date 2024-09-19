part of 'main.dart';

abstract class _State extends CommonStates<Main> with SingleTickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();

  late final boxOfBooks = data.boxOfBooks;
  late final iso = app.iso;

  late Box<BooksType> items;

  late final AnimationController _dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  late final Animation<Color?> _colorAnimation = ColorTween(
    begin: null,
    end: colorScheme.error,
  ).animate(_dragController);

  @override
  void initState() {
    super.initState();
    _addISO();

    boxOfBooks.watch().listen((event) {
      _addISO();
    });
  }

  void _addISO() {
    final setOfBook = boxOfBooks.box.values;
    final setOfLang = setOfBook.map((e) => e.langCode).toSet();
    if (setOfLang.length != iso.all.length) {
      iso.all.clear();

      for (var e in setOfBook) {
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

  // /// booksFiltered userBooks userLangs
  // List<MapEntry<dynamic, BooksType>> get booksFilter {
  //   // return boxOfBooks.entries.where(
  //   //   (e) {
  //   //     return iso.all
  //   //         .firstWhere(
  //   //           (element) => element.code == e.value.langCode,
  //   //           orElse: () => iso.all.first,
  //   //         )
  //   //         .show;
  //   //   },
  //   // ).toList();
  //   return boxOfBooks.entries.toList();
  // }

  void onSort() {
    if (_dragController.isCompleted) {
      _dragController.reverse();
    } else {
      _dragController.forward();
    }
  }

  void showBibleContent(BooksType bible, int index) async {
    if (state.param.map.isNotEmpty) {
      // debugPrint('from:${data.parallelId} to:${bible.identify}');

      if (data.parallelId != bible.identify) {
        data.parallelId = bible.identify;
      }
      // if (!core.scriptureParallel.isReady) {
      //   core.message.value = App.preference.text.aMoment;
      // }

      // Navigator.of(context).pop();
      // state.navigator.maybePop();
      Navigator.of(context).maybePop();

      Future.microtask(() {
        app.scriptureParallel.init().then((value) {
          if (app.message.value.isNotEmpty) {
            app.message.value = '';
          } else {
            app.state.notify();
          }
        });
      });
    } else {
      bible.selected = !bible.selected;
      boxOfBooks.box.putAt(index, bible);
    }
  }

  Future<T?> showBibleInfo<T>(BooksType book) {
    return context.push<T>('/sheet-bible-info', extra: book);
  }
  // Future<T?> showBibleInfo<T>(MapEntry<dynamic, BooksType> book) {
  //   return context.push<T>('/sheet-bible-info', extra: book);
  // }

  Future<T?> showLangFilter<T>() {
    return context.push<T>('/sheet-bible-lang');
  }
}
