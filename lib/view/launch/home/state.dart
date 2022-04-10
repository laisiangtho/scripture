part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toBible(BooksType bible) async {
    if (collection.primaryId != bible.identify) {
      collection.primaryId = bible.identify;
      core.message = preference.text.aMoment;
    }
    core.navigate(at: 1);
    core.scripturePrimary.init().whenComplete(() {
      if (core.message.isNotEmpty) {
        core.message = '';
      }
    });
    /*
    if (Navigator.canPop(context)) {
      if (core.collection.parallelId != bible.identify) {
        core.collection.parallelId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message = 'a momment please';
      }
      core.navigate(at: 1);
      core.scriptureParallel.init().whenComplete(() {
        core.message = '';
      });
      Navigator.of(context).pop();
    } else {


      if (core.collection.primaryId != bible.identify) {
        core.collection.primaryId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message = 'a momment please';
      }
      core.navigate(at: 1);
      core.scripturePrimary.init().whenComplete(() {
        core.message = '';
        // core.notify();
      });

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
    */
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
