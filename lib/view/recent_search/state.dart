part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  late final boxOfRecentSearch = App.core.data.boxOfRecentSearch;

  @override
  void initState() {
    super.initState();
  }

  void onSearch(String ord) {}
  Future<bool?> onDelete(String ord) async {
    return boxOfRecentSearch.delete(ord);
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      message: App.preference.text.confirmToDelete('all'),
      title: App.preference.text.confirmation,
      cancel: App.preference.text.cancel,
      confirm: App.preference.text.confirm,
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          // App.core.clearBookmarkWithNotify();
          boxOfRecentSearch.clearAll();
        });
      }
    });
  }
}
