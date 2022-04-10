part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      message: preference.text.confirmToDelete('all'),
      title: preference.text.confirmation,
      cancel: preference.text.cancel,
      confirm: preference.text.confirm,
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          // collection.boxOfBookmark.clear().whenComplete(core.notify);
          core.clearBookmarkWithNotify();
        });
      }
    });
  }

  void onSearch(String word) {}

  void onNav(int book, int chapter) {
    // NotifyNavigationButton.navigation.value = 1;
    core.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      // core.definitionGenerate(word);
      core.navigate(at: 1);
    });
    // Future.delayed(Duration.zero, () {
    //   core.historyAdd(word);
    // });
  }

  Future<bool> onDelete(int index) {
    // Future.microtask((){});
    // Future.delayed(Duration.zero, () {
    // });
    // Do you want to delete this Bookmark?
    // Do you want to delete all the Bookmarks?
    return doConfirmWithDialog(
      context: context,
      // message: 'Do you want to delete this Bookmark?',
      message: preference.text.confirmToDelete(''),
      title: preference.text.confirmation,
      cancel: preference.text.cancel,
      confirm: preference.text.confirm,
    ).then((confirmation) {
      if (confirmation != null && confirmation) {
        core.deleteBookmarkWithNotify(index);
        return true;
      }
      return false;
    });
  }
}
