part of 'main.dart';

abstract class _State extends WidgetState<Main> {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();

  late final Future<void> initiator = core.conclusionGenerate(init: true);

  @override
  void initState() {
    arguments ??= widget.arguments;
    super.initState();
    onQuery();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = searchQuery;
    });
  }

  void onUpdate(bool status) {
    if (status) {
      // Future.microtask(() {
      //   core.conclusionGenerate().whenComplete(() {
      //     if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
      //       scrollController.animateTo(
      //         scrollController.position.minScrollExtent,
      //         curve: Curves.fastOutSlowIn,
      //         duration: const Duration(milliseconds: 500),
      //       );
      //     }
      //   });
      // });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      onQuery();
    }
  }

  void onSuggest() {
    args?.currentState!.pushNamed('/search-suggest', arguments: false).then((word) {
      onUpdate(word != null);
    });
  }

  void onNav(int book, int chapter) {
    // debugPrint('TODO: book $book chapter $chapter');
    // NotifyNavigationButton.navigation.value = 1;
    core.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      core.navigate(at: 1);
    });
  }

  BIBLE get bible => core.scripturePrimary.verseSearch;
  bool get shrinkResult => bible.verseCount > 300;
  String get searchQueryCurrent => collection.suggestQuery.asString;
}
