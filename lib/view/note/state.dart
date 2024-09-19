part of 'main.dart';

abstract class _State extends CommonStates<Main> {
  late final ScrollController scrollController = ScrollController();
  late final ValueNotifier<double> _itemFavoriteBackgroundNotifier = ValueNotifier(0.0);

  late final BoxOfBookmarks<BookmarksType> boxOfBookmarks = app.data.boxOfBookmarks;

  // @override
  // void initState() {
  //   super.initState();
  // }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      message: app.preference.of(context).confirmToDelete('all'),
      title: app.preference.of(context).confirmation,
      cancel: app.preference.of(context).cancel,
      confirm: app.preference.of(context).confirm,
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          // collection.boxOfBookmark.clear().whenComplete(core.notify);
          // App.core.clearBookmarkWithNotify();
          boxOfBookmarks.clearAll();
        });
      }
    });
  }

  Future<bool?> onDelete(dynamic key) {
    return boxOfBookmarks.deleteAtKey(key);
  }

  // Future<bool> onDelete(int index) {
  //   // Future.microtask((){});
  //   // Future.delayed(Duration.zero, () {
  //   // });
  //   // Do you want to delete this Bookmark?
  //   // Do you want to delete all the Bookmarks?
  //   return doConfirmWithDialog(
  //     context: context,
  //     // message: 'Do you want to delete this Bookmark?',
  //     message: app.preference.of(context).confirmToDelete(''),
  //     title: app.preference.of(context).confirmation,
  //     cancel: app.preference.of(context).cancel,
  //     confirm: app.preference.of(context).confirm,
  //   ).then((confirmation) {
  //     if (confirmation != null && confirmation) {
  //       core.deleteBookmarkWithNotify(index);
  //       return true;
  //     }
  //     return false;
  //   });
  // }

  void onNav(int book, int chapter) {
    // NotifyNavigationButton.navigation.value = 1;
    app.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      // core.definitionGenerate(word);

      app.route.page.go('/read');
    });
    // Future.delayed(Duration.zero, () {
    //   core.historyAdd(word);
    // });
  }
}
