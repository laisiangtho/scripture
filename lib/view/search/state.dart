part of 'main.dart';

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  // late final _controller = ScrollController();

  late final _formKey = GlobalKey<FormState>();
  late final _textController = TextEditingController();
  late final _focusNode = FocusNode();

  bool get autoFocus {
    return args.isNotEmpty && args['focus'] != null;
  }

  late final AnimationController _clearController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  ); //..repeat();
  // late final Animation<double> _clearAnimation = CurvedAnimation(
  //   parent: _clearController,
  //   curve: Curves.fastOutSlowIn,
  // );
  late final AnimationController _backController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );
  late final AnimationController _cancelController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  // late final Future<void> initiator = core.conclusionGenerate();

  // bool get canPop => state.navigator.canPop();
  bool get canPop => Navigator.of(context).canPop();

  final ValueNotifier<bool> _focusNotifier = ValueNotifier(false);

  String get searchQuery => data.searchQuery;
  set searchQuery(String ord) {
    data.searchQuery = ord;
  }

  String get suggestQuery => data.suggestQuery;
  set suggestQuery(String ord) {
    data.suggestQuery = ord;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _cancelController.forward();
        if (canPop) {
          _backController.reverse();
        }
        onSuggest(searchQuery);
      } else {
        _cancelController.reverse();

        if (canPop) {
          _backController.forward();
        }
      }
      _focusNotifier.value = _focusNode.hasFocus;
    });

    _textController.addListener(() {
      if (_textController.text.isNotEmpty) {
        _clearController.forward();
      } else {
        _clearController.reverse();
      }
    });

    // _controller.addListener(() {
    //   // if (_focusNode.hasFocus) {
    //   //   _focusNode.unfocus();
    //   // }
    // });

    Future.microtask(() {
      if (canPop) {
        _backController.forward();
      }
    });

    Future.microtask(() {
      if (args.isNotEmpty && args['keyword'] != null) {
        onQuery(args['keyword'] as String);
      } else {
        onQuery(searchQuery);
      }
    }).whenComplete(() {
      if (_focusNode.canRequestFocus && autoFocus) {
        _focusNode.requestFocus();
      }
    });

    data.boxOfSettings.watch(key: 'searchQuery').listen((e) {
      if (e.value != null) {
        String str = e.value.toString();
        _textController.text = str;
        if (suggestQuery != str) {
          suggestQuery = str;
        }
      }
    });
    data.boxOfSettings.watch(key: 'suggestQuery').listen((e) {
      if (e.value != null) {
        String str = e.value.toString();
        _textController.text = str;
      }
    });
  }

  void onClear() {
    _textController.clear();
    suggestQuery = '';
    // Future.microtask(() {
    //   App.core.suggestionGenerate();
    // });
  }

  void onCancel() {
    _focusNode.unfocus();
    // _focusNode.addListener(() { })
    Future.delayed(Duration(milliseconds: _focusNode.hasPrimaryFocus ? 200 : 0), () {
      suggestQuery = searchQuery;
      _textController.text = suggestQuery;
    });
  }

  void onQuery(String str) {
    if (_textController.text != str) {
      _textController.text = str;
      if (searchQuery != str) {
        searchQuery = str;
      }
    }
  }

  void onSuggest(String str) {
    suggestQuery = str;

    // on recentHistory select
    if (_textController.text != str) {
      _textController.text = str;
      if (_focusNode.hasFocus == false) {
        Future.delayed(const Duration(milliseconds: 400), () {
          _focusNode.requestFocus();
        });
      }
    }
    Future.microtask(() {
      App.core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    suggestQuery = str;
    searchQuery = suggestQuery;
    // Future.microtask(() {});
    // Navigator.of(context).pop(true);

    // Future.delayed(Duration(milliseconds: _focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    //   // _parent.navigator.currentState!.pop(true);
    //   // navigator.currentState!.pushReplacementNamed('/search-result', arguments: _arguments);
    //   // navigator.currentState!.popAndPushNamed('/search-result', arguments: _arguments);
    // });

    App.core.conclusionGenerate();

    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    // _controller.animateTo(
    //   _controller.position.minScrollExtent,
    //   curve: Curves.fastOutSlowIn,
    //   duration: const Duration(milliseconds: 800),
    // );
    // Future.delayed(Duration.zero, () {
    //   collection.historyUpdate(searchQuery);
    // });
  }

  // void toRead(int book, int chapter) {
  //   core.chapterChange(bookId: book, chapterId: chapter).whenComplete(() {
  //     route.pushNamed('read');
  //   });
  // }
}
