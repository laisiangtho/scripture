part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    double width = MediaQuery.of(context).size.width * 0.5;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: org.snapShrink * 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetButton(
            constraints: const BoxConstraints(maxWidth: 56, minWidth: 40.0, maxHeight: 40),
            message: preference.text.addTo(preference.text.bookmark(true)),
            onPressed: core.switchBookmarkWithNotify,
            child: Selector<Core, bool>(
              selector: (_, e) => e.scripturePrimary.bookmarked,
              builder: (BuildContext context, bool hasBookmark, Widget? child) {
                return WidgetLabel(
                  icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                  iconColor: hasBookmark
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColorDark,
                  iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetButton(
                  key: kBookButton,
                  constraints: BoxConstraints(maxWidth: width, minWidth: 48),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor.withOpacity(org.snapShrink),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.elliptical(20, 50),
                    ),
                  ),
                  message: preference.text.book(true),
                  onPressed: showBookList,
                  child: Selector<Core, String>(
                    selector: (_, e) => e.scripturePrimary.bookName,
                    builder: (BuildContext context, String bookName, Widget? child) {
                      return _barButton(
                        label: bookName,
                        shrink: org.shrink,
                        padding: EdgeInsets.fromLTRB(7, 0, org.snapShrink * 5, 0),
                      );
                    },
                  ),
                ),
                Divider(
                  indent: 1 * org.snapShrink,
                ),
                WidgetButton(
                  key: kChapterButton,
                  constraints: BoxConstraints(maxWidth: width, minWidth: 35),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor.withOpacity(org.snapShrink),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.elliptical(20, 50),
                    ),
                  ),
                  message: preference.text.chapter(true),
                  onPressed: showChapterList,
                  child: Selector<Core, String>(
                    selector: (_, e) => e.scripturePrimary.chapterName,
                    builder: (BuildContext context, String chapterName, Widget? child) {
                      return _barButton(
                        label: chapterName,
                        shrink: org.shrink,
                        padding: const EdgeInsets.fromLTRB(3, 0, 5, 0),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          WidgetButton(
            key: kOptionButton,
            constraints: const BoxConstraints(maxWidth: 56, minWidth: 50.0),
            message: preference.text.fontSize,
            onPressed: showOptionList,
            child: WidgetLabel(
              icon: LideaIcon.textSize,
              iconColor: Theme.of(context).primaryColorDark,
              iconSize: (org.shrink * 22).clamp(18, 22).toDouble(),
            ),
          )
        ],
      ),
    );
  }

  Widget _barButton({
    required double shrink,
    required String label,
    required EdgeInsetsGeometry padding,
  }) {
    return WidgetLabel(
      label: label,
      labelPadding: padding,
      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: (shrink * 18).clamp(15, 18),
          ),
    );
  }

  void showBookList() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<Map<String?, int?>>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(opacity: x, child: child);
        },
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext _, __, ___) {
          return PopBookList(
            render: kBookButton.currentContext!.findRenderObject() as RenderBox,
          );
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

  void showChapterList() {
    // if (isNotReady) return null;
    Navigator.of(context)
        .push(
      PageRouteBuilder<int>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(opacity: x, child: child);
        },
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext _, __, ___) {
          return PopChapterList(
            render: kChapterButton.currentContext!.findRenderObject() as RenderBox,
          );
        },
      ),
    )
        .then((e) {
      setChapter(e);
    });
  }

  void showOptionList() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<int>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        pageBuilder: (BuildContext _, __, ___) {
          return PopOptionList(
            render: kOptionButton.currentContext!.findRenderObject() as RenderBox,
            setFontSize: setFontSize,
          );
        },
      ),
    )
        .whenComplete(() {
      // core.writeCollection();
    });
  }
}
