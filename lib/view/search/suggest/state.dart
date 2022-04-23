part of 'main.dart';

abstract class _State extends WidgetState<Main> with TickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final AnimationController clearController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  ); //..repeat();
  late final Animation<double> clearAnimation = CurvedAnimation(
    parent: clearController,
    curve: Curves.fastOutSlowIn,
  );
  // late final Animation<double> clearAnimation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(clearController);
  // late final Animation clearAnimations = ColorTween(
  //   begin: Colors.red, end: Colors.green
  // ).animate(clearController);

  @override
  void initState() {
    arguments ??= widget.arguments;
    super.initState();

    onQuery();

    focusNode.addListener(() {
      Future.microtask(() {
        toggleClear(focusNode.hasFocus && textController.text.isNotEmpty);
      });
    });

    scrollController.addListener(() {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    });

    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();

    textController.addListener(() {
      toggleClear(textController.text.isNotEmpty);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    clearController.dispose();
    super.dispose();
  }

  void onQuery() {
    Future.microtask(() {
      textController.text = searchQuery;
    });
  }

  void onClear() {
    textController.clear();
    suggestQuery = '';
    core.suggestionGenerate();
  }

  void toggleClear(bool show) {
    if (show) {
      clearController.forward();
    } else {
      clearController.reverse();
    }
  }

  void onCancel() {
    focusNode.unfocus();
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      suggestQuery = searchQuery;
      textController.text = suggestQuery;
      Navigator.of(context).pop(false);
      // navigator.currentState!.maybePop();
      // Navigator.of(context).maybePop(false);
    });
  }

  void onSuggest(String str) {
    suggestQuery = str;
    // on recentHistory select
    if (textController.text != str) {
      textController.text = str;
      if (focusNode.hasFocus == false) {
        Future.delayed(const Duration(milliseconds: 400), () {
          focusNode.requestFocus();
        });
      }
    }
    Future.microtask(() {
      core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    suggestQuery = str;
    searchQuery = suggestQuery;
    // Future.microtask(() {});
    // Navigator.of(context).pop(true);

    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      Navigator.of(context).pop(true);
      // _parent.navigator.currentState!.pop(true);
      // navigator.currentState!.pushReplacementNamed('/search-result', arguments: _arguments);
      // navigator.currentState!.popAndPushNamed('/search-result', arguments: _arguments);
    });

    core.conclusionGenerate();

    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    // scrollController.animateTo(
    //   scrollController.position.minScrollExtent,
    //   curve: Curves.fastOutSlowIn, duration: const Duration(milliseconds: 800)
    // );
    // Future.delayed(Duration.zero, () {
    //   collection.historyUpdate(searchQuery);
    // });
  }

  bool onDelete(String str) => collection.boxOfRecentSearch.delete(str);

  BIBLE get bible => core.scripturePrimary.verseSearch;
  bool get shrinkResult => bible.verseCount > 300;
}
