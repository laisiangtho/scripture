part of 'main.dart';

abstract class _State extends StateAbstract<Main> with SingleTickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();

  late final boxOfBooks = data.boxOfBooks;

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

  // @override
  // void initState() {
  //   super.initState();
  // }

  void onSort() {
    // boxOfBooks.box.add(
    //   BooksType(
    //     identify: data.randomString(5),
    //     name: data.randomString(15),
    //     shortname: data.randomString(3),
    //     year: 2000,
    //     langCode: 'EN',
    //     langName: 'English',
    //   ),
    // );
    if (_dragController.isCompleted) {
      _dragController.reverse();
    } else {
      _dragController.forward();
    }
  }

  void showBibleContent(BooksType bible, int index) async {
    // state.hasArguments;
    if (state.hasArguments) {
      debugPrint('from:${data.parallelId} to:${bible.identify}');

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

  Future showBibleInfo(BooksType book) {
    // return showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   useRootNavigator: true,
    //   // builder: (BuildContext context) => _ModalSheet(book: book, core: core),
    //   builder: (BuildContext context) => WidgetDraggableInfoModal(book: book),
    //   // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).shadowColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).scaffoldBackgroundColor,
    // );
    return route.showSheetModal(context: context, name: 'sheet-bible', arguments: book);
  }
}
