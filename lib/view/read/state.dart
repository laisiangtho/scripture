part of 'main.dart';

abstract class _State extends CommonStates<Main> {
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
    //   app.message.value = 'Testing';
    //   Future.delayed(const Duration(milliseconds: 1000), () {
    //     app.message.value = '';
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
    final msh = app.route.showModalSheet<Map<String, dynamic>?>(
      child: app.route.sheetConfig(
        name: '/recto-book',
      ),
    );

    msh.then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        });
      }
    });
  }

  void showChapters() {
    final msh = app.route.showModalSheet<Map<String, dynamic>?>(
      child: app.route.sheetConfig(
        name: '/recto-book',
        extra: {'book': primaryScripture.bookCurrent.info.id},
      ),
    );

    msh.then((e) {
      if (e != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          app.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        });
      }
    });
  }

  void showOptions() {
    context.push(
      '/pop-options',
      extra: {
        'render': _kOptions.currentContext!.findRenderObject() as RenderBox,
      },
    );
  }
}
