part of 'main.dart';

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  late final Scripture scripturePrimary = core.scripturePrimary;

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
        core.message.value = App.preference.text.aMoment;
      }
    }

    route.pushNamed('read');
    scripturePrimary.init().whenComplete(() {
      if (core.message.value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          core.message.value = '';
        });
      }
    });
  }

  Future showBibleInfo(MapEntry<dynamic, BooksType> book) {
    return route.showSheetModal(
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
