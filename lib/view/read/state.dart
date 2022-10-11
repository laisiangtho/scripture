part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _kBookmarks = GlobalKey();
  final _kBooks = GlobalKey();
  final _kChapters = GlobalKey();
  final _kOptions = GlobalKey();

  @override
  void initState() {
    super.initState();
    primaryScripture.scroll = _controller;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    primaryScripture.scroll = _controller;
  }

  Scripture get primaryScripture => core.scripturePrimary;
  List<VERSE> get primaryVerse => primaryScripture.verse;

  void setFontSize(bool increase) {
    debugPrint('setFontSize; $increase');
    core.data.boxOfSettings.fontSizeModify(increase);
  }

  void showBookmarks() {
    // Navigator.of(context).push(
    //   PageRouteBuilder<int>(
    //     settings: RouteSettings(
    //       arguments: {
    //         'render': _kBookmarks.currentContext!.findRenderObject() as RenderBox,
    //         'setFontSize': setFontSize,
    //         'test': 'hello world',
    //       },
    //     ),
    //     opaque: false,
    //     barrierDismissible: true,
    //     transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
    //       return FadeTransition(
    //         opacity: x,
    //         child: child,
    //       );
    //     },
    //     pageBuilder: (_, __, ___) {
    //       return App.route.show('pop-bookmarks').child;
    //     },
    //   ),
    // );
    core.switchBookmarkWithNotify();
  }

  void showBooks() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<Map<String, int>?>(
        settings: RouteSettings(
          arguments: {
            'render': _kBooks.currentContext!.findRenderObject() as RenderBox,
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
          return App.route.show('pop-books').child;
        },
      ),
    )
        .then((e) {
      if (e != null) {
        // debugPrint(e);
        core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        // setBook(e);
      }
    });
  }

  void showChapters() {
    Navigator.of(context).push(
      PageRouteBuilder<int>(
        settings: RouteSettings(
          arguments: {
            'render': _kChapters.currentContext!.findRenderObject() as RenderBox,
          },
        ),
        // transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        opaque: false,
        barrierDismissible: true,
        // transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
        //   return FadeTransition(
        //     opacity: x,
        //     child: child,
        //   );
        // },
        pageBuilder: (_, __, ___) {
          return App.route.show('pop-chapters').child;
        },
      ),
    );
  }

  void showOptions() {
    Navigator.of(context)
        .push(
          PageRouteBuilder<int>(
            settings: RouteSettings(
              arguments: {
                'render': _kOptions.currentContext!.findRenderObject() as RenderBox,
                'setFontSize': setFontSize,
                'test': 'hello world',
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
