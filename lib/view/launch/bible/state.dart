part of 'main.dart';

abstract class _State extends WidgetState with SingleTickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();
  // late final param = args?.param<ViewNavigationArguments>();
  late final param = args?.param<String>();

  // late final _kList = GlobalKey<SliverReorderableListState>();

  late final AnimationController dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> dragAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(dragController);
  late final Animation<Color?> colorAnimation = ColorTween(
    begin: null,
    end: Theme.of(context).errorColor,
  ).animate(dragController);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dragController.dispose();
    super.dispose();
  }

  bool canPop() {
    return hasArguments || Navigator.of(context).canPop();
  }

  void Function()? maybePop() {
    if (hasArguments) {
      return args?.currentState!.maybePop;
    } else if (Navigator.of(context).canPop()) {
      // Came from root
      return Navigator.of(context).maybePop;
    }
    return null;
  }

  void onSort() {
    if (dragController.isCompleted) {
      dragController.reverse();
    } else {
      dragController.forward();
    }
  }

  void toBible(int index, BooksType bible) async {
    // bible.selected = !bible.selected;
    // core.collection.boxOfBook.putAt(index, bible);

    // if (Navigator.canPop(context)) {
    //   if (core.collection.parallelId != bible.identify) {
    //     core.collection.parallelId = bible.identify;
    //     core.notify();
    //   }
    //   if (!core.scripturePrimary.isReady) {
    //     core.message = 'a momment please';
    //   }
    //   core.navigate(at: 1);
    //   core.scriptureParallel.init().whenComplete(() {
    //     core.message = '';
    //   });
    //   Navigator.of(context).pop();
    // } else {
    //   if (core.collection.primaryId != bible.identify) {
    //     core.collection.primaryId = bible.identify;
    //     core.notify();
    //   }
    //   if (!core.scripturePrimary.isReady) {
    //     core.message = 'a momment please';
    //   }
    //   core.navigate(at: 1);
    //   core.scripturePrimary.init().whenComplete(() {
    //     core.message = '';
    //   });
    // }
    // widget.arguments == nul
    // if (widget.arguments == null) {
    //   if (collection.parallelId != bible.identify) {
    //     collection.parallelId = bible.identify;
    //     core.notify();
    //   }
    //   if (!core.scripturePrimary.isReady) {
    //     core.message = preference.text.aMoment;
    //   }
    //   core.navigate(at: 1);
    //   core.scriptureParallel.init().whenComplete(() {
    //     core.message = '';
    //   });
    //   Navigator.of(context).pop();
    // } else {
    //   bible.selected = !bible.selected;
    //   collection.boxOfBook.putAt(index, bible);
    // }
    if (hasArguments) {
      bible.selected = !bible.selected;
      collection.boxOfBooks.box.putAt(index, bible);
    } else {
      debugPrint('from:${collection.parallelId} to:${bible.identify}');
      // if (collection.parallelId != bible.identify) {
      //   collection.parallelId = bible.identify;
      //   core.notify();
      // }
      // if (!core.scripturePrimary.isReady) {
      //   core.message = preference.text.aMoment;
      // }
      // core.navigate(at: 1);
      // core.scriptureParallel.init().whenComplete(() {
      //   core.message = '';
      // });
      // Navigator.of(context).pop();

      if (collection.parallelId != bible.identify) {
        collection.parallelId = bible.identify;
      }
      if (!core.scriptureParallel.isReady) {
        core.message = preference.text.aMoment;
      }
      // core.navigate(at: 1);
      Navigator.of(context).pop();
      Future.microtask(() {
        core.scriptureParallel.init().then((value) {
          if (core.message.isNotEmpty) {
            core.message = '';
          } else {
            core.notify();
          }
        });
      });
    }
    // Scripture scripture = core.scripturePrimary;
    // if (scripture.isReady) {
    //   if (core.message.isNotEmpty){
    //     core.message ='';
    //   }
    // } else {
    //   core.message ='a momment plase';
    // }
    // if (core.collection.primaryId != bible.identify){
    //   core.collection.primaryId = bible.identify;
    // }
    // debugPrint('reader: ${core.scripturePrimary.isReady}');
    // core.scripturePrimary.init().catchError((e){
    //   debugPrint('scripturePrimary: $e');
    // }).whenComplete(
    //   (){
    //     core.message ='';
    //     debugPrint('reader: done');
    //   }
    // );
  }

  Future showOptions(BooksType book) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      // builder: (BuildContext context) => _ModalSheet(book: book, core: core),
      builder: (BuildContext context) => WidgetDraggableInfoModal(book: book),
      // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
      // barrierColor: Theme.of(context).shadowColor.withOpacity(0.7),
      // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
      // barrierColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
