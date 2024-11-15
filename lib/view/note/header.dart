part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts.fixed(
      left: const [
        Buttons.backOrMenu(),
      ],
      primary: ViewBarTitle(
        label: lang.note('false'),
      ),
      right: [
        ValueListenableBuilder(
          key: const ValueKey('fe'),
          valueListenable: App.core.data.boxOfBookmarks.listen(),
          // valueListenable: App.core.data.boxOfBooks.listen(),
          builder: (BuildContext context, Box<BookmarksType> box, Widget? child) {
            return ViewButtons(
              enable: box.isNotEmpty,
              onPressed: onDeleteAllConfirmWithDialog,
              message: lang.clear,
              child: const ViewMarks(
                icon: Icons.clear_all_rounded,
              ),
            );
          },
        ),
      ],
    );
  }
}
