part of 'main.dart';

abstract class _State extends CommonStates<Main> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  late final Scripture scripturePrimary = app.scripturePrimary;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void showBibleContent(BooksType bible) async {
    if (data.primaryId != bible.identify) {
      data.primaryId = bible.identify;
      if (!scripturePrimary.isReady) {
        app.message.value = lang.aMoment;
      }
    }

    app.route.page.go('/read');
    scripturePrimary.init().whenComplete(() {
      if (app.message.value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          app.message.value = '';
        });
      }
    });
  }

  Future<T?> showBibleInfo<T>(BooksType book) {
    return context.push<T>('/sheet-bible-info', extra: book);
  }

  void onSearch(RecentSearchType item) {
    context.go('/search', extra: {'keyword': item.word});
  }
}
