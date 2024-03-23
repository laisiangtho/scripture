part of 'main.dart';

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void showBibleContent(BooksType bible) async {
    if (App.core.data.primaryId != bible.identify) {
      App.core.data.primaryId = bible.identify;
      App.core.message.value = App.preference.text.aMoment;
    }

    App.route.pushNamed('read');
    App.core.scripturePrimary.init().whenComplete(() {
      if (App.core.message.value.isNotEmpty) {
        App.core.message.value = '';
      }
    });
  }

  // Future showBibleInfo(BooksType book) {
  //   return App.route.showSheetModal(
  //     context: context,
  //     name: 'sheet-bible',
  //     arguments: book,
  //   );
  // }
  Future showBibleInfo(BooksType book) {
    return App.route.showSheetModal(
      context: context,
      name: 'sheet-bible',
      arguments: book,
    );
  }
}
