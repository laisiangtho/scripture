part of 'main.dart';

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    double width = context.sizeOf.width * 0.4;

    return ViewBarLayouts.column(
      data: vbd,
      alignment: Alignment.center,
      left: const [
        Buttons.backOrMenu(),
      ],
      primary: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ViewButtons(
              showShadow: true,
              color: theme.primaryColor.withOpacity(vbd.shrink),
              constraints: BoxConstraints(
                maxWidth: width,
                minWidth: 48,
                maxHeight: 42,
              ),
              borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(5, 7)),
              padding: EdgeInsets.fromLTRB(12, 1, vbd.shrink * 12, 1),
              message: 'books- bookName'
                  .replaceFirst('books', lang.book(''))
                  .replaceFirst('bookName', primaryScripture.bookName),
              onPressed: showBooks,
              child: Selector<Core, String>(
                key: _kBooks,
                selector: (_, e) => e.scripturePrimary.bookName,
                builder: (BuildContext context, String bookName, Widget? child) {
                  return ViewMarks(
                    label: bookName,
                    overflow: TextOverflow.fade,
                    labelStyle: style.titleLarge!.copyWith(
                      fontSize: (vbd.shrink * 18).clamp(15, 18),
                    ),
                  );
                },
              ),
            ),
            ViewButtons(
              showShadow: true,
              color: theme.primaryColor.withOpacity(vbd.shrink),
              constraints: BoxConstraints(
                maxWidth: width,
                minWidth: 35,
                maxHeight: 42,
              ),
              borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(5, 7)),
              padding: EdgeInsets.fromLTRB(1, 1, vbd.shrink * 2, 1),
              message: lang.chapter(''),
              onPressed: showChapters,
              child: Selector<Core, String>(
                key: _kChapters,
                selector: (_, e) => e.scripturePrimary.chapterName,
                builder: (BuildContext context, String chapterName, Widget? child) {
                  return ViewMarks(
                    label: chapterName,
                    labelStyle: style.titleLarge!.copyWith(
                      fontSize: (vbd.shrink * 18).clamp(15, 18),
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
              // message:lang.addTo(lang.bookmark('true')),
              message: lang.bookmark(''),
              onPressed: showBookmarks,

              child: ValueListenableBuilder(
                valueListenable: data.boxOfBookmarks.listen(),
                builder: (BuildContext _, Box<BookmarksType> __, Widget? child) {
                  return Selector<Core, bool>(
                    selector: (_, e) => e.scripturePrimary.bookmarked,
                    builder: (BuildContext context, bool has, Widget? child) {
                      return ViewMarks(
                        icon: has ? Icons.bookmark_added : Icons.bookmark_add,
                        iconColor: has ? theme.hintColor : theme.dividerColor,
                        iconSize: (vbd.shrink * 24).clamp(20, 24),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: primaryScripture.marks,
          builder: (BuildContext context, _) {
            final vse = primaryScripture.marks.verseSelection;
            return ViewButtons(
              key: _kOptions,
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              message: lang.more,
              onPressed: showOptions,
              child: ViewMarks(
                icon: vse.isEmpty ? LideaIcon.textSize : LideaIcon.popup,
                iconColor: vse.isEmpty ? null : theme.highlightColor.withOpacity(0.5),
                iconSize: (vbd.shrink * 21).clamp(17, 21),
                badge: vse.isNotEmpty ? vse.length.toString() : '',
              ),
            );
          },
        ),
      ],
    );
  }
}
