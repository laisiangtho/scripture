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
      if (!App.core.scripturePrimary.isReady) {
        App.core.message.value = App.preference.text.aMoment;
      }
    }

    App.route.pushNamed('read');
    App.core.scripturePrimary.init().whenComplete(() {
      if (App.core.message.value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          App.core.message.value = '';
        });
      }
    });
  }

  Future showBibleInfo(MapEntry<dynamic, BooksType> book) {
    return App.route.showSheetModal(
      context: context,
      name: 'sheet-bible-info',
      arguments: book,
      // isScrollControlled: true,
      // constraints: const BoxConstraints(
      //   maxHeight: double.infinity,
      // ),
    );
  }
}
