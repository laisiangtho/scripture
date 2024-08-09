part of 'main.dart';

mixin _Header on _State {
  Widget headerOld(BuildContext context, ViewHeaderData vhd) {
    // double width = MediaQuery.of(context).size.width * 0.5;
    double width = state.fromContext.size.width * 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ViewButtons(
          key: _kBookmarks,
          message: preference.text.addTo(preference.text.bookmark('true')),
          onPressed: showBookmarks,
          child: Selector<Core, bool>(
            selector: (_, e) => e.scripturePrimary.bookmarked,
            builder: (BuildContext context, bool hasBookmark, Widget? child) {
              return ViewMarks(
                icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                iconColor:
                    hasBookmark ? Theme.of(context).hintColor : Theme.of(context).dividerColor,
                iconSize: (vhd.shrink * 26).clamp(20, 26),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewButtons(
                showShadow: true,
                color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
                constraints: BoxConstraints(maxWidth: width, minWidth: 48),
                borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(30, 70)),
                padding: EdgeInsets.fromLTRB(10, 1, vhd.snapShrink * 10, 1),
                message: preference.text.book('true'),
                onPressed: showBooks,
                child: Selector<Core, String>(
                  key: _kBooks,
                  selector: (_, e) => e.scripturePrimary.bookName,
                  builder: (BuildContext context, String bookName, Widget? child) {
                    return ViewMarks(
                      label: bookName,
                      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: (vhd.shrink * 18).clamp(15, 18),
                          ),
                    );
                  },
                ),
              ),
              // Divider(
              //   indent: 1 * vhd.snapShrink,
              // ),

              ViewButtons(
                showShadow: true,
                color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
                constraints: BoxConstraints(maxWidth: width, minWidth: 35),
                borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(30, 70)),
                padding: EdgeInsets.fromLTRB(2, 1, vhd.snapShrink * 5, 1),
                message: preference.text.chapter('true'),
                onPressed: showChapters,
                child: Selector<Core, String>(
                  key: _kChapters,
                  selector: (_, e) => e.scripturePrimary.chapterName,
                  builder: (BuildContext context, String chapterName, Widget? child) {
                    return ViewMarks(
                      label: chapterName,
                      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: (vhd.shrink * 18).clamp(15, 18),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ViewButtons(
          key: _kOptions,
          message: preference.text.option('true'),
          // constraints: const BoxConstraints(minWidth: 50.0),
          // color: Theme.of(context).backgroundColor,
          // padding: EdgeInsets.symmetric(
          //   vertical: (data.shrink * 12).clamp(6, 12).toDouble(),
          //   horizontal: 7,
          // ),
          // alignment: Alignment.center,
          // padding: const EdgeInsets.only(right: 13),
          onPressed: showOptions,
          // badge: '12',
          // child: Icon(
          //   LideaIcon.textSize,
          //   size: (data.shrink * 26).clamp(20, 26),
          // ),
          child: ViewMarks(
            // padding: const EdgeInsets.only(right: 13),
            child: Icon(
              LideaIcon.textSize,
              size: (vhd.shrink * 26).clamp(20, 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, ViewHeaderData vhd) {
    double width = state.fromContext.size.width * 0.4;
    return ViewHeaderLayouts.column(
      data: vhd,
      alignment: Alignment.center,
      primary: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ViewButtons(
              showShadow: true,
              color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
              constraints: BoxConstraints(maxWidth: width, minWidth: 48),
              // borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(5, 10)),
              borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(15, 25)),
              padding: EdgeInsets.fromLTRB(7, 1, vhd.snapShrink * 7, 1),
              // message: preference.text.book('true') +' '+ primaryScripture.bookName,
              message: 'books- bookName'
                  .replaceFirst('books', preference.text.book(''))
                  .replaceFirst('bookName', primaryScripture.bookName),
              onPressed: showBooks,
              child: Selector<Core, String>(
                key: _kBooks,
                selector: (_, e) => e.scripturePrimary.bookName,
                builder: (BuildContext context, String bookName, Widget? child) {
                  return ViewMarks(
                    label: bookName,
                    overflow: TextOverflow.fade,
                    labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: (vhd.shrink * 18).clamp(15, 18),
                        ),
                  );
                },
              ),
            ),
            // Divider(
            //   indent: 1 * vhd.snapShrink,
            // ),
            ViewButtons(
              showShadow: true,
              color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
              constraints: BoxConstraints(maxWidth: width, minWidth: 35),
              // borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(5, 7)),
              borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(15, 25)),
              padding: EdgeInsets.fromLTRB(1, 1, vhd.snapShrink * 2, 1),
              message: preference.text.chapter(''),
              onPressed: showChapters,
              child: Selector<Core, String>(
                key: _kChapters,
                selector: (_, e) => e.scripturePrimary.chapterName,
                builder: (BuildContext context, String chapterName, Widget? child) {
                  return ViewMarks(
                    label: chapterName,
                    labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: (vhd.shrink * 18).clamp(15, 18),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      right: [
        ViewDelays.milliseconds(
          milliseconds: 400,
          builder: (_, snap) {
            return ViewButtons(
              key: _kBookmarks,
              message: preference.text.addTo(preference.text.bookmark('true')),
              onPressed: showBookmarks,
              // child: Selector<Core, bool>(
              //   selector: (_, e) => e.scripturePrimary.bookmarked,
              //   builder: (BuildContext context, bool hasBookmark, Widget? child) {
              //     return ViewMarks(
              //       icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
              //       iconColor:
              //           hasBookmark ? Theme.of(context).hintColor : Theme.of(context).dividerColor,
              //       iconSize: (vhd.shrink * 26).clamp(20, 26),
              //     );
              //   },
              // ),
              child: ValueListenableBuilder(
                valueListenable: App.core.data.boxOfBookmarks.listen(),
                builder: (BuildContext _, Box<BookmarksType> __, Widget? child) {
                  // final has = primaryScripture.bookmarked;
                  // return ViewMarks(
                  //   icon: has ? Icons.bookmark_added : Icons.bookmark_add,
                  //   iconColor: has ? state.theme.hintColor : state.theme.dividerColor,
                  //   iconSize: (vhd.shrink * 26).clamp(20, 26),
                  // );
                  return Selector<Core, bool>(
                    selector: (_, e) => e.scripturePrimary.bookmarked,
                    builder: (BuildContext context, bool has, Widget? child) {
                      return ViewMarks(
                        icon: has ? Icons.bookmark_added : Icons.bookmark_add,
                        iconColor: has ? state.theme.hintColor : state.theme.dividerColor,
                        iconSize: (vhd.shrink * 24).clamp(20, 24),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        // ViewButtons(
        //   onPressed: () {},
        //   child: ViewMarks(
        //     child: Icon(
        //       LideaIcon.play,
        //       size: (vhd.shrink * 26).clamp(20, 26),
        //     ),
        //   ),
        // ),
        AnimatedBuilder(
          animation: primaryScripture.marks,
          builder: (BuildContext context, _) {
            // return const Text('data');
            final vse = primaryScripture.marks.verseSelection;
            return ViewButtons(
              key: _kOptions,
              // enable: value.isNotEmpty,
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              onPressed: showOptions,
              child: ViewMarks(
                // icon: LideaIcon.clipboardList,
                // icon: LideaIcon.checklist,
                icon: vse.isEmpty ? LideaIcon.textSize : LideaIcon.popup,
                // icon: value.isEmpty ? LideaIcon.dotHoriz : LideaIcon.dotTwo,
                // icon: Icons.grain_rounded,
                // icon: Icons.more_vert,
                // icon: LideaIcon.layers,
                iconColor: vse.isEmpty ? null : Theme.of(context).highlightColor.withOpacity(0.5),
                // iconSize: (vhd.shrink * 27).clamp(20, 30),
                iconSize: (vhd.shrink * 21).clamp(17, 21),
                badge: vse.isNotEmpty ? vse.length.toString() : '',
                // badge: vse.isNotEmpty ? preference.digit(vse.length) : '',
              ),
            );
          },
        ),
        // ValueListenableBuilder<List<int>>(
        //   valueListenable: primaryScripture.marks.verseSelection,
        //   builder: (context, vse, _) {
        //     // if (vse.isEmpty) {
        //     //   return const SizedBox();
        //     // }

        //     return ViewButtons(
        //       key: _kOptions,
        //       // enable: value.isNotEmpty,
        //       padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        //       onPressed: showOptions,
        //       child: ViewMarks(
        //         // icon: LideaIcon.clipboardList,
        //         // icon: LideaIcon.checklist,
        //         icon: vse.isEmpty ? LideaIcon.textSize : LideaIcon.popup,
        //         // icon: value.isEmpty ? LideaIcon.dotHoriz : LideaIcon.dotTwo,
        //         // icon: Icons.grain_rounded,
        //         // icon: Icons.more_vert,
        //         // icon: LideaIcon.layers,
        //         iconColor: vse.isEmpty ? null : Theme.of(context).highlightColor.withOpacity(0.5),
        //         // iconSize: (vhd.shrink * 27).clamp(20, 30),
        //         iconSize: (vhd.shrink * 21).clamp(17, 21),
        //         badge: vse.isNotEmpty ? vse.length.toString() : '',
        //       ),
        //     );
        //   },
        // ),

        // ViewButtons(
        //   key: _kOptions,
        //   onPressed: showOptions,
        //   child: ViewMarks(
        //     child: Icon(
        //       // LideaIcon.textSize,
        //       // LideaIcon.dotHoriz,
        //       // Icons.grain_rounded,
        //       // LideaIcon.clipboardList,
        //       // Icons.assignment,
        //       Icons.more_vert,
        //       color: Theme.of(context).focusColor,
        //       size: (vhd.shrink * 26).clamp(20, 26),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget headerOrg(BuildContext context, ViewHeaderData vhd) {
    double width = state.fromContext.size.width * 0.5;
    return ViewHeaderLayouts(
      data: vhd,
      alignment: Alignment.center,
      left: [
        ViewDelays.milliseconds(
          milliseconds: 400,
          builder: (_, snap) {
            return ViewButtons(
              key: _kBookmarks,
              message: preference.text.addTo(preference.text.bookmark('true')),
              onPressed: showBookmarks,
              // child: Selector<Core, bool>(
              //   selector: (_, e) => e.scripturePrimary.bookmarked,
              //   builder: (BuildContext context, bool hasBookmark, Widget? child) {
              //     return ViewMarks(
              //       icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
              //       iconColor:
              //           hasBookmark ? Theme.of(context).hintColor : Theme.of(context).dividerColor,
              //       iconSize: (vhd.shrink * 26).clamp(20, 26),
              //     );
              //   },
              // ),
              child: ValueListenableBuilder(
                valueListenable: App.core.data.boxOfBookmarks.listen(),
                builder: (BuildContext _, Box<BookmarksType> __, Widget? child) {
                  // final has = primaryScripture.bookmarked;
                  // return ViewMarks(
                  //   icon: has ? Icons.bookmark_added : Icons.bookmark_add,
                  //   iconColor: has ? state.theme.hintColor : state.theme.dividerColor,
                  //   iconSize: (vhd.shrink * 26).clamp(20, 26),
                  // );
                  return Selector<Core, bool>(
                    selector: (_, e) => e.scripturePrimary.bookmarked,
                    builder: (BuildContext context, bool has, Widget? child) {
                      return ViewMarks(
                        icon: has ? Icons.bookmark_added : Icons.bookmark_add,
                        iconColor: has ? state.theme.hintColor : state.theme.dividerColor,
                        iconSize: (vhd.shrink * 26).clamp(20, 26),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
      primary: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ViewButtons(
            showShadow: true,
            color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
            constraints: BoxConstraints(maxWidth: width, minWidth: 48),
            borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(30, 70)),
            padding: EdgeInsets.fromLTRB(10, 1, vhd.snapShrink * 10, 1),
            message: preference.text.book('true'),
            onPressed: showBooks,
            child: Selector<Core, String>(
              key: _kBooks,
              selector: (_, e) => e.scripturePrimary.bookName,
              builder: (BuildContext context, String bookName, Widget? child) {
                return ViewMarks(
                  label: bookName,
                  labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: (vhd.shrink * 18).clamp(15, 18),
                      ),
                );
              },
            ),
          ),
          // Divider(
          //   indent: 1 * vhd.snapShrink,
          // ),
          ViewButtons(
            showShadow: true,
            color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
            constraints: BoxConstraints(maxWidth: width, minWidth: 35),
            borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(30, 70)),
            padding: EdgeInsets.fromLTRB(2, 1, vhd.snapShrink * 5, 1),
            message: preference.text.chapter('true'),
            onPressed: showChapters,
            child: Selector<Core, String>(
              key: _kChapters,
              selector: (_, e) => e.scripturePrimary.chapterName,
              builder: (BuildContext context, String chapterName, Widget? child) {
                return ViewMarks(
                  label: chapterName,
                  labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: (vhd.shrink * 18).clamp(15, 18),
                      ),
                );
              },
            ),
          ),
        ],
      ),
      right: [
        ViewButtons(
          key: _kOptions,
          onPressed: showOptions,
          child: ViewMarks(
            child: Icon(
              LideaIcon.textSize,
              size: (vhd.shrink * 26).clamp(20, 26),
            ),
          ),
        ),
        // ViewButtons(
        //   onPressed: () {},
        //   child: ViewMarks(
        //     child: Icon(
        //       LideaIcon.menu,
        //       size: (vhd.shrink * 20).clamp(15, 20),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
