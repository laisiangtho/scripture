part of 'main.dart';

mixin _Bar on _State {
  final double minHeight = kBottomNavigationBarHeight - 20;
  // final double maxHeight = kBottomNavigationBarHeight-minHeight;

  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      // reservedPadding: MediaQuery.of(context).padding.top,
      padding: MediaQuery.of(context).viewPadding,
      heights: [minHeight, kBottomNavigationBarHeight - minHeight],
      // overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        double width = MediaQuery.of(context).size.width / 2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: const Alignment(-1, 0),
              child: Hero(
                tag: 'appbar-left-2',
                child: CupertinoButton(
                  // padding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  // padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  minSize: 30,
                  // child: WidgetLabel(
                  //   icon: Icons.bookmark_add,
                  //   iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                  //   message: translate.back,
                  // ),
                  child: Selector<Core, bool>(
                      selector: (_, e) => e.scripturePrimary.bookmarked,
                      builder: (BuildContext context, bool hasBookmark, Widget? child) {
                        // return Icon(
                        //   // LaiSiangthoIcon.bookmark,
                        //   hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                        //   // color: hasBookmark ? Colors.red : Colors.grey,
                        //   // color: Theme.of(context).primaryColorDark,
                        //   color: hasBookmark
                        //       ? Theme.of(context).highlightColor
                        //       : Theme.of(context).primaryColorDark,
                        //   size: (org.shrink * 23).clamp(18, 23).toDouble(),
                        // );
                        return WidgetLabel(
                          icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                          iconColor: hasBookmark
                              ? Theme.of(context).highlightColor
                              : Theme.of(context).primaryColorDark,
                          iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                          // message: translate.bookmark(false),
                          message: preference.text.addTo(preference.text.bookmark(true)),
                        );
                      }),
                  onPressed: core.switchBookmarkWithNotify,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Hero(
                tag: 'appbar-center-2',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      child: AnimatedContainer(
                        key: kBookButton,
                        duration: const Duration(milliseconds: 100),
                        constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                        padding: EdgeInsets.symmetric(vertical: org.shrink * 12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor.withOpacity(snap.shrink),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.elliptical(20, 50),
                            ),
                          ),
                          // child: _barButton(
                          //   label: translate.headline,
                          //   padding: const EdgeInsets.symmetric(horizontal: 7),
                          //   message: 'Book',
                          //   shrink: org.shrink,
                          //   onPressed: showBookList,
                          // ),
                          child: Selector<Core, String>(
                            selector: (_, e) => e.scripturePrimary.bookName,
                            builder: (BuildContext context, String bookName, Widget? child) {
                              return _barButton(
                                label: bookName,
                                message: preference.text.book(true),
                                shrink: org.shrink,
                                onPressed: showBookList,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 10,
                      color: Theme.of(context).backgroundColor.withOpacity(org.stretch),
                    ),
                    Align(
                      child: AnimatedContainer(
                        key: kChapterButton,
                        duration: const Duration(milliseconds: 100),
                        constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                        padding: EdgeInsets.symmetric(vertical: org.shrink * 12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor.withOpacity(snap.shrink),
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.elliptical(20, 50),
                            ),
                          ),
                          // child: CupertinoButton(
                          //   padding: EdgeInsets.zero,
                          //   child: Text(
                          //     '150',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyLarge!
                          //         .copyWith(fontSize: (org.shrink * 19).clamp(15, 19)),
                          //   ),
                          //   onPressed: () => true,
                          // ),
                          child: Selector<Core, String>(
                            selector: (_, e) => e.scripturePrimary.chapterName,
                            builder: (BuildContext context, String chapterName, Widget? child) {
                              return _barButton(
                                label: chapterName,
                                message: preference.text.chapter(true),
                                shrink: org.shrink,
                                onPressed: showChapterList,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(1, 0),
              child: Hero(
                tag: 'appbar-right-2',
                child: AnimatedContainer(
                  key: kOptionButton,
                  duration: const Duration(milliseconds: 0),
                  constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                  padding: EdgeInsets.symmetric(vertical: snap.shrink * 12),
                  child: CupertinoButton(
                    // padding: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                    minSize: 30,
                    child: WidgetLabel(
                      icon: LideaIcon.textSize,
                      iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                      message: preference.text.fontSize,
                    ),
                    onPressed: showOptionList,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _barButton({
    Key? key,
    required double shrink,
    required String label,
    required String message,
    // EdgeInsetsGeometry? padding = EdgeInsets.zero,
    required void Function()? onPressed,
  }) {
    return Tooltip(
      message: message,
      child: CupertinoButton(
        key: key,
        minSize: 33,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: (shrink * 18).clamp(15, 18),
              ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void showBookList() {
    // if (isNotReady) return null;
    // if(kBookButton.currentContext!=null) return;

    Navigator.of(context)
        .push(
      PageRouteBuilder<Map<String?, int?>>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, _y, Widget child) {
          return FadeTransition(opacity: x, child: child);
        },
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext _, _x, _y) {
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
        transitionsBuilder: (BuildContext _, Animation<double> x, _y, Widget child) {
          return FadeTransition(opacity: x, child: child);
        },
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext _, _x, _y) {
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
        transitionsBuilder: (BuildContext _, Animation<double> x, _y, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        pageBuilder: (BuildContext _, _x, _y) {
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
