part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController scrollController = ScrollController();
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
    primaryScripture.scroll = scrollController;

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
    scrollController.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   primaryScripture.scroll = scrollController;
  // }

  Scripture get primaryScripture => app.scripturePrimary;
  List<OfVerse> get primaryVerse => primaryScripture.verse;

  void showBookmarks() {
    app.switchBookmarkWithNotify();
  }

  void showBooks() {
    route
        .showSheetModal(
      context: context,
      name: 'sheet-bible-navigation/recto-book',
    )
        .then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        });
      }
    });
  }

  void showChapters() {
    route.showSheetModal(
      context: context,
      name: 'sheet-bible-navigation/recto-book',
      arguments: {'book': primaryScripture.bookCurrent.info.id},
    ).then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
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
              return route.show('pop-options').child;
            },
          ),
        )
        .then((value) {});
  }
}
