part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _kBookmarks = GlobalKey();
  final _kBooks = GlobalKey();
  final _kChapters = GlobalKey();
  final _kOptions = GlobalKey();

  @override
  void initState() {
    super.initState();
    primaryScripture.scroll = _controller;

    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   App.core.message.value = 'Testing';
    //   Future.delayed(const Duration(milliseconds: 1000), () {
    //     App.core.message.value = '';
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   primaryScripture.scroll = _controller;
  // }

  Scripture get primaryScripture => core.scripturePrimary;
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  void showBookmarks() {
    core.switchBookmarkWithNotify();
  }

  void showBooks() {
    route
        .showSheetModal(
      context: context,
      name: 'sheet-bible-navigation/leaf-book',
    )
        .then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        });
      }
    });
  }

  void showChapters() {
    route.showSheetModal(
      context: context,
      name: 'sheet-bible-navigation/leaf-book',
      arguments: {'book': primaryScripture.bookCurrent.info.id},
    ).then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        });
      }
    });
  }

  void showOptions() {
    Navigator.of(context)
        .push(
          PageRouteBuilder<int>(
            settings: RouteSettings(
              arguments: {
                'render': _kOptions.currentContext!.findRenderObject() as RenderBox,
                // 'setFontSize': setFontSize,
                // 'test': 'hello world',
              },
            ),
            opaque: false,
            barrierDismissible: true,
            transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
              return FadeTransition(
                opacity: x,
                child: child,
              );
            },
            pageBuilder: (_, __, ___) {
              return App.route.show('pop-options').child;
            },
          ),
        )
        .then((value) {});
  }
}
